# DraggableObject.gd
extends Node2D

@export var enemys=false
var hovering=false
var dragging = false
var drag_offset = Vector2()
var tossing=false
var can_move=true

@export var sides=[G.PogSideType.NONE, G.PogSideType.DAMAGE]
var current_side:int=0
#@onready var area = $Area2D
var values=null

#func _input(event: InputEvent) -> void:
	#if not tossing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:


func _ready():
	if !tossing:
		toss()
	
	#area.input_event.connect(_on_area_2d_input_event)
	#area.area_entered.connect(_on_area_2d_input_event)
	#area.input_pickable = true
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	
	if values==null:
		values=[get_base_value(sides[0]),get_base_value(sides[1])]
	$Icon1.frame=get_pog_icon(sides[current_side])
	$Icon2.frame=get_pog_icon(sides[1-current_side])

func toss():
	$ValueLabel.hide()
	$Icon1.show()
	$Icon2.show()
	tossing=true
	var r = randf_range(0.75,1.50)
	$TossTimer.wait_time=$TossTimer.wait_time*r
	$AnimationPlayer.play("flip",-1,r)
	$TossTimer.start()
	rotation=randf_range(-PI/4,PI/4)
	#$TossAudioStreamPlayer.pitch_scale=r
	#$TossAudioStreamPlayer.play()
	RollAudio.play(-r*0.3)

func _process(_delta):
	if hovering and not tossing and not dragging:
		$Flag.show()
	else:
		$Flag.hide()
	
	if not tossing:
		var x = 0
		if (Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)) and not dragging:
			x = 1
		if current_side==x:
			$Icon1.show()
			$Icon2.hide()
		else:
			$Icon1.hide()
			$Icon2.show()
		if has_value(sides[(current_side+x)%2]):
			$ValueLabel.show()
		else:
			$ValueLabel.hide()
		$ValueLabel.text=str(values[(current_side+x)%2])
		var s=get_name_desc(sides[(current_side+x)%2])
		$Flag/Name.text=s[0]
		$Flag/Desc.text=s[1]
		$Flag/Tip.text="(%s)"%s[2]
		$Flag.global_rotation=0
		$Flag.position=Vector2.ZERO


	if dragging:
		$Shadow.global_position=global_position+Vector2(25,25)
	else:
		$Shadow.global_position=global_position+Vector2(5,5)
	
	if dragging and can_move:
		get_parent().move_child(self, -1)
		if pos_before_drag==null:
			pos_before_drag=global_position
		global_position = get_global_mouse_position() + drag_offset

