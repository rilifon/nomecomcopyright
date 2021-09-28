extends ColorRect

enum ANIMS {
	SHADER1
}
const ANIMATIONS = ["shader1"];

export(Material) var shader_mat;
export(ANIMS) var animation;

func _ready():
	self.material = shader_mat;
	$AnimationPlayer.play(ANIMATIONS[animation]);
