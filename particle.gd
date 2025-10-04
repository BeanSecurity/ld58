extends Node2D
func _ready() -> void:
	$CPUParticles2D.emitting=true

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
