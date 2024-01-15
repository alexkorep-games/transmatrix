extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var container = get_node("%VBoxContainer")
	var idx = 0
	for episode in Story.story:
		var button = Button.new()
		button.text = episode.title
		button.connect("pressed", self, "_on_button_pressed", [idx])
		container.add_child(button)
		idx += 1

func _on_button_pressed(index):
	Story.start_story(index)
	get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
