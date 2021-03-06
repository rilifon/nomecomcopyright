extends Control

export(NodePath) onready var slider_board = self.get_node(slider_board) as Control
export(NodePath) onready var moves_label = self.get_node(moves_label) as Label
export(NodePath) onready var timer_label = self.get_node(timer_label) as Label
export(NodePath) onready var ingame_settings = self.get_node(ingame_settings) as Control

var ellapsed_time : int = 0

var show_moves : bool = true setget set_show_moves
var show_timer : bool = true setget set_show_timer

func _ready():
	ingame_settings.connect("set_timer_visibility", self, "set_show_timer")
	ingame_settings.connect("set_moves_visibility", self, "set_show_moves")


func _process(_delta):
	moves_label.text = str(slider_board.moves) + "\nMoves";


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


func set_show_moves(val : bool):
	show_moves = val
	moves_label.visible = val


func set_show_timer(val : bool):
	show_timer = val;
	timer_label.visible = val;


func _on_SettingsButton_pressed():
	ingame_settings.show()
	get_tree().paused = true


func _on_RestartButton_pressed():
	TransitionManager.begin_transition()
	yield(TransitionManager, "screen_dimmed")
	slider_board.prepare_board()
	TransitionManager.end_transition()


func _on_Seconds_timeout():
	ellapsed_time += 1
	timer_label.text = format_time(ellapsed_time) + "\nMinutes"
