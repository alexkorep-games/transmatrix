extends VBoxContainer

signal pressed(episode_idx)

export var title := ""
export var image_filename := ""
export var idx := 0

func _ready():
	get_node("%Label").text = title
	get_node("%TextureRect").texture = load(image_filename)

func _on_EpisodeItem_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("pressed", idx)

