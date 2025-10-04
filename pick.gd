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
		
	
	
	var pogs=[
		G.get_random_pog(),
		G.get_common_pog(),
		G.get_rare_pog(),
	]
	pogs.shuffle()
	
	for i in range(3):
		var pog=pog_scene.instantiate()
		pog.sides=pogs[i]
		#pog.global_position=Vector2(190+i*330,280)
		match i:
			0:
				pog.global_position=$pog1.global_position
			1:
				pog.global_position=$pog2.global_position
			2:
				pog.global_position=$pog3.global_position
		$Pogs.add_child(pog)

func _process(_delta: float) -> void:
	for area in $Area1/Area2D.get_overlapping_areas():
		var pog=area.get_parent()
		if  !pog.dragging and not pog.is_in_group("non_pick"):
			
			G.player_pogs.append([pog.sides[0],pog.sides[1]])
			get_tree().change_scene_to_file("res://game.tscn")
			

#var current_
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#pass
