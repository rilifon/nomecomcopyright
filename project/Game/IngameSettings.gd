extends Panel

signal set_timer_visibility(val);
signal set_moves_visibility(val);


func _ready():
	pass


func _on_TimerToggle_toggled(button_pressed):
	print("button pressed")
	emit_signal("set_timer_visibility", button_pressed)


func _on_MovesToggle_toggled(button_pressed):
	print("button pressed")
	emit_signal("set_moves_visibility", button_pressed)


func _on_Close_pressed():
	hide()
