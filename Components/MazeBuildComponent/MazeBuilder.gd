extends Node3D

class_name MazeBuilder

signal branch_created

@export_category("Maze Builder Options")

## -1 its left, 1.0 right
@export_range(0.0,100.0,0.5) var turn_percentaje
@export_range(-1.0,1.0,1.0) var turn
var last_turn := 0

@export_range(0.0,100.0,0.5) var create_room_percentaje
@export var room_edge := 1


@export var segments_base_size := 1.0



@export_category("Nodes")


@onready var combiner_content = $CombinerContent

@export var rect_segment : Node3D

@onready var last_segment : Node3D = rect_segment

var its_forced_finished_maze := false

var segmens_from_the_last_room := 0
var segments_count := 0

var branch_dir := 0
#25,45,

var intersetion_angles := [45,90]

func _ready():
	CONFIGAUTOLOAD.basic_autoconfig()
	generate_maze(randi_range(9,15))

func _input(event):
	if event.is_action_pressed("enter"):
		#var map_s = load("res://Resources/MazeResources/MazeMapsInfo.gd")
		#var aux : Array
		#var count := 0
		#
		#for way in $CombinerContent.get_children():
			#if count != 0: 
				#aux.append([way.transform.basis,way.position])
				#
			#
			#count += 1
		#
		#CONFIGAUTOLOAD.save_new_map(aux)
		#erase_map()
		#await get_tree().create_timer(2.0).timeout
		#load_map(CONFIGAUTOLOAD.maps.pick_random())
		erase_map()
		generate_maze(randi_range(7,15))




func generate_maze(_amount:int):
	
	var rect_turn_count := 0
	
	for x in _amount:
		
		await get_tree().create_timer(0.1).timeout
		var fix_angle := 0
		



		var is_turn := false
		
		if turn:
			if turn_percentaje != null and randf_range(0.0,100.0) <= turn_percentaje:
				is_turn = true
		else:
			rect_turn_count += 1
		if rect_turn_count >= 3:
			if randf_range(0.0,100.0) <= 70:
				is_turn = true
			rect_turn_count = 0
		
		var new_segment = rect_segment.duplicate() as Node3D
		if its_forced_finished_maze: return
		
		new_segment.position = last_segment.position
		new_segment.visible = true
	
	
		if is_turn:
			new_segment.position += last_segment.transform.basis.z * segments_base_size
			var new_corner : Node3D
			var angle_for_corner = intersetion_angles.pick_random()
			
			if branch_dir == 0:

				
				
				if angle_for_corner == 90:
					# New Segment Configuration
					
					new_segment.rotation_degrees.y = last_segment.rotation_degrees.y + -turn * angle_for_corner
					new_segment.position += new_segment.transform.basis.z * (segments_base_size/2.705)
					new_segment.position -= new_segment.transform.basis.x * (-turn * 1.5)
					new_corner = %"90Angle".duplicate()
					
					new_corner.transform.basis = new_segment.transform.basis
					new_corner.position = new_segment.position
					new_corner.position += new_corner.transform.basis.x * (-turn * 0.015)

					new_corner.position -= new_segment.transform.basis.z * (segments_base_size / 1.34)
					
				elif angle_for_corner == 45:
					# New Segment Configuration
					new_segment.rotation_degrees.y = last_segment.rotation_degrees.y + -turn * angle_for_corner
					new_segment.position += new_segment.transform.basis.z * (segments_base_size/4)
					new_segment.position -= new_segment.transform.basis.x * (-turn * 0.38)
					
					# Conrer Configuration
					new_corner = %"45Angle".duplicate()

					new_corner.transform.basis = last_segment.transform.basis
					new_corner.position = last_segment.position
					new_corner.position += new_corner.transform.basis.x * (turn * 0.01)

					new_corner.position += new_corner.transform.basis.z * (segments_base_size)
				
				new_corner.scale.x = turn
				new_corner.visible = true 
				combiner_content.add_child(new_corner)
				
			else:
				new_segment.rotation_degrees.y = last_segment.rotation_degrees.y + branch_dir * randf_range(90.0,90.0)
				branch_dir = 0
				new_segment.position += new_segment.transform.basis.y * ((new_segment.height / 1.7) + new_segment.radius)
			
			is_turn = false
			
		else:
			
			new_segment.rotation = last_segment.rotation
			
			new_segment.position += last_segment.transform.basis.z * segments_base_size
		
		randomize_next_direction()
		
		combiner_content.add_child(new_segment)
		if segmens_from_the_last_room != 0:
			segmens_from_the_last_room += 1
		if segmens_from_the_last_room == 7:
			segmens_from_the_last_room = 0
		
		last_segment = new_segment
		
		segments_count += 1
		
		if last_segment.is_in_group("rectsegment"):
			try_create_room(new_segment)
	
	if not its_forced_finished_maze:
		create_final_door()

