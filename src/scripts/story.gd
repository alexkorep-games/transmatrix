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


func get_current_step():
	return story[story_index]["steps"][story_step]


func get_current_step_type():
	return get_current_step()["type"]


func is_game():
	return story[story_index]["steps"][story_step]["type"] == "game"


func get_required_score():
	return story[story_index]["score_required"]

func get_title():
	return story[story_index]["title"]

var story = [
	{
		"title": "Chapter 1\nThe Broken Traffic Light",
		"score_required": 10,
		"thumbnail_filename": "res://assets/levels/001-traffic-light/street.png",
		"steps":
		[
			{"type": "title", "text": "Chapter 1.\nThe Broken Traffic Light"},
			{
				"type": "dialog",
				"text": "It was Saturday morning, and I was ready to go fishing.",
				"image": "res://assets/levels/001-traffic-light/player.png",
				"background": "res://assets/levels/001-traffic-light/house.png"
			},
			{
				"type": "dialog",
				"text": "But then my phone rang, and it was Laura from the municipality.",
				"image": "res://assets/levels/001-traffic-light/phone-ring.png",
				"background": "res://assets/levels/001-traffic-light/house.png"
			},
			{
				"type": "dialog",
				"text":
				'She said, "We have a job for you. The traffic light is broken, and you need to go there immediately because we sent Billy from the police department there, but he cannot be there for the entire day regulating the traffic."',
				"image": "res://assets/levels/001-traffic-light/laura.png",
				"background": "res://assets/levels/001-traffic-light/house.png"
			},
			{
				"type": "dialog",
				"text":
				"So, yeah, it's my job. I went there, and sure enough, the traffic light wasn't working properly. Both the green and red lights were on. I opened my toolbox, ready to fix it.",
				"image": "res://assets/levels/001-traffic-light/toolbox.png",
				"background": "res://assets/levels/001-traffic-light/street.png"
			},
			{
				"type": "dialog",
				"text":
				"Fixing something is always like a puzzle game for me. You have to arrange the shapes of different colors to make the block colors match. And if you do it well enough, you can fix it.",
					"image": "res://assets/levels/001-traffic-light/rules.png",
				"background": "res://assets/levels/001-traffic-light/street.png"
			},
			{"type": "game"},
			{
				"type": "dialog",
				"text":
				"The traffic lights were fixed, but I noticed that there was something wrong with the schematics. There was a chip that wasn't supposed to be there. I removed the chip and took it with me.",
				"image": "res://assets/levels/001-traffic-light/chip.png",
				"background": "res://assets/levels/001-traffic-light/street.png"
			},
			{
				"type": "dialog",
				"text":
				"Then, as I was driving back home, I called Laura and told her that everything was fixed and the traffic lights were working. Finally, I could get back home and go fishing.",
				"image": "res://assets/levels/001-traffic-light/player.png",
				"background": "res://assets/levels/001-traffic-light/house.png"
			}
		]
	},
	{
		"title": "Chapter 2\nThe Grandma's laptop",
		"score_required": 20,
		"thumbnail_filename": "res://assets/levels/002-grandma/bg_grandma_house.png",
		"steps":
		[
			{
				"type": "title",
				"text": "Chapter 2.\nThe Grandma's Laptop",
			},
			{
				"type": "dialog",
				"text": "My phone rang.",
				"image": "res://assets/levels/002-grandma/fg_phone-ring.png",
				"background": "res://assets/levels/002-grandma/bg_my_room.png"
			},
			{
				"type": "dialog",
				"text":
				"It was Grandma, sounding flustered as she explained she'd forgotten her laptop's password.",
				"image": "res://assets/levels/002-grandma/fg_grandma.png",
				"background": "res://assets/levels/002-grandma/bg_my_room.png"
			},
			{
				"type": "dialog",
				"text":
				"I smiled, thinking how much she means to me. \"Don't worry, Grandma, I'll swing by after lunch and sort it out.\"",
				"image": "res://assets/levels/002-grandma/fg_grandma.png",
				"background": "res://assets/levels/002-grandma/bg_my_room.png"
			},
			{
				"type": "dialog",
				"text":
				"My grandma lives in the nice old house and I have so many child memories about this place.",
				"background": "res://assets/levels/002-grandma/bg_grandma_house.png"
			},
			{
				"type": "dialog",
				"text":
				"Thank you for coming, diar! Here is the laptop. I will make some cookies for you while you are working.",
				"image": "res://assets/levels/002-grandma/fg_grandma.png",
				"background": "res://assets/levels/002-grandma/bg_grandma_room.png"
			},
			{
				"type": "game",
			},
			{
				"type": "dialog",
				"text": '"Oh, thank you, dear!" she said, "Have a cookie!"',
				"image": "res://assets/levels/002-grandma/fg_grandma.png",
				"background": "res://assets/levels/002-grandma/bg_cookie_table.png"
			},
		]
	},

]
