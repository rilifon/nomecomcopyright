extends GridContainer
onready var grid_child = get_child(get_child_count()-1)


func _ready():
	on_resize_screen()
	connect("resized", self, "on_resize_screen")
	
	for image in get_children():
		image.connect("pressed", self, "on_image_pressed", [image])


func on_resize_screen():
	if rect_size.x < 320 * 3: columns = 1
	elif rect_size.x < 414 * 3: columns = 2
	elif rect_size.x < 912 * 3: columns = 3
	else: columns = 5
	
	var rows = get_child_count() / columns
	if get_child_count() % columns != 0: rows += 1
	
	rect_min_size.y = grid_child.rect_size.x * rows
	
	
func on_image_pressed(image):
	var game = load("res://Game/GameScreen.tscn").instance()
	var board = game.get_node("VBoxContainer/SliderBoard")
	
	board.picture = board.get_picture(image.texture_normal.resource_path)
	
	get_tree().get_root().add_child(game)
	owner.queue_free()
