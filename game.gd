extends Node2D

var max_enemy_hp=20
var max_player_hp=20
#var max_enemy_hp=10
#var max_player_hp=10
var enemy_hp=max_enemy_hp
var player_hp=max_player_hp
var enemy_armor=0
var player_armor=0

#var player_pogs=[]
#var enemy_pogs=[]

var pog=preload("res://pog.tscn")

var current_pogs_available=0

var turn=0
var is_players_turn=true
func _ready():
	max_player_hp=20+G.level*5
	max_enemy_hp=20+G.level*5
	player_hp=max_player_hp
	enemy_hp=max_enemy_hp
	toss_all()
	#test_talo()
	


func toss_all():
	#$Pogs.remove
	for sides in G.player_pogs:
		var pog_instance=pog.instantiate()
		pog_instance.sides=sides
		pog_instance.add_to_group("player")
		pog_instance.global_position=Vector2(randi_range(100, 600),randi_range(300, 550))
		
		$Pogs.add_child(pog_instance)
	
	for sides in G.enemy_level[G.level]:
		var pog_instance=pog.instantiate()
		pog_instance.sides=sides
		pog_instance.global_position=Vector2(randi_range(100, 600),randi_range(50, 300))
		pog_instance.enemys=true
		pog_instance.add_to_group("enemy")
		
		$Pogs.add_child(pog_instance)

func get_random_pog(types:Array[G.PogSideType], group: String, back_side:bool=false):
	var children=$Pogs.get_children()
	children.duplicate()
	children.shuffle()
	var x = 0
	if back_side:
		x=1
	for c in $Pogs.get_children():
		
		if c.is_in_group(group) and types.find(c.sides[x-c.current_side])!=-1:
			return c
	return null

func _input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo():
		#_on_button_2_pressed()
		if $Tutor.visible:
			$Tutor.hide()
			#$Button2.text="show tips"


var enemy_tween: Tween
func _process(_delta: float) -> void:
	$PlayerHP.text="%d/%d"%[player_hp,max_player_hp]
	$EnemyHP.text="%d/%d"%[enemy_hp,max_enemy_hp]
	$PlayerArmor.text="%d"%[player_armor]
	$EnemyArmor.text="%d"%[enemy_armor]
	
	if enemy_hp<=0:
		$Button.text="YOU WON!"
	if is_players_turn:
		for c in $Pogs.get_children():
			pass
	else:
		if !$EnemyTimer.is_stopped():
			return
		var succces=try_apply(G.PogSideType.FLIP,[G.PogSideType.DAMAGE,G.PogSideType.ARMOR,G.PogSideType.DOUBLE,G.PogSideType.BUFF,G.PogSideType.SPEAR],true)
		if succces:
			return
		#var succces=try_apply(G.PogSideType.FLIP,[G.PogSideType.DAMAGE,G.PogSideType.ARMOR,do],true)
		#if succces:
			#return

		#for c in $Pogs.get_children():
			#if c.is_in_group("enemy"):
				#if c.sides[c.current_side]==G.PogSideType.FLIP:
					#var target=get_random_pog(G.PogSideType.DAMAGE, "enemy", true)
					#if target!=null:
						#var succes=c.apply_to_target(target)
						#if succes:
							#move_pog(c, target)
							##c.queue_free()
							#$EnemyTimer.start()
							#return
		
		#for c in $Pogs.get_children():
			#if c.is_in_group("enemy"):
				#if c.sides[c.current_side]==G.PogSideType.FLIP:
					#var target=get_random_pog(G.PogSideType.DOUBLE, "enemy", true)
					#if target!=null:
						#var succes=c.apply_to_target(target)
						#if succes:
							#move_pog(c, target)
							##c.queue_free()#TODO: move to discard or whatever
							#$EnemyTimer.start()
							#return
		succces=try_apply(G.PogSideType.BUFF,[G.PogSideType.DAMAGE,G.PogSideType.ARMOR,G.PogSideType.HEAL,G.PogSideType.SPEAR])
		if succces:
			return

		#for c in $Pogs.get_children():
			#if c.is_in_group("enemy"):
				#if c.sides[c.current_side]==G.PogSideType.BUFF:
					#var target=get_random_pog(G.PogSideType.DAMAGE, "enemy")
					#if target!=null:
						#var succes=c.apply_to_target(target)
						#if succes:
							#move_pog(c, target)
							##c.queue_free()#TODO: move to discard or whatever
							#$EnemyTimer.start()
							#return
		
		succces=try_apply(G.PogSideType.DOUBLE,[G.PogSideType.DAMAGE,G.PogSideType.ARMOR,G.PogSideType.HEAL,G.PogSideType.SPEAR])
		if succces:
			return

		#for c in $Pogs.get_children():
			#if c.is_in_group("enemy"):
				#if c.sides[c.current_side]==G.PogSideType.DOUBLE:
					#var target=get_random_pog(G.PogSideType.DAMAGE, "enemy")
					#if target!=null:
						#var succes=c.apply_to_target(target)
						#if succes:
							#move_pog(c, target)
							##c.queue_free()#TODO: move to discard or whatever
							#$EnemyTimer.start()
							#
							#return
		
		for c in $Pogs.get_children():
			if c.is_in_group("enemy"):
				if c.sides[c.current_side]==G.PogSideType.DAMAGE:
					if c.values[c.current_side]>0:
						#player_hp-=c.values[c.current_side]
						var dmg=c.values[c.current_side]
						var armor=player_armor
						if armor<dmg:
							player_armor=0
							player_hp-=dmg-armor
						else:
							player_armor-=dmg
						$Camera2D.shake(dmg)
						move_pog(c, $Player)#TODO: move to discard or whatever
						$EnemyTimer.start()
						return
		for c in $Pogs.get_children():
			if c.is_in_group("enemy"):
				if c.sides[c.current_side]==G.PogSideType.ARMOR:
					if c.values[c.current_side]>0:
						#player_hp-=c.values[c.current_side]
						#var dmg=c.values[c.current_side]
						#var armor=player_armor
						#if armor<dmg:
							#player_armor=0
							#player_hp-=dmg-armor
						#else:
							#player_armor-=dmg
						#$Camera2D.shake(dmg)
						enemy_armor+=c.values[c.current_side]
						move_pog(c, $Enemy)#TODO: move to discard or whatever
						$EnemyTimer.start()
						return
		for c in $Pogs.get_children():
			if c.is_in_group("enemy"):
				if c.sides[c.current_side]==G.PogSideType.HEAL:
					if c.values[c.current_side]>0:
						enemy_hp=clamp(enemy_hp+c.values[c.current_side],0,max_enemy_hp)
						move_pog(c, $Enemy)#TODO: move to discard or whatever
						$EnemyTimer.start()
						return		
		for c in $Pogs.get_children():
			if c.is_in_group("enemy"):
				if c.sides[c.current_side]==G.PogSideType.SPEAR:
					if c.values[c.current_side]>0:
						#player_hp-=c.values[c.current_side]
						var dmg=c.values[c.current_side]
						var armor=player_armor
						if armor<dmg:
							player_armor=0
							player_hp-=dmg-armor
						else:
							player_armor-=dmg
						$Camera2D.shake(dmg)
						
						move_pog(c, $Player)#TODO: move to discard or whatever
						$EnemyTimer.start()
						return		
		
		_on_button_pressed()

	#if current_pogs_available==0:
		##for c in $Pogs.get_children():
			##c.toss()
		#toss_all()
		#current_pogs_available=$Pogs.get_child_count()
