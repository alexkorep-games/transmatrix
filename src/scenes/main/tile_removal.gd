extends Node2D

# Declare member variables here. Examples:
export var tile_id := 0
export var tile_position := Vector2.ZERO

signal finished(tile_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	var block_tile_map = get_node("%BlockTileMap")
	block_tile_map.set_cellv(tile_position, tile_id)
	get_node("%AnimationPlayer").play("remove_block")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("finished", tile_id)
	queue_free()
