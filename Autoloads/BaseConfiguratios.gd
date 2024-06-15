extends Node

class_name auto_load_config

var mouse_captured:= false

func _ready():
	basic_autoconfig()


func basic_autoconfig():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true
