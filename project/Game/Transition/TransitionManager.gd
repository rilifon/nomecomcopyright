extends CanvasLayer

signal finished
signal screen_dimmed

onready var transition_texture = $TransitionTexture
onready var tween = $Tween

const DURATION = .5

var active = false
var material : ShaderMaterial

func _ready():
	randomize()
	material = $TransitionTexture.material


func randomize_direction():
	for par in ["mirror_x", "mirror_y"]:
		material.set_shader_param(par, randi() % 2)


func invert_direction():
	for par in ["mirror_x", "mirror_y"]:
		material.set_shader_param(par, !material.get_shader_param(par))


func transition_to(scene_path: String):
	randomize_direction()
	active = true
	transition_texture.show()
	tween.interpolate_property(material, "shader_param/value", 0, 1, DURATION)
	tween.start()
	
	yield(tween, "tween_completed")
	yield(get_tree(), "idle_frame")
	
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_path)
	
	invert_direction()
	tween.interpolate_property(material, "shader_param/value", 1, 0, DURATION)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree(), "idle_frame")
	active = false
	transition_texture.hide()
	
	emit_signal("finished")


func begin_transition():
	randomize_direction()
	active = true
	transition_texture.show()
	tween.interpolate_property(material, "shader_param/value", 0, 1, DURATION)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree(), "idle_frame")
	
	emit_signal("screen_dimmed")


func end_transition():
	invert_direction()
	tween.interpolate_property(material, "shader_param/value", 1, 0, DURATION)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree(), "idle_frame")
	active = false
	transition_texture.hide()
	
	emit_signal("finished")


func single_out_transition():
	randomize_direction()
	active = true
	transition_texture.show()
	end_transition()
