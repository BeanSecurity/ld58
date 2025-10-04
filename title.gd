extends Node2D

#func _input(event: InputEvent) -> void:
	#if (event is InputEventMouseButton or event is InputEventKey) and event.is():
		#preload("res://game.tscn")
		
func _input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo():
		G.player_pogs=G.starting_player_pogs
		G.level=0
		
		get_tree().change_scene_to_file("res://game.tscn")
	
#
#func _ready() -> void:
	#G.deck=[]
	#G.current_level=1
	#Engine.time_scale=1
	#Music.find_child("AudioStreamPlayer").play()
