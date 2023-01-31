extends Node2D

@onready var animatedSprite: = $AnimatedSprite2D
var active = true

func _ready():
	active = true

func _on_area_2d_body_entered(body):
	if !body is Player || !active: return
	animatedSprite.play("checked")
	Events.emit_signal("hit_checkpoint", position)
	active = false
