extends Node

# Checks if a shape can fit into a position within the tilemap
# Returns true if the shape fits, false otherwise
func shape_fits_position(tilemap, shape_coords, width, height, position) -> bool:
    for coord in shape_coords:
        var coord_in_tilemap = position + coord
        # Check if the coordinate is within the tilemap boundaries
        if coord_in_tilemap.x < 0 or coord_in_tilemap.x >= width or coord_in_tilemap.y < 0 or coord_in_tilemap.y >= height:
            return false
        # Check if the cell at the coordinate is empty
        if tilemap.get_cellv(coord_in_tilemap) != -1:
            return false
    return true

# Rotates the shape coordinates 90 degrees clockwise
# Returns the new coordinates of the shape
func rotate_shape_clockwise(shape_coords) -> Array:
    var new_coords = []
    for coord in shape_coords:
        new_coords.append(Vector2(coord.y, -coord.x))
    return new_coords

# Checks if there are any more possible moves for the shape within the tilemap
# Returns true if there are more moves, false otherwise
func has_more_moves(tilemap, shape_coords, width, height) -> bool: 
    for i in range(-4, width + 4):
        for j in range(-4, height + 4):
            var position = Vector2(i, j)
            var shape_to_test = shape_coords
            # Check all four possible rotations of the shape
            for _k in range(0, 4):
                if shape_fits_position(tilemap, shape_to_test, width, height, position):
                    return true
                shape_to_test = rotate_shape_clockwise(shape_to_test)
    return false