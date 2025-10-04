extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo():
		get_tree().change_scene_to_file("res://title.tscn")
