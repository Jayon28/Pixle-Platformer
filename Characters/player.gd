extends CharacterBody2D #Player.gd
class_name Player

enum { MOVE, CLIMB }

@export var moveData:Resource = preload("res://DefaultPlayerMovementData.tres")

@onready var ladderCheck: = $LadderCheck #Raycast check
@onready var jumpBufferTimer: = $JumpBufferTimer
@onready var coyoteJumpTimer: = $CoyoteJumpTimer
@onready var remoteTransform2D = $RemoteTransform2D
var state = MOVE
var buffered_jump = false
var coyote_jump = false
var freezed = false

func _ready():
	print("PlayerScene loaded")
	$AnimatedSprite2D.frames = load("res://skins/PlayerGreen.tres")
	velocity = Vector2.ZERO
	add_to_group("Players")
	add_to_group("Charators")
func _physics_process(delta):

	if freezed: return
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left" , "ui_right")
	input.y = Input.get_axis("ui_up" , "ui_down")
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)
	
func move_state(input):
	if is_on_ladder() && (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")):
		state = CLIMB
	apply_gravity()
	if input.x == 0: #应用摩擦/加速/静止动画
		$AnimatedSprite2D.animation = "Idle"
		apply_friction()
	else:
		if input.x > 0 : #角色朝向
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.animation = "Run"
		apply_acceleration(input.x)


	if is_on_floor() || coyote_jump:
		if !coyote_jump: moveData.jump_count = 0 #重置二段跳次数
		if Input.is_action_just_pressed("ui_up") || buffered_jump:
			if !is_on_ladder():
				SoundPlayer.play_sound(SoundPlayer.JUMP)
				print("跳跃声音播放了")
				velocity.y = -moveData.jump_speed
				moveData.jump_count += 1
				buffered_jump = false
	else:
		$AnimatedSprite2D.animation = "Jump"
		if Input.is_action_just_released("ui_up") && velocity.y < moveData.jump_minspeed:
			velocity.y = moveData.jump_minspeed
			SoundPlayer.JUMP.stop()
	if !is_on_floor() && velocity.y != 0 && moveData.jump_count != 0: #二段跳
		if Input.is_action_just_pressed("ui_up") && moveData.jump_count < moveData.jump_maxcount:
			if !is_on_ladder():
				SoundPlayer.play_sound(SoundPlayer.JUMP)
				print("二段跳声音播放了")
				velocity.y = -moveData.double_jumprate * moveData.jump_speed
				moveData.jump_count += 1 #二段跳结束
	
	if Input.is_action_just_pressed("ui_up"):
		buffered_jump = true
		jumpBufferTimer.start()
	
	if velocity.y > 0: #快速下落
		velocity.y += moveData.fall
		
	var was_in_air = !is_on_floor()
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_landed = is_on_floor() && was_in_air
	if is_on_ladder() && was_on_floor: state = CLIMB #fall to ladder

	if just_landed :
		$AnimatedSprite2D.animation = "Run"
		$AnimatedSprite2D.frame = 1
		
	var just_left_ground = !is_on_floor() && was_on_floor
	#print("coyotejump",coyote_jump)
	
	if just_left_ground:
		#moveData.jump_count += 1
		if velocity.y >= 0:
			coyote_jump = true
			coyoteJumpTimer.start()

func climb_state(input):
	moveData.jump_count = 0
	if !is_on_ladder():state = MOVE
	if input.x > 0 : #角色朝向
		$AnimatedSprite2D.flip_h = true
	elif input.x < 0:
		$AnimatedSprite2D.flip_h = false
	if input.length() != 0: $AnimatedSprite2D.animation = "Run"
	else: $AnimatedSprite2D.animation = "Idle"

	velocity = input * moveData.climb_speed
	move_and_slide()

func is_on_ladder():
	if !ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if !collider is Ladder: return false
	return true

func apply_gravity():
	velocity.y += moveData.gravity

func apply_friction():
	velocity.x = move_toward(velocity.x , 0, moveData.fric)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.speed * amount, moveData.acc)

func die():
	
	SoundPlayer.play_sound(SoundPlayer.HIT)
	print("Death signal emitting... in Player.gd-->func die()")
	Events.emit_signal("player_died", self)
	

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func _on_jump_buffer_timer_timeout():
	buffered_jump = false


func _on_coyote_jump_timer_timeout():
	coyote_jump = false

func get_freezed():
	freezed = true

func unfreezed():
	freezed = false
	
