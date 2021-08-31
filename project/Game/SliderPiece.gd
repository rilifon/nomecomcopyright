extends TextureButton

const MATERIAL = preload("res://Game/SliderPieceMaterial.tres")
const SPEED = 700

signal finished_moving

var id: int


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
