extends Area2D
#var is_dead = false

func _on_body_entered(body):
	if body is Player :
		body.die()
		