func apply_to_target(target:Node2D)->bool:
	if sides[current_side]==G.PogSideType.DAMAGE:
		if target.is_in_group("enemy_hp"):
			damage_enemy(values[current_side])
			
			return true
	if sides[current_side]==G.PogSideType.HEAL:
		if target.is_in_group("player_hp"):
		
			get_parent().get_parent().player_hp=clamp(get_parent().get_parent().player_hp+values[current_side],-100000,get_parent().get_parent().max_player_hp)

			return true
	if sides[current_side]==G.PogSideType.ARMOR:
		if target.is_in_group("player_hp"):
			get_parent().get_parent().player_armor+=values[current_side]
			return true
	if sides[current_side]==G.PogSideType.BUFF and !target.is_in_group("hp_area") and target.has_value(target.sides[target.current_side]):
		if values[current_side]>0:
			target.values[target.current_side]+=values[current_side]
		return true
	if sides[current_side]==G.PogSideType.DEBUFF and !target.is_in_group("hp_area") and target.has_value(target.sides[target.current_side]):
		if values[current_side]>0:
			target.values[target.current_side]-=values[current_side]
		return true
	if sides[current_side]==G.PogSideType.DOUBLE and !target.is_in_group("hp_area") and target.has_value(target.sides[target.current_side]):
		target.values[target.current_side]=2*target.values[target.current_side]
		return true
	if sides[current_side]==G.PogSideType.FLIP and !target.is_in_group("hp_area"):
		target.current_side=1-target.current_side
		#target.values[target.current_side]=2*target.values[target.current_side]
		return true
	if sides[current_side]==G.PogSideType.RETOSS:
		var group=""
		if target.is_in_group("player_hp"):
			group="player"
		elif target.is_in_group("enemy_hp"):
			group="enemy"
		else: 
			return false
			
		for c in get_parent().get_children():
			if c.is_in_group(group):
				c.toss()
		
		return true
	if sides[current_side]==G.PogSideType.ARMOR_DAMAGE and target.is_in_group("hp_area"):
		#target.current_side=1-target.current_side
		
		damage_enemy(get_parent().get_parent().player_armor)
		#target.values[target.current_side]=2*target.values[target.current_side]
		return true
	if sides[current_side]==G.PogSideType.BUFF_ALL and !target.is_in_group("hp_area"):
		for pog in get_parent().get_children():
			if has_value(pog.sides[pog.current_side]):
				pog.values[pog.current_side]+=values[current_side]
		return true
	if sides[current_side]==G.PogSideType.RETOSS_BLANK and !target.is_in_group("hp_area"):
		for c in get_parent().get_children():
			if c.sides[c.current_side]==G.PogSideType.NONE:
				c.toss()
		return true
	if sides[current_side]==G.PogSideType.BLANK_DAMAGE and target.is_in_group("hp_area"):
		var count=0
		for c in get_parent().get_children():
			if c.sides[c.current_side]==G.PogSideType.NONE:
				count+=1
		damage_enemy(count*values[current_side])
		return true
	if sides[current_side]==G.PogSideType.SPEAR and target.is_in_group("hp_area"):
		#target.current_side=1-target.current_side
		damage_enemy(values[current_side], true)
		#target.values[target.current_side]=2*target.values[target.current_side]
		return true
	if sides[current_side]==G.PogSideType.SPLIT and !target.is_in_group("hp_area"):
		#var pog_scene=preload("res://pog.tscn")
		#var pog_instance=pog_scene.instantiate()
		#pog_instance.sides=target.
		#pog_instance.add_to_group("player")
		#pog_instance.global_position=Vector2(randi_range(100, 600),randi_range(300, 550))
		var newpog=target.duplicate()
		#newpog.toss()
		
		newpog.global_position+=Vector2(randi_range(50, 100),randi_range(50, 100))
		newpog.values=target.values
		get_parent().get_parent().find_child("Pogs").add_child(newpog)
	

		#var new2=target.duplicate()
		#new2.toss()
		#new2.global_position+=Vector2(randi_range(20,50),randi_range(20,50))
		#target.values[target.current_side]=2*target.values[target.current_side]
		return true

		
		#target.current_side=1-target.current_side
		#damage_enemy(get_parent().get_parent().player_armor)
		#target.values[target.current_side]=2*target.values[target.current_side]
		#return true

	return false

func damage_enemy(dmg, ignore_armor=false):
	#var dmg=values[current_side]
	var armor=get_parent().get_parent().enemy_armor
	if !ignore_armor:
		if armor<dmg:
			get_parent().get_parent().enemy_armor=0
			get_parent().get_parent().enemy_hp-=dmg-armor
		else:
			get_parent().get_parent().enemy_armor-=dmg
	else:
		get_parent().get_parent().enemy_hp-=dmg
	
	if get_parent().get_parent().has_node("Camera2D"):
		get_parent().get_parent().find_child("Camera2D").shake(dmg)

func has_value(type: G.PogSideType)->bool:
	if type==G.PogSideType.DAMAGE or \
	 type==G.PogSideType.BUFF or \
	 type==G.PogSideType.DEBUFF or \
	 type==G.PogSideType.ARMOR or \
	 type==G.PogSideType.BUFF_ALL or \
	 type==G.PogSideType.BLANK_DAMAGE or \
	 type==G.PogSideType.SPEAR or \
	 type==G.PogSideType.HEAL:
		return true
	else:
		return false

func get_base_value(type: G.PogSideType)->int:
	match type:
		G.PogSideType.DAMAGE:
			return 3
		G.PogSideType.BUFF:
			return 2
		G.PogSideType.DEBUFF:
			return 1
		G.PogSideType.HEAL:
			return 2		
		G.PogSideType.ARMOR:
			return 2		
		G.PogSideType.BUFF_ALL:
			return 0
		G.PogSideType.BLANK_DAMAGE:
			return 1
		G.PogSideType.SPEAR:
			return 1
	return 0

