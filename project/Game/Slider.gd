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


func get_picture(path : = "image.jpg") -> ImageTexture:
	var img = Image.new()
	var texture = ImageTexture.new()
	img.load("res://Assets/" + path)
	img.resize(WIDTH, HEIGHT) # essa linha vai ser trocada por algo que funciona uwu
	texture.create_from_image(img)
	return texture


func make_board() -> void:
	for r in range(rows):
		for c in range(columns):
			var new_piece = PIECE.instance()
			board[r][c] = new_piece
			add_child(new_piece)
