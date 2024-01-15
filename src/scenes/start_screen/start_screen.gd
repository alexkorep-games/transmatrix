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


func _on_FreePlayButton_pressed():
	GameState.is_free_play = true
	get_tree().change_scene("res://scenes/main/main.tscn")

func _on_StoryModeButton_pressed():
	GameState.is_free_play = false
	Story.start_story(0)
	get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")
	