func get_pog_icon(type: G.PogSideType)->int:
	var x=5
	match type:
		G.PogSideType.DAMAGE:
			x= 1
		G.PogSideType.FLIP:
			x= 8
		G.PogSideType.BUFF:
			x= 11
		G.PogSideType.DEBUFF:
			x= 14
		G.PogSideType.DOUBLE:
			x= 9
		G.PogSideType.HEAL:
			x= 10
		G.PogSideType.RETOSS:
			x= 6		
		G.PogSideType.SPLIT:
			x= 15		
		G.PogSideType.ARMOR:
			x= 2
		G.PogSideType.BUFF_ALL:
			x= 19
		G.PogSideType.ARMOR_DAMAGE:
			x= 18
		G.PogSideType.RETOSS_BLANK:
			x= 20		
		G.PogSideType.BLANK_DAMAGE:
			x= 21
		G.PogSideType.SPEAR:
			x= 23
	
	if enemys:
		x+=128
	else:
		x+=96
	return x

func get_name_desc(type: G.PogSideType)->Array[String]:
	match type:
		G.PogSideType.NONE:
			return ["Blank","Its useless...","or is it?"]
		G.PogSideType.DAMAGE:
			return ["Sword","Deal X damage","apply to any player"]
		G.PogSideType.FLIP:
			return ["Flip","Flip selected patch to the other side","apply to any patch"]
		G.PogSideType.BUFF:
			return ["Buff","+X to selected patch","apply to any patch with value"]
		G.PogSideType.DEBUFF:
			return ["Debuff","-X to selected patch","apply to any patch with value"]
		G.PogSideType.DOUBLE:
			return ["Double","Double selected patch","apply to any patch with value"]
		G.PogSideType.HEAL:
			return ["Heart","+X to hp","apply to any player"]
		G.PogSideType.RETOSS:
			return ["Tornado","Re-toss all patches of selected player","apply to any player"]
		G.PogSideType.SPLIT:
			return ["Saple","Clone selected patch (one turn)","apply to any patch"]
		G.PogSideType.ARMOR:
			return ["Shield","+X to armor","apply to any player"]
		G.PogSideType.BUFF_ALL:
			return ["Horn","+X to all patches in game (both players)","apply to any patch with value"]
		G.PogSideType.ARMOR_DAMAGE:
			return ["Counter-attack","Deal damage equal to your armor","apply to any player"]
		G.PogSideType.RETOSS_BLANK:
			return ["Safeguard","Retoss all Blank patches","apply to Blank patch"]
		G.PogSideType.BLANK_DAMAGE:
			return ["Cleanup","Deal X damage per ANY Blank patch on table","apply to any player"]
		G.PogSideType.SPEAR:
			return ["Fire","Deal X damage (ignore armor)","apply to any player"]
	
	return ["Idk...","What is that?","dont panic"]




var pos_before_drag=null
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if event is InputEventMouse:
		#hovering=true
	#else:
		#hovering=false

	if not tossing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$ClickAudioStreamPlayer.play()
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false
			$ClickAudioStreamPlayer2.play()
			if current_target!=null:
				if current_target.is_in_group("pick"):
					return
				if not enemys and current_target.can_be_applied(sides[current_side]):
					var succes=apply_to_target(current_target)
					if succes:
						current_target.find_child("ApplyAudioStreamPlayer").play()
						var dust=preload("res://particle.tscn").instantiate()
						dust.global_position=global_position
						get_parent().get_parent().add_child(dust)
						queue_free()#TODO: move to discard or whatever
					else:
						global_position=pos_before_drag
				else:
					global_position=pos_before_drag
				
			pos_before_drag=null
			current_target=null

var current_target=null
func _on_area_2d_area_entered(other_area: Area2D) -> void:
	if dragging and other_area.get_parent() != self:
		var target = other_area.get_parent()
		current_target=target
		#apply_to_target(target)


func _on_area_2d_area_exited(other_area: Area2D) -> void:
	if dragging:
		if current_target==other_area.get_parent():
			current_target=null

func can_be_applied(side_type:G.PogSideType)->bool:
	return true


func _on_toss_timer_timeout() -> void:
	current_side=randi_range(0,1)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")
	tossing=false
	$TossTimer.stop()



func show_tip():
	pass


func _on_area_2d_mouse_entered() -> void:
	hovering=true


func _on_area_2d_mouse_exited() -> void:
	hovering=false
