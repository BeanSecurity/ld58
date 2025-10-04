extends Node

var starting_player_pogs=[
	[G.PogSideType.DAMAGE,G.PogSideType.ARMOR],
	#[G.PogSideType.HEAL,G.PogSideType.DEBUFF],
	[G.PogSideType.FLIP,G.PogSideType.RETOSS],
	[G.PogSideType.BUFF,G.PogSideType.NONE],
	[G.PogSideType.BUFF,G.PogSideType.DOUBLE],
	#[G.PogSideType.DAMAGE,G.PogSideType.NONE],
	
	#[G.PogSideType.SPEAR,G.PogSideType.SPEAR],
	#[G.PogSideType.SPLIT,G.PogSideType.SPLIT],
	#[G.PogSideType.BUFF_ALL,G.PogSideType.BUFF_ALL],
	#[G.PogSideType.ARMOR_DAMAGE,G.PogSideType.ARMOR_DAMAGE],
	#[G.PogSideType.BLANK_DAMAGE,G.PogSideType.BLANK_DAMAGE],
	#[G.PogSideType.RETOSS_BLANK,G.PogSideType.RETOSS_BLANK],

]


var player_pogs=starting_player_pogs

var enemy_level=[
	[
	[G.PogSideType.DAMAGE,G.PogSideType.NONE],
	[G.PogSideType.FLIP,G.PogSideType.NONE],
	[G.PogSideType.NONE,G.PogSideType.BUFF],
	[G.PogSideType.NONE,G.PogSideType.BUFF],
],	
[
	[G.PogSideType.DAMAGE,G.PogSideType.NONE],
	[G.PogSideType.ARMOR,G.PogSideType.NONE],
	[G.PogSideType.FLIP,G.PogSideType.NONE],
	[G.PogSideType.BUFF,G.PogSideType.DOUBLE],
	[G.PogSideType.NONE,G.PogSideType.BUFF],
],
[
	[G.PogSideType.DAMAGE,G.PogSideType.ARMOR],
	[G.PogSideType.HEAL,G.PogSideType.NONE],
	[G.PogSideType.DAMAGE,G.PogSideType.NONE],
	[G.PogSideType.FLIP,G.PogSideType.BUFF],
	[G.PogSideType.FLIP,G.PogSideType.BUFF],
	[G.PogSideType.NONE,G.PogSideType.DOUBLE],
],
[
	[G.PogSideType.DAMAGE,G.PogSideType.ARMOR],
	[G.PogSideType.DAMAGE,G.PogSideType.SPEAR],
	[G.PogSideType.HEAL,G.PogSideType.NONE],
	[G.PogSideType.FLIP,G.PogSideType.BUFF],
	[G.PogSideType.BUFF,G.PogSideType.FLIP],
	[G.PogSideType.NONE,G.PogSideType.DOUBLE],
],
[
	[G.PogSideType.DAMAGE,G.PogSideType.ARMOR],
	[G.PogSideType.DAMAGE,G.PogSideType.SPEAR],
	[G.PogSideType.HEAL,G.PogSideType.ARMOR],
	[G.PogSideType.FLIP,G.PogSideType.BUFF],
	[G.PogSideType.BUFF,G.PogSideType.FLIP],
	[G.PogSideType.NONE,G.PogSideType.DOUBLE],
],
]
#var enemy_pogs=enemy_level[0]
var level=0

var pog_side_type
enum PogSideType {
	NONE,
	DAMAGE,
	FLIP,
	ARMOR,
	DOUBLE,
	BUFF,
	DEBUFF,
	HEAL,
	RETOSS,
	SPLIT,
	
	RETOSS_BLANK,
	BLANK_DAMAGE,
	BUFF_ALL,
	ARMOR_DAMAGE,
	
	SPEAR,
	#SHUFFLE,
	}

func get_random_pog()->Array[PogSideType]:
	var a=[
	PogSideType.DAMAGE,
	PogSideType.FLIP,
	PogSideType.ARMOR,
	PogSideType.DOUBLE,
	PogSideType.BUFF,
	PogSideType.DEBUFF,
	PogSideType.HEAL,
	PogSideType.RETOSS,
	PogSideType.SPLIT,
	PogSideType.ARMOR_DAMAGE,
	PogSideType.BUFF_ALL,
	PogSideType.BLANK_DAMAGE,
	PogSideType.RETOSS_BLANK,
	PogSideType.SPLIT,
	PogSideType.SPEAR,
	]
	a.shuffle()
	return [a[0],a[1]]
func get_common_pog():
	var a1=[
		PogSideType.FLIP,
		PogSideType.ARMOR,
		PogSideType.BUFF,
		PogSideType.DEBUFF,
		PogSideType.RETOSS,
		PogSideType.ARMOR_DAMAGE,
	]
	a1.shuffle()	
	var a2=[
		PogSideType.NONE,
		PogSideType.FLIP,
		PogSideType.ARMOR,
		PogSideType.BUFF,
		PogSideType.DEBUFF,
		PogSideType.RETOSS,
		PogSideType.SPLIT,
	]
	a2.shuffle()
	return [a1[0],a2[0]]
func get_rare_pog():
	var a=[
		[PogSideType.DOUBLE,PogSideType.NONE],
		[PogSideType.HEAL,PogSideType.ARMOR],
		[PogSideType.HEAL,PogSideType.DAMAGE],
		[PogSideType.DAMAGE,PogSideType.ARMOR],
		[PogSideType.FLIP, PogSideType.RETOSS],
		[PogSideType.RETOSS_BLANK, PogSideType.NONE],
		[PogSideType.BUFF_ALL, PogSideType.NONE],
		[PogSideType.ARMOR_DAMAGE,PogSideType.NONE],
		[PogSideType.SPLIT, PogSideType.NONE],
		[PogSideType.SPEAR, PogSideType.NONE]
	]
	a.shuffle()
	return a[0]

func _ready() -> void:
	register()

func register():
	#var player = await Talo.players.identify("device", id)
	var player = await Talo.players.identify("user", str(randi()))
	
	if player:
		print("player: ", player.id)
	else:
		print("error")
		return
	
func send_event(s):
	var event = await Talo.events.track(s)
	
	if event:
		print("event sent")
	else:
		print("event err")
