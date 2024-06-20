extends Area3D
class_name HurtBox


@onready var parent = get_parent()

func give_hit(damage:int):
	parent.take_damage(damage)
