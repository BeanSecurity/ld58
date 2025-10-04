extends Node2D

var pog_scene=preload("res://pog.tscn")
func _ready() -> void:
	for i in range(G.player_pogs.size()):
		var pog_instance=pog_scene.instantiate()
		pog_instance.sides=G.player_pogs[i]
		pog_instance.add_to_group("player")
		pog_instance.add_to_group("non_pick")
		#pog_instance.global_position=Vector2(randi_range(100, 600),randi_range(300, 550))
		pog_instance.position=Vector2((i/3)*100,(i%3)*100)
		#pog_instance.find_child("Area2D").input_pickable=false
		pog_instance.can_move=false
		$Pogs2.add_child(pog_instance)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title.tscn")
