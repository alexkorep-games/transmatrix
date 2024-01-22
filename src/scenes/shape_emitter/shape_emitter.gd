extends Node2D

# This class received the cleared tiles,
# Based on the tiles it generates the next tiles
# to emit

var merge_rules_per_tile = [
	{},
	{ 0: 4 },
	{ 1: 4 },
	{ 2: 4 }
]

var stock_tiles = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_stock(tile_id, qty):
	stock_tiles[tile_id] += qty

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tilemap = get_node("%TileMap")
	var labels = get_node("%Labels").get_children()
	for tile_id in range(len(stock_tiles)):
		var qty = stock_tiles[tile_id]
		var x = tile_id
		tilemap.set_cell(x, 0, tile_id if qty > 0 else -1)
		labels[x].set_text(str(qty) if qty > 0 else "")


func get_next_shape(destination_tilemaps):
	var source_tilemaps = get_node("%Shapes").get_children()
	destination_tilemaps.clear()
	# select random element from source_tilemaps array
	var source_tilemap = source_tilemaps[randi() % source_tilemaps.size()]
	# copy tile data from source_tilemap to this tilemap
	for cell in source_tilemap.get_used_cells():
			var cell_x = cell.x
			var cell_y = cell.y
			var tile_id = source_tilemap.get_cell(cell_x, cell_y)
			if tile_id == -1:
				continue
			# Random between 0 and 3
			var new_tile_id = randi() % 4
			destination_tilemaps.set_cell(cell_x, cell_y, new_tile_id)
