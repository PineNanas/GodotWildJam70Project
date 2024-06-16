extends Node

class_name auto_load_config

var maps : Array



var maze_info = load("res://Resources/MazeResources/MazeMapsInfo.gd")

var mouse_captured:= false

func _ready():
	basic_autoconfig()

func save_new_map(_map):
	maps.append(_map)
	


func save_in_file():
	pass

func basic_autoconfig():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true
