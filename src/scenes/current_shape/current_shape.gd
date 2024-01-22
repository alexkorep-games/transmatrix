extends Node2D

signal drag(block_positions, tile_ids)
signal place(block_positions, tile_ids)
signal drag_release()

var mouse_down = false
var dragging = false
var drag_start = Vector2()
var original_position = Vector2()

var is_rotating = false

var tween = Tween.new()

var DRAG_DISTANCE_THRESHOLD = 10

# Flag indicating if this shape can be placed on the grid
export var can_be_placed = false

# When start dragging, the tilemap will be offset by this amount
export var drag_offset := Vector2()

# When dragging, the tilemap position will be amplified by this amount
export var drag_scale := Vector2(1, 1)

onready var tilemap = get_node("%TileMap")

func get_tilemap():
	return tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)
	tween.connect("tween_completed", self, "on_tween_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if not mouse_down:
			# Check if the mouse is over the parent Control node of the TileMap
			var mouse_position = get_global_mouse_position()
			var mouse_over_parent = get_parent().get_rect().has_point(mouse_position)
			if not mouse_over_parent:
				return
			mouse_down = true
			drag_start = mouse_position
			original_position = position
	else:
		if mouse_down:
			mouse_down = false
			if dragging:
				dragging = false
				if can_be_placed:
					place()
				else:
					go_back()
			else:
				# Rotate the TileMap by 90 degrees
				rotate_me()

	var distance_between_origin_and_mouse = (get_global_mouse_position() - drag_start).length()
	if distance_between_origin_and_mouse > DRAG_DISTANCE_THRESHOLD and mouse_down:
		dragging = true

	if dragging:
		var drag_current = get_global_mouse_position()
		var drag_delta = drag_current - drag_start
		position = original_position + drag_delta*drag_scale + drag_offset

		emit_drag_signal()

func go_back():
	# Use tween to animate the tilemap back to the original position
	# that means that position property should be animated to original_position value
	tween.interpolate_property(self, "position", position, original_position, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	emit_signal("drag_release")

func rotate_me():
	if is_rotating:
		return

	center()
	# Implement rotation of the tilemap by 90 degrees using tween
	tween.interpolate_property(self, "rotation_degrees", 
		rotation_degrees, rotation_degrees + 90, 0.2,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	is_rotating = true

func on_tween_completed(object, key):
	is_rotating = false
	if key == ":rotation_degrees":
		rotation_degrees = 0
		rotate_tilemap_90_degrees_clockwise()
		center()

func rotate_tilemap_90_degrees_clockwise():
	var original_tiles = []
	var max_x = 0
	var max_y = 0

	# Store original tile data and find max_x and max_y
	for cell in tilemap.get_used_cells():
			original_tiles.append({"position": cell, "id": tilemap.get_cellv(cell)})
			max_x = max(max_x, cell.x)
			max_y = max(max_y, cell.y)

	# Clear TileMap
	tilemap.clear()

	# Calculate new positions and set tiles
	for tile in original_tiles:
			var old_pos = tile["position"]
			var new_pos = Vector2(max_y - old_pos.y, old_pos.x)
			tilemap.set_cellv(new_pos, tile["id"])


func get_block_positions():
	var block_positions = []
	var tile_size = tilemap.cell_size * tilemap.scale
	for cell in tilemap.get_used_cells():
		var cell_position = tilemap.map_to_world(cell)
		var global_cell_position = tilemap.to_global(cell_position)
		block_positions.append(global_cell_position + tile_size/2)
	return block_positions

func get_tile_ids():
	var tile_ids = []
	for cell in tilemap.get_used_cells():
		var cell_id = tilemap.get_cellv(cell)
		tile_ids.append(cell_id)
	return tile_ids

func emit_place_signal():
	var block_positions = get_block_positions()
	var tile_ids = get_tile_ids()
	emit_signal("place", block_positions, tile_ids)

func emit_drag_signal():
	var block_positions = get_block_positions()
	var tile_ids = get_tile_ids()
	emit_signal("drag", block_positions, tile_ids)

func place():
	emit_place_signal()
	position = original_position
	
func center():
	# Center the tilemap on the parent Control node
	var tilemap_rect = tilemap.get_used_rect()
	tilemap.position = -tilemap_rect.get_center()*tilemap.cell_size*tilemap.scale
