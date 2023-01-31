extends Node

@onready var HIT = $AudioPlayers/AudioStreamPlayerHit
@onready var JUMP = $AudioPlayers/AudioStreamPlayerJump

func play_sound(sound):
	sound.play()
