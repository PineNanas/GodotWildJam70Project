extends Area3D
class_name HurtBox


@onready var parent = get_parent()

func give_hit(damage:int):
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
	else:
		parent.get_parent().take_damage(damage)
