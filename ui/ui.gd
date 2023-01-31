extends CanvasLayer

func _on_button_pressed():
	Events.emit_signal("restart_button_pressed")
	queue_free()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE :
			Events.emit_signal("restart_button_pressed")
			queue_free()
