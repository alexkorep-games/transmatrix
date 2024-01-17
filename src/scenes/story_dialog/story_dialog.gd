extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	start_step()

func start_step():
	# Start playing the current step
	var type = Story.get_current_step_type()
	if type == "title":
		start_title_step()
	elif type == "dialog":
		start_dialog_step()
	else:
		start_game_step()

func start_title_step():
	get_node("%AnimationPlayer").play("title_start")

func start_dialog_step():
	var image = get_node("%ActorTextureRect")
	var step = Story.get_current_step()
	if "image" in step:
		var image_path = step["image"]
		image.texture = load(image_path)
		image.show()
	else:
		image.hide()

	var background_path = step["background"]
	var background = get_node("%BackgroundTextureRect")
	background.texture = load(background_path)

	var text = step["text"]
	var label = get_node("%StoryTextLabel")
	label.text = text
	label.start()
	get_node("%AnimationPlayer").play("message_start")

func start_game_step():
	get_tree().change_scene("res://scenes/main/main.tscn")
	# Increment step index, so that next time we start from the next step
	Story.next_step()
	
func _on_StoryDialog_gui_input(event):
	# if mouse pressed
	if event is InputEventMouseButton and event.pressed:
		# Play dialog-end animation	
		var type = Story.get_current_step_type()
		if type == "title":
			print("title_end")
			get_node("%AnimationPlayer").play("title_end")
		elif type == "dialog":
			print("message_end")
			get_node("%AnimationPlayer").play("message_end")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "message_end" or anim_name == "title_end":
		# animation finished, go to the next step
		Story.next_step()
		print("next step")
		if Story.is_finished():
			get_tree().change_scene("res://scenes/start_screen/start_screen.tscn")
		else:
			start_step()

