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


func _on_ReturnHome_pressed():
	TransitionManager.begin_transition()
	yield(TransitionManager, "screen_dimmed")
	var screen = load("res://Game/ImgSelectScreen.tscn").instance()
	
	get_tree().get_root().add_child(screen)
	owner.queue_free()
	TransitionManager.end_transition()
