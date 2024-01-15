extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	update_images_and_text()
	fade_in()

func update_images_and_text():
	var story = Story.story[Story.story_index]
	var steps = story["steps"]
	var step = steps[Story.story_step]

	var image_path = step["image"]
	var image = get_node("%ActorTextureRect")
	image.texture = load(image_path)

	var text = step["text"]
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
		Story.next_step()
		if Story.is_finished():
			get_tree().change_scene("res://scenes/start_screen/start_screen.tscn")
		elif Story.is_game():
			get_tree().change_scene("res://scenes/main/main.tscn")
			# Increment step index, so that next time we start from the next step
			Story.next_step()
		else:
			update_images_and_text()
			fade_in()

func _on_StoryDialog_gui_input(event):
	# if mouse pressed
	if event is InputEventMouseButton and event.pressed:
		next_step()


