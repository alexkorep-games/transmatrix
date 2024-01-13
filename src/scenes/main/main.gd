extends Control

var field_size = Vector2(8, 8)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CurrentShape_drag(positions, tile_ids):
	var field = get_node("%FieldTileMap")
	var preview_field = get_node("%PreviewTileMap")
	# Remove all cells with num 4
	preview_field.clear()
	var can_be_placed = true

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

		var field_tile = field.get_cellv(cell_pos)
		# Check if field_tile == -1, to find out if the shape can be placed
		if field_tile != -1:
			# The field cell is already occupied
			can_be_placed = false
			continue
		preview_field.set_cellv(cell_pos, tile_id)

	get_node("%CurrentShape").can_be_placed = can_be_placed


func _on_CurrentShape_place(block_positions, tile_ids):
	var field = get_node("%FieldTileMap")
	for i in range(len(block_positions)):
		var pos = block_positions[i]
		var tile_id = tile_ids[i]
		# Get the tile from the field at this global position
		var local_pos = field.to_local(pos)
		var cell_pos = field.world_to_map(local_pos)
		field.set_cellv(cell_pos, tile_id)
	field.remove_groups()
	var preview_field = get_node("%PreviewTileMap")
	preview_field.clear()


func _on_CurrentShape_drag_release():
	var preview_field = get_node("%PreviewTileMap")
	preview_field.clear()
