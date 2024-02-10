extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func generate_next_shape():
	var tiles_stock = get_node("%TilesStock")
	var current_shape = get_node("%CurrentShape")
	var current_shape_tilemap = current_shape.get_tilemap()
	tiles_stock.get_next_shape(current_shape_tilemap)
	current_shape.center()
