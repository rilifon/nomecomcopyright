extends GridContainer
onready var grid_child = get_child(get_child_count()-1)

func _ready():
	make_responsive()
	grid_child.connect("resized", self, "make_responsive")

func make_responsive():
	if rect_size.x < 320 * 3: columns = 1
	elif rect_size.x < 414 * 3: columns = 2
	elif rect_size.x < 912 * 3: columns = 3
	else: columns = 5
	
	var rows = get_child_count() / columns
	if get_child_count() % columns != 0: rows += 1
	
	rect_min_size.y = grid_child.rect_size.x * rows
	
