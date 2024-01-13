extends TileMap

var mouse_down = false
var dragging = false
var drag_start = Vector2()
var original_position = Vector2()

var tween = Tween.new()

var DRAG_DISTANCE_THRESHOLD = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if not mouse_down:
			mouse_down = true
			drag_start = get_global_mouse_position()
			original_position = position
	else:
		if mouse_down:
			mouse_down = false
			if dragging:
				dragging = false
				go_back()
			else:
				# Rotate the TileMap by 90 degrees
				rotation_degrees += 90

	var distance_between_origin_and_mouse = (get_global_mouse_position() - drag_start).length()
	if distance_between_origin_and_mouse > DRAG_DISTANCE_THRESHOLD and mouse_down:
		dragging = true

	if dragging:
		var drag_current = get_global_mouse_position()
		var drag_delta = drag_current - drag_start
		position = original_position + drag_delta

func go_back():
	# Use tween to animate the tilemap back to the original position
	# that means that position property should be animated to original_position value
	tween.interpolate_property(self, "position", position, original_position, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
