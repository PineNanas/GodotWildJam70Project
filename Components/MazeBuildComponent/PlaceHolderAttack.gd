extends Node3D

@export var ray : HitBox

func _input(event):
	if event.is_action_pressed("atk"):
		hit()

func hit():
	ray.hit(HitBox.type_of_hit.LIGHT)

