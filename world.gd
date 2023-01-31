extends Node2D

const PlayerScene = preload("res://Characters/player.tscn")
const blood = preload("res://Objects/cpu_particles_2d.tscn")
@onready var camera: = $Camera2D
@onready var player: = $Player
@onready var timer: = $Timer
var is_dead = false
var new_player

var player_spawn = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.LIGHT_BLUE)
	player.connect_camera(camera)
	player_spawn = player.global_position
	Events.connect("player_died", Callable(self,"_on_player_died"))
	Events.connect("restart_button_pressed", Callable(self,"_restart_button_pressed"))
	Events.connect("hit_checkpoint", Callable(self, "_on_hit_checkpoint"))


func _on_player_died(source):
	if is_dead:return
	is_dead = true
	GameData.score += 1
	var label = source.get_node("CanvasLayer/Label")
	label.update_text()
	GameData.update_record()

	# 创建血液
	var current_player = source
	var bleed = blood.instantiate()
	bleed.position.y -= 10
	current_player.add_child(bleed)
	bleed.rotation_degrees = randf_range(-90, 0)
	get_tree().call_group("Charators", "get_freezed")
	# 0.2秒后暂停
	timer.start(2)
	await timer.timeout
	get_tree().paused = true
	# 显示按钮
	var ui_scene = load("res://ui/ui.tscn").instantiate()
	add_child(ui_scene)
	#ui_scene.position = $Camera2D.get_screen_center_position()
	
func _restart_button_pressed():
	is_dead = false
	print("restart pressed")
	get_tree().call_group("Players", "queue_free")
	get_tree().call_group("Charators", "unfreezed")
	new_player = PlayerScene.instantiate()
	add_child(new_player)
	new_player.position = player_spawn
	new_player.connect_camera(camera)
	get_tree().paused = false
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE :
			get_tree().quit()

func _on_hit_checkpoint(checkpoint_position):
	player_spawn = checkpoint_position
	
