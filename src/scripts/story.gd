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

var story = [
	{
		"title": "The Grandma's laptop",
		"score_required": 10,
		"steps":
		[
			{
				"type": "title",
				"text": "Chapter 1.\nThe Grandma's Laptop",
			},
			{
				"type": "dialog",
				"text": "My phone rang.",
				"image": "res://assets/levels/001-grandma/fg_phone-ring.png",
				"background": "res://assets/levels/001-grandma/bg_my_room.png"
			},
			{
				"type": "dialog",
				"text":
				"It was Grandma, sounding flustered as she explained she'd forgotten her laptop's password.",
				"image": "res://assets/levels/001-grandma/fg_grandma.png",
				"background": "res://assets/levels/001-grandma/bg_my_room.png"
			},
			{
				"type": "dialog",
				"text":
				"I smiled, thinking how much she means to me. \"Don't worry, Grandma, I'll swing by after lunch and sort it out.\"",
				"image": "res://assets/levels/001-grandma/fg_grandma.png",
				"background": "res://assets/levels/001-grandma/bg_my_room.png"
			},
			{
				"type": "dialog",
				"text":
				"My grandma lives in the nice old house and I have so many child memories about this place.",
				"background": "res://assets/levels/001-grandma/bg_grandma_house.png"
			},
			{
				"type": "dialog",
				"text":
				"Thank you for coming, diar! Here is the laptop. I will make some cookies for you while you are working.",
				"image": "res://assets/levels/001-grandma/fg_grandma.png",
				"background": "res://assets/levels/001-grandma/bg_grandma_room.png"
			},
			{
				"type": "game",
			},
			{
				"type": "dialog",
				"text": '"Oh, thank you, dear!" she said, "Have a cookie!"',
				"image": "res://assets/levels/001-grandma/fg_grandma.png",
				"background": "res://assets/levels/001-grandma/bg_cookie_table.png"
			},
		]
	},
	{
		"title": "The Lost Cat Mystery",
		"score_required": 50,
		"steps":
		[
			{
				"type": "dialog",
				"text": "I was enjoying my morning coffee when I heard a soft meowing outside.",
				"background": "res://assets/levels/002-lostcat/coffee.png"
			},
			{
				"type": "dialog",
				"text":
				"Looking out the window, I saw Mrs. Johnson from next door, holding a 'Missing Cat' poster.",
				"background": "res://assets/levels/002-lostcat/missing-cat-poster.png"
			},
			{
				"type": "dialog",
				"text": "I decided to help her. 'Let's find Whiskers,' I said, grabbing my coat.",
				"background": "res://assets/levels/002-lostcat/helping-hand.png"
			},
			{"type": "game"},
			{
				"type": "dialog",
				"text":
				"'You found him! Thank you so much!' Mrs. Johnson exclaimed as I returned with Whiskers.",
				"background": "res://assets/levels/002-lostcat/found-cat.png"
			}
		]
	},
	{
		"title": "The Secret Recipe",
		"score_required": 100,
		"steps":
		[
			{
				"type": "dialog",
				"text":
				"The old, faded recipe book lay open on the kitchen table, but a page was missing.",
				"background": "res://assets/levels/003-secretrecipe/recipe-book.png"
			},
			{
				"type": "dialog",
				"text":
				"Aunt Maria looked worried. 'It's the secret family recipe for Bolognese sauce,' she sighed.",
				"background": "res://assets/levels/003-secretrecipe/aunt-maria.png"
			},
			{
				"type": "dialog",
				"text":
				"I noticed a torn piece of paper with scribbled letters. 'Maybe this is a clue,' I thought.",
				"background": "res://assets/levels/003-secretrecipe/clue.png"
			},
			{"type": "game"},
			{
				"type": "dialog",
				"text": "'You did it! You've decrypted the recipe!' Aunt Maria exclaimed with joy.",
				"background": "res://assets/levels/003-secretrecipe/success.png"
			}
		]
	}
]
