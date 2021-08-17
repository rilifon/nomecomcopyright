extends TextureButton

var id: int


func setup(texture, w, h, id) -> void:
	material.set_shader_param("tex", texture)
	material.set_shader_param("dimensions", Vector2(w,h))
	material.set_shader_param("id", id)
	self.id = id
