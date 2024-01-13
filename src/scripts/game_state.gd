extends Node

var score := 0

func set_score(new_score):
	score = new_score

func increase_score(val):
	score += val

func get_score():
	return score