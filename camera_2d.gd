extends Camera2D

var shake_strength = 0.0
var decay = 20.0

func _process(delta):
	if shake_strength > 0:
		shake_strength = max(shake_strength - decay * delta, 0)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		
	else:
		offset = Vector2.ZERO

func shake(strength = 5.0):
	shake_strength = 5+strength
