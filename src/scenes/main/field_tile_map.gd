extends TileMap

func _ready():
	pass

func remove_groups():
	var result = []
	var checked = []
	var r = get_used_rect()
	for x in range(r.position.x, r.position.x + r.size.x):
		for y in range(r.position.y, r.position.y + r.size.y):
			var pos = Vector2(x, y)
			if pos in checked:
				continue

			var tile_id = get_cellv(pos)
			if tile_id == -1:
				continue
			
			var group = []
			get_similar_group(pos, tile_id, group)
			if group.size() >= 4:
				for cell_pos in group:
					set_cellv(cell_pos, -1)  # -1 clears the cell
					result.append({
						"pos": cell_pos,
						"tile_id": tile_id
					})
			checked += group
	return result

func get_similar_group(pos, tile_id, group = []):
	if not is_valid_cell(pos) or pos in group or get_cellv(pos) != tile_id:
		# This cell has been visited or is not similar to the tile we're looking for
		return
	group.append(pos)
	get_similar_group(pos + Vector2(0, -1), tile_id, group)
	get_similar_group(pos + Vector2(0, 1), tile_id, group)
	get_similar_group(pos + Vector2(-1, 0), tile_id, group)
	get_similar_group(pos + Vector2(1, 0), tile_id, group)

func is_valid_cell(pos):
	var sz = get_used_rect().size
	var p = get_used_rect().position
	return (pos.x >= p.x && pos.y >= p.y && 
		pos.x < p.x + sz.x && pos.y < p.y + sz.y)
