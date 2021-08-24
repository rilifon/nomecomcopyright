extends Node2D

const PIECE = preload("res://Game/SliderPiece.tscn")
const TEST_TEXTURE = preload("res://icon.png")

const MAX_ROWS : int = 20
const MAX_COLUMNS : int = 20
const WIDTH : int = 1024
const HEIGHT : int = 1024

export var rows : int
export var columns : int

onready var Grid = $GridContainer

var board : Array
var picture : ImageTexture

func _ready() -> void:
	randomize()
	picture = get_picture()
	rows = 2
	columns = 2
	make_board()


func get_picture(path : = "retangulo.jpg") -> ImageTexture:
	var IMAGE = load("res://Assets/" + path)
	var img : Image = IMAGE.get_data()
	
	img = scale_and_crop(img)
	
# warning-ignore:return_value_discarded
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
	board = []
	var fake_piece = randi()%rows*columns
	for r in range(rows):
		board.append([])
		for c in range(columns):
			create_piece(r, c, fake_piece == r*columns + c)

func create_piece(r: int, c: int, fake_piece: bool) -> void:
	var new_piece = PIECE.instance()
	if fake_piece:
		new_piece.setup(picture, rows, columns, -1)
	else:
		new_piece.setup(picture, rows, columns, r * columns + c)
	board[r].insert(c, new_piece)
	Grid.add_child(new_piece)
	new_piece.connect("button_down", self, "_on_button_pressed", [new_piece])

func _on_button_pressed(_piece: TextureButton) -> void:
	pass
