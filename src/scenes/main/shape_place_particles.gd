extends Node2D


var emitters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	emitters = get_tree().get_nodes_in_group("emitters")

func emit(positions):
	var i = 0
	for position in positions:
		emitters[i].position = position
		emitters[i].emitting = true
		i += 1
