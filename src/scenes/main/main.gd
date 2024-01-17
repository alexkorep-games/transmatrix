extends Control

var field_size = Vector2(8, 8)

# Called when the node enters the scene tree for the first time.
func _ready():
	init_field()
	var field = get_node("%FieldTileMap")
	var current_shape = get_node("%CurrentShape")
	if GameState.is_free_play:
		GameState.load_game_free_play(field, current_shape.get_tilemap())
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
	if GameState.is_free_play:
		GameState.save_game_free_play(field, tilemap)

func randomize_shape():
	var current_shape = get_node("%CurrentShape")
	var possible_shapes = get_node("%Shapes").get_children()
	current_shape.randomize(possible_shapes)
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

	var current_shape_container = get_node("%CurrentShape")
	current_shape_container.can_be_placed = can_be_placed
	current_shape_container.visible = not shape_covers_preview


func _on_CurrentShape_place(block_positions, tile_ids):
	var field = get_node("%FieldTileMap")
	for i in range(len(block_positions)):
		var pos = block_positions[i]
		var tile_id = tile_ids[i]
		# Get the tile from the field at this global position
		var local_pos = field.to_local(pos)
		var cell_pos = field.world_to_map(local_pos)
		field.set_cellv(cell_pos, tile_id)
	var removed_blocks = field.remove_groups()
	if len(removed_blocks) > 0:
		do_block_removal_animation(removed_blocks)
		var score = len(removed_blocks)
		GameState.increase_score(score)
		if not GameState.is_free_play:
			if GameState.score >= Story.get_required_score():
				# TODO play animation
				get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")
	
	var preview_field = get_node("%PreviewTileMap")
	preview_field.clear()
	randomize_shape()
	var current_shape = get_node("%CurrentShape")
	current_shape.visible = true
	if GameState.is_free_play:
		GameState.save_game_free_play(field, current_shape.get_tilemap())

func _on_CurrentShape_drag_release():
	var preview_field = get_node("%PreviewTileMap")
	preview_field.clear()
	get_node("%CurrentShape").visible = true

func shape_can_be_placed_anywhere(current_shape_tilemap):
	var field = get_node("%FieldTileMap")
	var shape_blocks = current_shape_tilemap.get_used_cells()
	return EndGameChecker.has_more_moves(field, shape_blocks, field_size.x, field_size.y)

func do_block_removal_animation(removed_blocks):
	var field = get_node("%ClearingShapesFieldTileMap")
	field.clear()
	for block in removed_blocks:
		var pos = block["pos"]
		var tile_id = block["tile_id"]
		field.set_cellv(pos, tile_id)
	var animation_player = get_node("%ClearingShapesAnimationPlayer")
	animation_player.play("blink")
	
func _on_HUD_settings_pressed():
	get_node("%SettingsDialog").show()

func _on_StartNewGameConfirmationDialog_confirmed():
	new_game()

func _on_SettingsDialog_new_game():
	get_node("%StartNewGameConfirmationDialog").show()

func _on_ConfirmationDialog_confirmed():
	new_game()

# func _on_PasswordLabel_password_cracked():
# 	get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")


func _on_CheatButton_pressed():
	get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")
