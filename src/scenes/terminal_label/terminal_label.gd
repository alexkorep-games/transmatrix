extends Label


var full_text := ""
var cursor_visible = false

var CHARS_PER_SEC = 50
var sum_delta = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func _process(delta):
	sum_delta += delta
	var char_delay = 1.0/CHARS_PER_SEC
	while sum_delta >= char_delay:
		next_char()
		sum_delta -= char_delay

func start():
	full_text = text
	text = ""


func _on_Timer_timeout():
	if cursor_visible:
		var tmp = text
		tmp.erase(len(tmp) - 1, 1)
		text = tmp
	else:
		text += "_"
	cursor_visible = not cursor_visible


func next_char():
	var strlen = len(text) - (1 if cursor_visible else 0)
	if strlen >= len(full_text):
		return
	var next_char = full_text[strlen]
	var tmp = text
	text = tmp.insert(strlen, next_char)
	
