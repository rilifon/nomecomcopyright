extends TextureButton

const MATERIAL = preload("res://Game/SliderPieceMaterial.tres")

var id: int


func setup(texture, w, h, new_id) -> void:
	rect_size = Vector2(texture.get_width()/float(w),texture.get_height()/float(h))
	material = MATERIAL.duplicate()
	material.set_shader_param("tex", texture)
	material.set_shader_param("dimensions", Vector2(w,h))
	self.id = new_id
	material.set_shader_param("id", id)
