extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CurrentShape_drag(positions, tile_ids):
	var field = get_node("%FieldTileMap")
	var preview_field = get_node("%PreviewTileMap")
	# Remove all cells with num 4
	preview_field.clear()

	for i in range(len(positions)):
		var pos = positions[i]
		var tile_id = tile_ids[i]
		# Get the tile from the field at this global position
		var local_pos = preview_field.to_local(pos)
		var cell_pos = preview_field.world_to_map(local_pos)
		var field_tile = field.get_cellv(pos)
		# TODO check if field_tile != -1, to find out if the shape can be placed
		preview_field.set_cellv(cell_pos, tile_id)
