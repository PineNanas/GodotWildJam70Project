extends Node

class_name LifeComponent

@export var life_amount := 5

func give_hit(amount:int):
	if not (life_amount - amount <= 0):
		life_amount -= amount
	else:
		die()

func hit_animation():
	pass

func die():
	pass
