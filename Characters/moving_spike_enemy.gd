@tool
extends Path2D

var freezed = false
@onready var animationPlayer = $AnimationPlayer
@export var playBackSpeed:float = 1.0
@export var animation_type:ANIMATION_TYPE = ANIMATION_TYPE.LOOP
enum ANIMATION_TYPE {LOOP, BOUNCE}
var pbspeed #playback speed

func _ready():
	play_updated_animation(animationPlayer)
	animationPlayer.playback_speed = playBackSpeed
	$Refresh.start()
	pbspeed = playBackSpeed
	add_to_group("Charators")

func play_updated_animation(ap):
	match animation_type:
		ANIMATION_TYPE.LOOP: ap.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: ap.play("MoveAlongPath")

func _on_refresh_timeout():
	play_updated_animation(animationPlayer)
	animationPlayer.playback_speed = playBackSpeed

func get_freezed():
	freezed = true
	playBackSpeed = 0

func unfreezed():
	playBackSpeed = pbspeed
