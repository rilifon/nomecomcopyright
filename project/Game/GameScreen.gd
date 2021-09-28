extends Control

export(NodePath) onready var slider_board = self.get_node(slider_board) as Control
export(NodePath) onready var moves_label = self.get_node(moves_label) as Label
export(NodePath) onready var time_label = self.get_node(time_label) as Label

var start_time : int
var ellapsed_time : int = 0

func _ready():
	start_time = OS.get_unix_time()


func _process(_delta):
	moves_label.text = str(slider_board.moves) + "\nMoves";
	ellapsed_time = OS.get_unix_time() - start_time
	time_label.text = format_time(ellapsed_time)


func format_time(ellapsed_seconds : int) -> String:
	var result : String = ""
# warning-ignore:integer_division
	var minutes = ellapsed_seconds / 60
	if minutes < 10:
		result += "0"
	result += str(minutes)
	result += ":"
	var seconds = ellapsed_seconds % 60
	if seconds < 10:
		result += "0"
	result += str(seconds)
	return result
