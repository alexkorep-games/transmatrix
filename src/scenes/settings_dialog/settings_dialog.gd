extends WindowDialog


signal new_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	hide()
	emit_signal("new_game")

func _on_CloseButton_pressed():
	hide()


func _on_MainScreenButton_pressed():
	hide()
	get_tree().change_scene("res://scenes/start_screen/start_screen.tscn")
