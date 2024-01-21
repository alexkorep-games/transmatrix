extends Node2D

# Declare member variables here. Examples:
export var tile_id := 0
export var end_position := Vector2.ZERO

signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	var block_tile_map = get_node("%BlockTileMap")
	block_tile_map.set_cellv(Vector2(0, 0), tile_id)
	var tween = Tween.new()
	# move end_position with the tween
	tween.interpolate_property(self, "position", 
		position, end_position, 20, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	# emit the signal when the tween is finished
	tween.connect("tween_all_completed", self, "on_finished")
	tween.start()

func on_finished():
	emit_signal("finished")
	queue_free()
