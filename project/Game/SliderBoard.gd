extends Node2D

const PIECE = preload("res://Game/SliderPiece.tscn")

const MAX_ROWS : int = 20
const MAX_COLUMNS : int = 20
const WIDTH : int = 1024
const HEIGHT : int = 1024

export var rows : int
export var columns : int

var board : Array
var picture : ImageTexture

func _ready() -> void:
	print("atchim")
	picture = get_picture()
	make_board()

func get_picture(path : = "retangulo.jpg") -> ImageTexture:
	var IMAGE = load("res://Assets/" + path)
	var img : Image = IMAGE.get_data()
	
	img = scale_and_crop(img)
	
	img.save_png("res://Assets/imagem_rect.png")
	
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	
	return texture

func scale_and_crop(img) -> Image:
	var aspect_ratio = float(img.get_width()) / float(img.get_height())
	
	if img.get_width() >= img.get_height():
		img.resize(float(WIDTH) * aspect_ratio, HEIGHT)
	else: img.resize(WIDTH, float(HEIGHT) / aspect_ratio)
	
	return img.get_rect(Rect2((img.get_width() - WIDTH)/2, (img.get_height() - HEIGHT)/2, WIDTH, HEIGHT))

func make_board() -> void:
	for r in range(rows):
		for c in range(columns):
			var new_piece = PIECE.instance()
			board[r][c] = new_piece
			add_child(new_piece)
