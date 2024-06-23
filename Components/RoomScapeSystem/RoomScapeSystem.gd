extends Node3D


class_name RoomScapeSystem

@export var floor_spawn : MeshInstance3D
@export var door_to_close : Node3D

var rocks_to_create := 1

var finished := false


var first := true

#func _ready():
	#if floor_spawn and door_to_close:
		#create_scape_system()

func create_scape_system():
	rocks_to_create = randi_range(rocks_to_create,4)
	if not first: return
	first = false
	door_to_close.get_children()[2].get_children()[0].set_deferred("disabled",false)
	door_to_close.visible = true
	$DoorClosed.play()
	
	if verify_door_rotation():
		door_to_close.position += door_to_close.transform.basis.z * 1.56
	
	for x in rocks_to_create:
		var new_rock = %RockExample.duplicate()
		
		new_rock.position.x = randf_range(-(floor_spawn.mesh.size.x/2) + 0.6,(floor_spawn.mesh.size.x/2) - 0.6)
		new_rock.position.z = randf_range(-(floor_spawn.mesh.size.y/2) + 0.6,(floor_spawn.mesh.size.y/2) - 0.6)
		new_rock.position.y = 0.21
		new_rock.visible = true
		
		new_rock.coll.shape = %RockExample.get_children()[0].get_children()[0].shape
		
		$Rocks.add_child(new_rock)

func verify_door_rotation():
	var room = get_parent().get_parent() as Node3D
	
	if get_parent().get_parent().has_node("to_left"):
		return true
	return false


func rock_deleted():
	rocks_to_create -= 1
	if rocks_to_create <= 0:
		finished = true
		open_door()

func open_door():
	door_to_close.get_children()[2].get_children()[0].set_deferred("disabled",true)
	door_to_close.visible = false
	$DoorOpen.play()

func _on_player_detection_area_entered(area):
	create_scape_system()
