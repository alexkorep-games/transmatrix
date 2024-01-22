extends Node

var score := 0
var is_free_play = true

var SAVE_GAME_FILE := "user://save_game_free_play.dat"


func set_score(new_score):
	score = new_score


func increase_score(val):
	score += val


func get_score():
	return score


func reset_score():
	score = 0


func save_game_free_play(state):
	var file := File.new()
	file.open(SAVE_GAME_FILE, File.WRITE)
	state["score"] = score
	file.store_var(state)
	file.close()


func load_game_free_play():
	var file := File.new()
	if file.file_exists(SAVE_GAME_FILE):
		file.open(SAVE_GAME_FILE, File.READ)

		var state = file.get_var()
		if state:
			score = state["score"] if "score" in state else 0			
		file.close()
		return state
