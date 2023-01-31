extends Node2D

enum {HOVER, FALL, LAND, RISE}

var state = HOVER
@export var fall_speed = 2
@export var rise_speed = 50
@export var land_delay = 2.0
@export var hover_delay = 3.0

@onready var start_position: = global_position
@onready var raycast: = $RayCast2D
var freezed = false
var timer_hover
var timer_land


func _ready():
	add_to_group("Charators")
	timer_hover = make_timer(hover_delay)
	apply_timer(timer_hover)

func _physics_process(delta):
	if freezed: 
		$AnimatedSprite2D.stop()
		return
	match state:
		HOVER: hover_state()
		FALL: fall_state()
		LAND: land_state()
		RISE: rise_state(delta)
		

func hover_state():
	$AnimatedSprite2D.play("Rising")
	await(timer_hover.timeout)
	timer_hover.queue_free()
	state = FALL

func fall_state():
	$AnimatedSprite2D.play("Falling")
	position.y += fall_speed
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		position = collision_point
		state = LAND
		timer_land = make_timer(land_delay)
		apply_timer(timer_land)

func land_state():
	$AnimatedSprite2D.play("Falling")
	await(timer_land.timeout)
	timer_land.queue_free()
	state = RISE
	
func rise_state(delta):
	$AnimatedSprite2D.play("Rising")
	position.y = move_toward(position.y, start_position.y, rise_speed * delta)
	if position.y == start_position.y: 
		state = HOVER
		timer_hover = make_timer(hover_delay)
		apply_timer(timer_hover)
		
func get_freezed():
	freezed = true

func unfreezed():
	freezed = false

func make_timer(wait_time):
	var timer = Timer.new()
	timer.wait_time=wait_time
	return timer

func apply_timer(timer):
	add_child(timer)
	timer.start()
