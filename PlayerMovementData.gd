extends Resource
class_name PlayerMovementData

@export var gravity = 5
@export var speed = 750
@export var jump_speed = 160
@export var jump_maxcount = 2
@export var jump_count = 0
@export var fric:float = 15 # for friction and acceleration
@export var acc:float = 15 # for friction and acceleration
@export var jump_minspeed = -70
@export var fall = 2
@export var double_jumprate = 0.7
@export var climb_speed = 50
