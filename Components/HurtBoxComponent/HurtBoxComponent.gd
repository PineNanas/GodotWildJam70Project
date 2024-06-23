extends Area3D
class_name HurtBox


@onready var parent = get_parent()

func give_hit(damage:int):
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
	else:
		var paparent = parent.get_parent()
		if paparent.has_method("take_damage"):
			paparent.take_damage(damage)
		else:
			pass



func _give_hit(damage:int):
	if parent.has_method("give_hit"):
		parent.give_hit()
	else:
		pass
