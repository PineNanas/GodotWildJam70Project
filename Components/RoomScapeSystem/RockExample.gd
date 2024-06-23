extends Node3D

@export var room_manager : RoomScapeSystem

@export var coll : CollisionShape3D
var life_amount := 3

func give_hit():
	life_amount -= 1
	$Hit.play()

	verify_live()


func verify_live():
	if life_amount <= 0:
		room_manager.rock_deleted()
		position.y -= 5
		$Broken.play()
		await get_tree().create_timer(1.0).timeout
		
		queue_free()
	
