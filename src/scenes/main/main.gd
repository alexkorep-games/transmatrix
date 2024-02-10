extends Control

var field_size = Vector2(8, 8)

var tile_removal_scene = preload("res://scenes/main/tile_removal.tscn")

var blocks_to_place = []
var tile_ids_to_place = []
var pending_tile_removals = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	init_field()
	var field = get_node("%FieldTileMap")
	var current_shape = get_node("%CurrentShape")
	var next_shape_tilemap = get_node("%NextShapeTileMap")
	if GameState.is_free_play:
		GameState.load_game_free_play(field, current_shape.get_tilemap(), next_shape_tilemap)
	current_shape.center()
	
func init_field():
	var field = get_node("%FieldTileMap")
	field.clear()
	GameState.reset_score()
	randomize_shape()
	var hud = get_node("%HUD")
	hud.show_progress = not GameState.is_free_play

func new_game():
	init_field()
	var field = get_node("%FieldTileMap")
	var tilemap = get_node("%CurrentShape").get_tilemap()
	var next_shape_tilemap = get_node("%NextShapeTileMap")
	if GameState.is_free_play:
		GameState.save_game_free_play(field, tilemap, next_shape_tilemap)

func randomize_shape():
	var current_shape = get_node("%CurrentShape")
	var possible_shapes = get_node("%Shapes").get_children()
	var next_shape_tilemap = get_node("%NextShapeTileMap")
	current_shape.pick_next(possible_shapes, next_shape_tilemap)
	if not shape_can_be_placed_anywhere(current_shape.get_tilemap()):
		get_node("%GameOverDialog").show()

func _on_CurrentShape_drag(positions, tile_ids):
	var field = get_node("%FieldTileMap")
	var preview_field = get_node("%PreviewTileMap")
	# Remove all cells with num 4
	preview_field.clear()
	var can_be_placed = true
	var shape_covers_preview = false

	for i in range(len(positions)):
		var pos = positions[i]
		var tile_id = tile_ids[i]
		# Get the tile from the field at this global position
		var local_pos = preview_field.to_local(pos)
		var cell_pos = preview_field.world_to_map(local_pos)
		# check if cell_pos is between (0,0) and field_size
		if cell_pos.x < 0 or cell_pos.x >= field_size.x or cell_pos.y < 0 or cell_pos.y >= field_size.y:
			can_be_placed = false
			continue
		shape_covers_preview = true
		preview_field.set_cellv(cell_pos, tile_id)

		var field_tile = field.get_cellv(cell_pos)
		# Check if field_tile == -1, to find out if the shape can be placed
		if field_tile != -1:
			# The field cell is already occupied
			can_be_placed = false
			continue

	preview_field.visible = can_be_placed
	var current_shape_container = get_node("%CurrentShape")
	current_shape_container.can_be_placed = can_be_placed
	current_shape_container.visible = not can_be_placed


func _on_CurrentShape_place(block_positions, tile_ids):
	blocks_to_place = block_positions
	tile_ids_to_place = tile_ids
	# Start shaking the field
	var animation_player = get_node("%FieldAnimationPlayer")
	animation_player.play("shake_shape")

func _on_FieldAnimationPlayer_animation_finished(anim_name):
	if anim_name == "shake_shape":
		# Field shaking finished
		# Make preview back to transparent
		# TODO maybe use an animation?
		var preview_field = get_node("%PreviewTileMap")
		preview_field.modulate = Color(1, 1, 1, 0.5)
		#get_node("%PlaceShapeParticles").emit(blocks_to_place)
		place_shape_on_field()
		remove_the_blocks_of_the_same_colors()
		prepare_next_shape()

func place_shape_on_field():
	# Place the shape on the field
	var field = get_node("%FieldTileMap")
	for i in range(len(blocks_to_place)):
		var pos = blocks_to_place[i]
		var tile_id = tile_ids_to_place[i]
		# Get the tile from the field at this global position
		var local_pos = field.to_local(pos)
		var cell_pos = field.world_to_map(local_pos)
		field.set_cellv(cell_pos, tile_id)
	blocks_to_place = []
	tile_ids_to_place = []

func remove_the_blocks_of_the_same_colors():
	# Remove the blocks of the same color
	# TODO play removing animation
	var field = get_node("%FieldTileMap")
	var removed_blocks = field.remove_groups()
	if len(removed_blocks) > 0:
		do_block_removal_animation(removed_blocks)

func prepare_next_shape():
	# Randomize the next shape
	var preview_field = get_node("%PreviewTileMap")
	var current_shape = get_node("%CurrentShape")
	var next_shape = get_node("%NextShapeTileMap")
	var field = get_node("%FieldTileMap")
	preview_field.clear()
	randomize_shape()
	current_shape.visible = true
	if GameState.is_free_play:
		GameState.save_game_free_play(field, current_shape.get_tilemap(), next_shape)

func _on_CurrentShape_drag_release():
	var preview_field = get_node("%PreviewTileMap")
	preview_field.clear()
	get_node("%CurrentShape").visible = true

func shape_can_be_placed_anywhere(current_shape_tilemap):
	var field = get_node("%FieldTileMap")
	var shape_blocks = current_shape_tilemap.get_used_cells()
	return EndGameChecker.has_more_moves(field, shape_blocks, field_size.x, field_size.y)

func do_block_removal_animation(removed_blocks):
	var field = get_node("%FieldTileMap")

	# Build the tile removal animations
	for block in removed_blocks:
		# Restore the removed blocks, so that they can be removed with the animation
		var tile_id = block["tile_id"]
		var pos = block["pos"]
		field.set_cellv(pos, tile_id)

		var tile_removal = tile_removal_scene.instance()
		tile_removal.tile_position = pos
		tile_removal.tile_id = tile_id
		tile_removal.connect("finished", self, "_on_TileRemoval_finished")
		pending_tile_removals.append(tile_removal)
	# Start it for the fist tile
	start_tile_removal_animation()

func start_tile_removal_animation():
	var field = get_node("%FieldTileMap")
	var tilemaps = get_node("%TileMaps")
	# Start the tile remove animation
	var tile_removal = pending_tile_removals.pop_front()
	if tile_removal:
		tilemaps.add_child(tile_removal)
		# Actually clear the field block
		field.set_cellv(tile_removal.tile_position, -1)

func _on_TileRemoval_finished():
	# animate scrore increase
	GameState.increase_score(1)
	if not GameState.is_free_play:
		if GameState.score >= Story.get_required_score():
			# TODO play animation
			get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")
	# Animate the next tile removel
	start_tile_removal_animation()
	
func _on_HUD_settings_pressed():
	get_node("%SettingsDialog").show()

func _on_StartNewGameConfirmationDialog_confirmed():
	new_game()

func _on_SettingsDialog_new_game():
	get_node("%StartNewGameConfirmationDialog").show()

func _on_ConfirmationDialog_confirmed():
	new_game()
