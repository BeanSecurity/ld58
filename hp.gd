extends Node2D

func can_be_applied(side_type:G.PogSideType)->bool:
	return true
	#if side_type==G.PogSideType.DAMAGE:
		#return true
	#return false

func apply(pog:Node2D):
	if pog.sides[pog.current_side]==G.PogSideType.DAMAGE:
		print(pog.values[pog.current_side])
