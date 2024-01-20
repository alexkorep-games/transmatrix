extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var episode_intem_scene = preload("res://scenes/episodes/episode_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var container = get_node("%GridContainer")
	# delete all children
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
		
	var idx = 0
	for episode in Story.story:
		var episode_item = episode_intem_scene.instance()
		episode_item.title = episode.title
		episode_item.image_filename = episode.thumbnail_filename
		episode_item.idx = idx
		episode_item.connect("pressed", self, "_on_EpisodeItem_pressed")
		container.add_child(episode_item)
		idx += 1

func _on_EpisodeItem_pressed(episode_idx):
	Story.start_story(episode_idx)
	get_tree().change_scene("res://scenes/story_dialog/story_dialog.tscn")