#func toss():
	
func try_apply(from:G.PogSideType,to: Array[G.PogSideType],otherside:bool=false)->bool:
	for c in $Pogs.get_children():
		if !c.is_in_group("enemy"):
			continue
		if c.sides[c.current_side]==from:
			var target=get_random_pog(to, "enemy",otherside)
			if target!=null:
				var succes=c.apply_to_target(target)
				if succes:
					move_pog(c, target)
					#c.queue_free()#TODO: move to discard or whatever
					$EnemyTimer.start()
					$ApplyAudioStreamPlayer.play()
					return true
	return false

func move_pog(c, target):
	if enemy_tween!=null and enemy_tween.is_running():
		enemy_tween.kill()
	enemy_tween=create_tween()
	enemy_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#enemy_tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	enemy_tween.tween_property(c, "global_position", target.global_position,0.2)
	enemy_tween.tween_callback(func():
		var dust=preload("res://particle.tscn").instantiate()
		dust.global_position=c.global_position
		add_child(dust)
		$Enemy/ApplyAudioStreamPlayer.play()
		c.queue_free()
	)#TODO: move to discard or whatever
	

func _on_button_pressed() -> void:
	if enemy_hp<=0:
		G.send_event("lvlpassed:%d"%G.level)
		G.level+=1
		if G.level==G.enemy_level.size():
			get_tree().change_scene_to_file("res://congrats.tscn")
		get_tree().change_scene_to_file("res://pick.tscn")
	
	if player_hp<=0:
		G.send_event("lvllose:%d"%G.level)
		get_tree().change_scene_to_file("res://gameover.tscn")

	#$Button/ApplyAudioStreamPlayer.play()
	if is_players_turn:
		is_players_turn=false
		enemy_armor=0
		$Button.disabled=true
	else:
		for c in $Pogs.get_children():
			c.queue_free()
		
		toss_all()
		is_players_turn=true
		$Button.disabled=false
		
		player_armor=0


func _on_button_2_pressed() -> void:
	if !$Tutor.visible:
		$Tutor.show()
		#$Button2.text="hide tips"
	#else:
		#$Tutor.hide()
		#$Button2.text="show tips"
