extends Control


export var label_modulate: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("%StoryTitleLabel").text = Story.get_title()
	get_node("%StoryTitleLabel").modulate = label_modulate
