extends CharacterBody2D

var direction = Vector2.RIGHT
@onready var edgeCheckR = $EdgeCheckR
@onready var edgeCheckL = $EdgeCheckL

func _physics_process(delta):
	var found_wall = is_on_wall()
	var found_edge = !edgeCheckR.is_colliding() || !edgeCheckL.is_colliding()
	if found_wall || found_edge:
		direction *= -1
		scale.x *= -1
	velocity = direction * 25
	move_and_slide()
