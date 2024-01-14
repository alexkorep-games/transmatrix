extends Node

var score := 0

var SAVE_GAME_FILE := "user://save_game.dat"

func set_score(new_score):
	score = new_score

func increase_score(val):
	score += val

func get_score():
	return score

func reset_score():
	score = 0

func save_game(field_tile_map, current_shape_tile_map):
	var file := File.new()
	file.open(SAVE_GAME_FILE, File.WRITE)
	# Save the field and current shape tile maps

	# Save field tile map
	var result = {
		"field": [],
		"current_shape": [],
		score: score
	}
	for cell in field_tile_map.get_used_cells():
		result["field"].append({
			"cell": cell,
			"tile": field_tile_map.get_cellv(cell)
		})

	for cell in current_shape_tile_map.get_used_cells():
		result["current_shape"].append({
			"cell": cell,
			"tile": current_shape_tile_map.get_cellv(cell)
		})

	file.store_var(result)
	file.close()

func load_game(field_tile_map, current_shape_tile_map):
	var file := File.new()
	if file.file_exists("user://save_game.dat"):
		file.open(SAVE_GAME_FILE, File.READ)

		var state = file.get_var()
		print(state)
		score = state["score"] if "score" in state else 0
		if "field" in state:
			field_tile_map.clear()
			for cell in state["field"]:
				field_tile_map.set_cellv(cell.cell, cell.tile)

		if "current_shape" in state:
			current_shape_tile_map.clear()
			for cell in state["current_shape"]:
				current_shape_tile_map.set_cellv(cell.cell, cell.tile)

		file.close()
