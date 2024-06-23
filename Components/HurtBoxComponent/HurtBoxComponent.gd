extends Area3D

class_name HurtBox

func give_hit(damage:int):
	pass



func _give_hit(damage:int):
	get_parent().give_hit()
