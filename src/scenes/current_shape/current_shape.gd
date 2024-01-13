extends TileMap

var dragging = false
var drag_start = Vector2()
var original_position = Vector2()

var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if not dragging:
			dragging = true
			drag_start = get_global_mouse_position()
			original_position = position
	else:
		if dragging:
			dragging = false
			go_back()
			

	if dragging:
		var drag_current = get_global_mouse_position()
		var drag_delta = drag_current - drag_start
		position += drag_delta
		drag_start = drag_current

func go_back():
	# Use tween to animate the tilemap back to the original position
	# that means that position property should be animated to original_position value
	tween.interpolate_property(self, "position", position, original_position, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
