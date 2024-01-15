extends Node

var story_index = 0
var story_step = 0

func get_password():
	return story[story_index]["password"]

func start_story(index):
	story_index = index
	story_step = 0

func next_step():
	story_step += 1
	
func is_finished():
	return story_step >= len(story[story_index]["steps"])

func is_game():
	return story[story_index]["steps"][story_step]["type"] == "game"

var story = [
	{
		"title": "The Grandma's laptop",
		"password": "grandma",
		"steps":
		[
			{
				"type": "dialog",
				"text":
					"My phone buzzed with a familiar ringtone.",
				"image": "res://assets/levels/001-grandma/phone-ring.png"
			},
			{
				"type": "dialog",
				"text":
					"It was Grandma, sounding flustered as she explained she'd forgotten her laptop's password.",
				"image": "res://assets/levels/001-grandma/grandma.png"
			},
			{
				"type": "dialog",
				"text":
					"I smiled, thinking how much she means to me. \"Don't worry, Grandma, I'll swing by after lunch and sort it out.\"",
				"image": "res://assets/levels/001-grandma/grandma.png"
			},
			{
				"type": "game",
			},
			{
				"type": "dialog",
				"text":
					"\"Oh, thank you, dear!\" she said, \"Have a cookie!\"",
				"image": "res://assets/levels/001-grandma/grandma.png"
			},
		]
	}
]
