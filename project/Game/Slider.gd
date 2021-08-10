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
	
	var img_width = img.get_width()
	var img_height = img.get_height()
	
	if WIDTH - img_width >= HEIGHT - img_height:
		img.resize(img_width, HEIGHT)
	else: img.resize(WIDTH, img_height)
	
	img.crop(WIDTH, HEIGHT)
	
	texture.create_from_image(img)
	return texture
