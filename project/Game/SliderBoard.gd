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
var moves : int = 0;

func _ready() -> void:
	randomize()
	reset_board()
	picture = get_picture()
	rows = 4
	columns = 4
	$GridContainer.columns = columns
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


#For debugging
func print_board() -> void:
	print("=============")
	for i in range(board.size()):
		var text = ""
		for j in range(board[i].size()):
			text += str(board[i][j]) + " "
		print(text)
	print("=============")


func create_piece(r: int, c: int, fake_piece: bool) -> void:
	var new_piece = PIECE.instance()
	if fake_piece:
		new_piece.setup(picture, rows, columns, -1)
	else:
		new_piece.setup(picture, rows, columns, r * columns + c)
	board[r+1].insert(c+1, new_piece)
	Grid.add_child(new_piece)
	new_piece.connect("button_down", self, "_on_button_pressed", [new_piece])


func get_piece_board_position(piece) -> Vector2:
	var pos = Vector2.ZERO
	var found = false
	for i in range(board.size()):           
		for j in range(board[i].size()):
			if board[i][j] is Object and board[i][j] == piece:
				pos = Vector2(i,j)
				found = true
				break
		if found:
			break
	assert(found, "Couldn't find this piece")
	return pos


func get_adjacent_free_space(piece):
	var piece_pos = get_piece_board_position(piece)
	var r = piece_pos[0]
	var c = piece_pos[1]
	for pos in [[r,c-1],[r-1,c], [r,c+1], [r+1,c]]:
		var cur_piece = board[pos[0]][pos[1]]
		if cur_piece is Object and cur_piece.id == -1:
			return cur_piece
	return null


func exchange_pieces_position(piece1, piece2) -> void:
	moves += 1
	
	var p1_pos = get_piece_board_position(piece1)
	var p2_pos = get_piece_board_position(piece2)
	
	board[p1_pos.x][p1_pos.y] = piece2
	board[p2_pos.x][p2_pos.y] = piece1
	
	var p1_new_grid_index = (p2_pos.x - 1)*columns + p2_pos.y - 1
	var p2_new_grid_index = (p1_pos.x - 1)*columns + p1_pos.y - 1
	if p2_new_grid_index > p1_new_grid_index:
		Grid.move_child(piece2, p2_new_grid_index)
		Grid.move_child(piece1, p1_new_grid_index)
	else:
		Grid.move_child(piece1, p1_new_grid_index)
		Grid.move_child(piece2, p2_new_grid_index)
	
	if check_board():
		print("haha img go brr")


func enable_pieces():
	for piece in Grid.get_children():
		piece.disabled = false


func disable_pieces():
	for piece in Grid.get_children():
		piece.disabled = true


func _on_button_pressed(piece: TextureButton) -> void:
	if piece.id == -1:
		return
	
	var free_neighbour = get_adjacent_free_space(piece)
	if free_neighbour != null:
		piece.move_to(free_neighbour)
		disable_pieces()
		
		yield(piece, "finished_moving")
		
		enable_pieces()
		exchange_pieces_position(piece, free_neighbour)
	else:
		print("sem vizinhos")


func check_board() -> bool:
	# returns 'true' if board is solved yay
	var expected_id : int = 0
	for row in board:
		for piece in row:
			if piece is TextureButton:
				if piece.id >= 0: 
					if piece.id != expected_id:
						return false
				expected_id += 1
	return true
