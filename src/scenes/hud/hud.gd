extends Control

signal settings_pressed

func _ready():
	var windowHeight = OS.get_real_window_size().y
	var safeAreaTop = OS.get_window_safe_area().position.y
	var normalizedPosition = safeAreaTop / windowHeight * 720
	rect_position.y = normalizedPosition

func _process(delta):
	get_node("%ScoreLabel").text = str(GameState.get_score())


func _on_TextureButton_pressed():
	emit_signal("settings_pressed")
