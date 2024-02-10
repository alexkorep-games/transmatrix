extends Node

export var tile_id := 0
export var price := [100, 100, 100, 100]

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_map = get_node("%ShapeTileMap")
	for cell in tile_map.get_used_cells():
		tile_map.set_cellv(cell, tile_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


