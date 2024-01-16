extends Control

signal settings_pressed

export var show_progress = false

func _ready():
	var windowHeight = OS.get_real_window_size().y
	var safeAreaTop = OS.get_window_safe_area().position.y
	var normalizedPosition = safeAreaTop / windowHeight * 720
	rect_position.y = normalizedPosition

func _process(_delta):
	var progress_bar = get_node("%ProgressBar")
	progress_bar.visible = show_progress
	var score_text = str(GameState.get_score())
	if show_progress:
		score_text += ("/" + str(Story.get_required_score()))
		progress_bar.max_value = Story.get_required_score()
		progress_bar.value = GameState.get_score()
	get_node("%ScoreLabel").text = score_text

func _on_TextureButton_pressed():
	emit_signal("settings_pressed")
