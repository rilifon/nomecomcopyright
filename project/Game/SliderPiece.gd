extends TextureButton

signal dragged

const MATERIAL = preload("res://Game/SliderPieceMaterial.tres")
const SPEED = 700
const DEADZONE = 60

enum DIR {UP, RIGHT, DOWN, LEFT}

signal finished_moving

var id: int
var last_clicked = false
var dragged := false


func _input(event):
	if disabled:
		return
	if event is InputEventMouseMotion:
		var dir = get_drag_direction()
		if dir:
			emit_signal("dragged", self, dir)


func get_drag_direction():
	if not last_clicked or dragged:
		return false

	var diff = get_local_mouse_position() - last_clicked
	if diff.length() > DEADZONE:
		var angle = diff.angle()
		if angle < 0:
			angle += 2*PI
		if angle > PI/4 and angle <= 3*PI/4:
			return DIR.DOWN
		elif angle > 3*PI/4 and angle <= 5*PI/4:
			return DIR.LEFT
		elif angle > 5*PI/4 and angle <= 7*PI/4:
			return DIR.UP
		else:
			return DIR.RIGHT
	
	return false


func setup(texture, w, h, new_id) -> void:
	rect_size = Vector2(texture.get_width()/float(w),texture.get_height()/float(h))
	material = MATERIAL.duplicate()
	material.set_shader_param("tex", texture)
	material.set_shader_param("dimensions", Vector2(w,h))
	self.id = new_id
	material.set_shader_param("id", id)


func move_to(target_piece):
	var cur_pos = rect_global_position
	var target_pos = target_piece.rect_global_position
	$Tween.interpolate_property(self, "rect_global_position", rect_global_position, target_pos, \
								cur_pos.distance_to(target_pos)/float(SPEED), Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("finished_moving")


func _on_SliderPiece_button_up():
	last_clicked = false
	dragged = false


func _on_SliderPiece_button_down():
	last_clicked = get_local_mouse_position()
