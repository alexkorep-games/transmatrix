extends Label


var full_text := ""

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

func next_char():
	var strlen = len(text)
	if strlen >= len(full_text):
		return
	var next_char = full_text[strlen]
	var tmp = text
	text = tmp.insert(strlen, next_char)
	
