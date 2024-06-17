extends Area3D

class_name WorldObjectInteract

@onready var parent = get_parent()

func interact():
	if parent.has_method("interact_action"):
		parent.interact_action()

