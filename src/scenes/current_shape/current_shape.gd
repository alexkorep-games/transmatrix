extends TileMap

var mouse_down = false
var dragging = false
var drag_start = Vector2()
var original_position = Vector2()

var is_rotating = false

var tween = Tween.new()

var DRAG_DISTANCE_THRESHOLD = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)
	tween.connect("tween_completed", self, "on_tween_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if not mouse_down:
			mouse_down = true
			drag_start = get_global_mouse_position()
			original_position = position
	else:
		if mouse_down:
			mouse_down = false
			if dragging:
				dragging = false
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
		position = original_position + drag_delta

func go_back():
	# Use tween to animate the tilemap back to the original position
	# that means that position property should be animated to original_position value
	tween.interpolate_property(self, "position", position, original_position, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func rotate_me():
	if is_rotating:
		return

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
		rotate_tilemap_90_degrees_clockwise(self)

func rotate_tilemap_90_degrees_clockwise(tilemap: TileMap):
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

