extends Control

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
	reset_board()
	picture = get_picture()
	rows = 2
	columns = 2
	make_board()


func reset_board():
	board = []
	for child in Grid.get_children():
		Grid.remove_child(child)


func get_picture(path : = "retangulo.jpg") -> ImageTexture:
	var IMAGE = load("res://Assets/" + path)
	var img : Image = IMAGE.get_data()
	
	img = scale_and_crop(img)
	
# warning-ignore:return_value_discarded
	img.save_png("res://Assets/imagem_rect.png") # why is this here, Charles?
	
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
	var fake_piece = randi()%rows*columns
	board = [[]]
	#Upper padding
	for _i in range(columns+2):
		board[0].append(-1)
	for r in range(rows):           
		board.append([-1])
		for c in range(columns):
			create_piece(r, c, fake_piece == r*columns + c)
		board[r+1].append(-1)
	board.append([])
	#Lower padding
	for _i in range(columns+2):
		board[rows+1].append(-1)

func create_piece(r: int, c: int, fake_piece: bool) -> void:
	var new_piece = PIECE.instance()
	if fake_piece:
		new_piece.setup(picture, rows, columns, -1)
	else:
		new_piece.setup(picture, rows, columns, r * columns + c)
	board[r+1].insert(c+1, new_piece)
	Grid.add_child(new_piece)
	new_piece.connect("button_down", self, "_on_button_pressed", [new_piece])


func get_adjacent_free_space(piece):
	var id = piece.id
	var r = id%rows
	var c = id/rows
	for piece_pos in [[r,c-1],[r-1,c], [r,c+1], [r+1,c]]:
		var cur_piece = board[piece_pos[0]][piece_pos[1]]
		if cur_piece is Object and cur_piece.id == -1:
			return cur_piece
	return null


func _on_button_pressed(piece: TextureButton) -> void:
	if piece.id == -1:
		return
	
	var free_neighbour = get_adjacent_free_space(piece)
	if free_neighbour != null:
		print(free_neighbour.id)
	else:
		print("sem vizinhos")


func check_board() -> bool:
	# returns 'true' if board is solved yay
	var piece_counter := -1
	for row in board:
		for piece in row:
			if piece is TextureButton:
				if piece.id >= 0: 
					if piece.id > piece_counter:
						piece_counter = piece.id
					else:
						print("haha vc é pequena")
						return false
	return true
