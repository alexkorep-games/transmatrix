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
	var current_shape = get_node("%CurrentShape")
	load_game_free_play()
	current_shape.center()
	
func init_field():
	var field = get_node("%FieldTileMap")
	field.clear()
	GameState.reset_score()
	generate_next_shape()
	var hud = get_node("%HUD")
	hud.show_progress = not GameState.is_free_play

func new_game():
	init_field()

func generate_next_shape():
	get_node("%ShapesSource").generate_next_shape()
	if not shape_can_be_placed_anywhere(current_shape_tilemap):
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
		place_shape_on_field()
		remove_the_blocks_of_the_same_colors()
		prepare_next_shape()
		# Save it here, and also when tiles removal animation is finished
		save_game_free_play()

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
	preview_field.clear()
	generate_next_shape()
	current_shape.visible = true

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
	else:
		# All tile removed, let's save the game state
		# We also do it after preparing the next shape
		save_game_free_play()
		# TODO also do prepare_next_shape() here
		# if there are some shapes are removed

func _on_TileRemoval_finished(tile_id):
	# animate scrore increase
	GameState.increase_score(1)
	var shapes_stock = get_node("%ShapesStock")
	shapes_stock.add_stock(tile_id, 1)
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


func _on_CheatButton_pressed():
	get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")


func save_tilemap(tilemap, state, field_name):
	state[field_name] = []
	for cell in tilemap.get_used_cells():
		state[field_name].append({
			"cell": cell,
			"tile": tilemap.get_cellv(cell)
		})
	
func load_tilemap(state, tilemap, field_name):
	if field_name in state:
		tilemap.clear()
		for cell in state[field_name]:
			tilemap.set_cellv(cell["cell"], cell["tile"])

func save_game_free_play():
	if not GameState.is_free_play:
		return
	var field = get_node("%FieldTileMap")
	var tilemap = get_node("%CurrentShape").get_tilemap()
	var shapes_stock = get_node("%ShapesStock")
	var state = {}
	save_tilemap(field, state, "field")
	save_tilemap(tilemap, state, "current_shape")
	shapes_stock.save(state)
	GameState.save_game_free_play(state)

func load_game_free_play():
	if not GameState.is_free_play:
		return
	var field = get_node("%FieldTileMap")
	var tilemap = get_node("%CurrentShape").get_tilemap()
	var shapes_stock = get_node("%ShapesStock")
	var state = GameState.load_game_free_play()
	if not state:
		return
	load_tilemap(state, field, "field")
	load_tilemap(state, tilemap, "current_shape")
	shapes_stock.load(state)

func _on_ShopButton_pressed():
	#get_node("%Shop").show()
	pass
