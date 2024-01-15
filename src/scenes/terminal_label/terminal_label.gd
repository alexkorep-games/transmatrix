extends Label


var full_text := ""
var cursor_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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


func _on_FillTimer_timeout():
	var strlen = len(text) - (1 if cursor_visible else 0)
	if strlen >= len(full_text):
		return
	var next_char = full_text[strlen]
	var tmp = text
	text = tmp.insert(strlen, next_char)
	
