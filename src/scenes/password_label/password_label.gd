extends Label

signal password_cracked

export var password = ""

var chars_open = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open_chars(char_count):
	chars_open += char_count
	if chars_open >= len(password):
		chars_open = len(password)
		get_node("%CPUParticles2D").emitting = true
		get_node("%ParticlesFinishedTimer").start()

func all_chars_open():
	return chars_open >= len(password)
	
func _process(delta):
	text = password.substr(0, chars_open) 
	for i in range(len(password) - chars_open):
		text += "*"

func _on_ParticlesFinishedTimer_timeout():
	emit_signal("password_cracked")