func verify_maze_size():
	if segments_count < 4:
		erase_map()
		generate_maze(randi_range(4,4)) 
		segments_count = 0

func try_create_room(_pipe):
	if randi_range(0,200) >= 150: return
	if segmens_from_the_last_room != 0: return
	var wall_to_change : MeshInstance3D
	
	room_edge = randi_range(0,1)
	
	if room_edge == 1:
		wall_to_change = last_segment.get_node("RightWall")
	elif room_edge == 0:
		wall_to_change = last_segment.get_node("LeftWall")
		
	
	wall_to_change.mesh = load("res://Assets/Models/Building/Walls/Wall_Doorway.obj")
	
	wall_to_change.material_overlay = StandardMaterial3D.new()
	var wall_material = wall_to_change.material_overlay as StandardMaterial3D
	wall_material.metallic_specular = 0.0
	wall_material.roughness = 0.0
	wall_material.albedo_color = Color("737373")
	wall_to_change.material_overlay.albedo_texture = load("res://Assets/Textures/DungeonTexture/WallDorway.png")
	
	segmens_from_the_last_room = 1
	
	var new_room = %Room.duplicate()
	new_room.transform.basis = _pipe.transform.basis

	if room_edge == 1:
		new_room.rotation_degrees.y += 90 
		_pipe.get_node("Door").position = _pipe.get_node("StaticR").position
		_pipe.get_node("StaticR").queue_free()
		#new_room.position += _pipe.transform.basis.x * (7.0 + 3.0)
	elif room_edge == 0:
		new_room.rotation_degrees.y -= 90 
		_pipe.get_node("Door").position = _pipe.get_node("StaticL").position
		_pipe.get_node("StaticL").queue_free()
	#	new_room.position -= _pipe.transform.basis.x * (7.0 + 3.0)
	new_room.position = _pipe.position
	new_room.position.y = -2.291
	new_room.position -= new_room.transform.basis.z * (7.0 + 3.0)
	new_room.position += _pipe.transform.basis.z * (7.0/6)
	
	
	
	combiner_content.add_child(new_room)
	
func erase_map():
	last_segment = rect_segment
	var count = 0
	for x in $CombinerContent.get_children():
		if count != 0:
			x.queue_free()
		count += 1

func load_map(map_info:Array):
	
	for date in map_info:
		
		var new_pipe = %RectPipe.duplicate()
		
		new_pipe.transform.basis = date[0]
		new_pipe.position = date[1]
		
		
		combiner_content.add_child(new_pipe)


func randomize_next_direction():
	
	turn = float(randi_range(-1,1))
	
	if turn == 0:
		turn = 1


func forced_finish_maze():
	
	its_forced_finished_maze = true
	#last_segment.queue_free()
	for x in 3:
		await get_tree().create_timer(0.1).timeout
		
		var last = combiner_content.get_children()[combiner_content.get_child_count() - 1]
		last.queue_free()
		combiner_content.remove_child(last)
		last_segment = combiner_content.get_children()[combiner_content.get_child_count() - 1]
	
	while !combiner_content.get_children()[combiner_content.get_child_count() - 1].is_in_group("angle"):
		await get_tree().create_timer(0.1).timeout
		
		var last = combiner_content.get_children()[combiner_content.get_child_count() - 1]
		last.queue_free()
		combiner_content.remove_child(last)
		
		
		last_segment = combiner_content.get_children()[combiner_content.get_child_count() - 1]
		
	#combiner_content.get_children()[combiner_content.get_child_count() - 1].queue_free()
	
	create_final_door()
func create_final_door():
	var last_way = combiner_content.get_children()[combiner_content.get_child_count() - 1]
	
	
	await get_tree().create_timer(0.1).timeout
	
	if last_way.is_in_group("angle"):
		last_way.queue_free()
		combiner_content.remove_child(last_way)
		
		last_segment = combiner_content.get_children()[combiner_content.get_child_count() - 1]
		
		create_final_door()
	else:
		var new_door = %FinalDoor.duplicate()
		new_door.transform.basis = last_segment.transform.basis
		
		new_door.position = last_segment.position
		new_door.position += last_segment.transform.basis.z * (segments_base_size)
		new_door.exit_door = true
		combiner_content.add_child(new_door)
		
	verify_maze_size()

func _on_collition_detector_area_entered(area):
	if not its_forced_finished_maze:
		forced_finish_maze()
