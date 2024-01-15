extends Control


export var story_idx = 0
var story
var steps
var step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	step = 0
	story = Story.story[story_idx]
	steps = story["steps"]
	update_images()
	update_text()
	fade_in()

func update_images():
	var image_path = steps[step]["image"]
	var image = get_node("%ActorTextureRect")
	image.texture = load(image_path)

func update_text():
	var text = steps[step]["text"]
	var label = get_node("%StoryTextLabel")
	label.text = text
	label.start()

func fade_in():
	get_node("%AnimationPlayer").play("message_start")

func fade_out():
	get_node("%AnimationPlayer").play("message_end")
	
func next_step():
	fade_out()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "message_end":
		step += 1
		if step >= len(steps):
			get_tree().change_scene("res://scenes/main/main.tscn")
		else:
			update_images()
			update_text()
			fade_in()

func _on_StoryDialog_gui_input(event):
	# if mouse pressed
	if event is InputEventMouseButton and event.pressed:
		next_step()


