extends Node2D

const MAX_ROWS : int = 20
const MAX_COLUMNS : int = 20
const WIDTH : int = 1024
const HEIGHT : int = 1024

export var rows : int
export var columns : int

var picture : ImageTexture

func _ready() -> void:
	print("atchim")
	picture = get_picture()

func get_picture(path : = "image.jpg") -> ImageTexture:
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load("res://Assets/" + path)
	img.resize(WIDTH, HEIGHT)
	texture.create_from_image(img)
	return texture
