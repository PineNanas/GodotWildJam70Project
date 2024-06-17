extends Node3D

@export var object_to_randomize : Array[PackedScene]
@export var point_aviables : Array[Marker3D]

@export_range(0.0,100.0) var randomize_posivility = 0.0

@export var is_randomize := false

@export var randomize_amount := false
@export var amount_of_objects := 0

func _ready():
	for child in get_children():
		if child is Marker3D:
			point_aviables.append(child)
	
	if is_randomize:
		randomize_objects()

func randomize_objects():
	var aux_amount_obj = 0
	
	if randomize_posivility == 0.0: pass
	elif randi_range(0,100) >= randomize_posivility: return
	
	if not point_aviables.is_empty():
		
		if randomize_amount:
			aux_amount_obj = randi_range(1,5)
		else:
			aux_amount_obj = amount_of_objects
		
		for i in aux_amount_obj:
			if not point_aviables.is_empty():
				var new_object = object_to_randomize.pick_random().instantiate() 
				var random_point = point_aviables.pick_random()
				
				new_object.position = random_point.position 
				new_object.scale = Vector3(0.5,0.5,0.5)
				point_aviables.erase(random_point)
				add_child(new_object)
	else:
		
		if randomize_amount:
			aux_amount_obj = randi_range(1,5)
		else:
			aux_amount_obj = amount_of_objects
		
		for i in aux_amount_obj:
			var new_object = object_to_randomize.pick_random().instantiate() 
			var max_x_point = %BaseSpawnFloor.mesh.size.x / 2
			var max_z_point = %BaseSpawnFloor.mesh.size.z / 2
			
			new_object.scale = Vector3(0.5,0.5,0.5)
			new_object.position.x = randf_range(max_x_point,-max_x_point) 
			new_object.position.z = randf_range(max_z_point,-max_z_point) 
			
			add_child(new_object)
		
	

