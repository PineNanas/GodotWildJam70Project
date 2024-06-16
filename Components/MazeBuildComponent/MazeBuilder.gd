extends Node3D

class_name MazeBuilder

signal branch_created

@export_category("Maze Builder Options")

## -1 its left, 1.0 right
@export_range(-1.0,1.0,1.0) var turn
var last_turn := 0

@export_range(0.0,100.0,0.5) var turn_percentaje

@export_category("Nodes")
@onready var combiner_content = $CombinerContent

@export var rect_pipe : CSGCylinder3D

@onready var last_pipe : CSGCylinder3D = rect_pipe

var branch_dir := 0
var intersetion_angles := [25,45,90]

func _ready():
	generate_maze(10)

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
		generate_maze(randi_range(5,15))

func generate_maze(_amount:int):
	
	var rect_turn_count := 0
	
	for x in _amount :
		
		var fix_angle := 0
		
		#fix_angle = verify_wall_collition()
		
		#await get_tree().create_timer(2.0).timeout
		
		var is_turn := false
		
		if randi_range(0,100) < 2:
			var aux_last_pipe = last_pipe
			
			turn = 1
			#
			generate_brach(randi_range(1,5))
			await "branch_created"
			last_pipe = aux_last_pipe

		
		if turn:
			if randf_range(0.0,100.0) <= turn_percentaje:
				is_turn = true
			
		else:
			rect_turn_count += 1
		
		if rect_turn_count >= 2:
			if randf_range(0.0,100.0) <= 70:
				is_turn = true
		
		
		var new_pipe = rect_pipe.duplicate() as CSGCylinder3D
		

		
		new_pipe.position = last_pipe.position
		
		#new_pipe.height += randf_range(1.0,12.0)
		new_pipe.get_child(0).height = new_pipe.height + 0.1
		
		

		
		if is_turn:
			new_pipe.position += last_pipe.transform.basis.y * ((last_pipe.height / 2) + (new_pipe.radius))
			if branch_dir == 0:
				
				new_pipe.rotation_degrees.y = last_pipe.rotation_degrees.y + -turn * intersetion_angles.pick_random()
				new_pipe.position += new_pipe.transform.basis.y * ((new_pipe.height / 2) + new_pipe.radius)
			else:
				new_pipe.rotation_degrees.y = last_pipe.rotation_degrees.y + branch_dir * randf_range(45.0,45.0)
				branch_dir = 0
				new_pipe.position += new_pipe.transform.basis.y * ((new_pipe.height / 1.7) + new_pipe.radius)
			
			is_turn = false
			
		else:
			
			new_pipe.rotation = last_pipe.rotation
			
			new_pipe.position += last_pipe.transform.basis.y * ((last_pipe.height / 2) + (new_pipe.height / 2))
		randomize_next_direction()
		combiner_content.add_child(new_pipe)
		try_create_room(new_pipe)
		
		last_pipe = new_pipe
		

func generate_brach(_amount:int):
	
	
	var first := true
	
	
	for x in _amount :
		#verify_wall_collition()
		
		#await get_tree().create_timer(2.0)
		
		print("b")
		
		var is_turn := false
		
		
		if turn:
			if randf_range(0.0,100.0) <= turn_percentaje:
				is_turn = true

		
		var new_pipe = rect_pipe.duplicate() as CSGCylinder3D
		

		
		new_pipe.position = last_pipe.position
		
		new_pipe.get_child(0).height = new_pipe.height + 0.1
		
		


			
		if is_turn:

			new_pipe.position += last_pipe.transform.basis.y * ((last_pipe.height / 2) + (new_pipe.radius))
			
			if first:
				branch_dir = turn
				new_pipe.rotation_degrees.y = last_pipe.rotation_degrees.y + -turn * (randf_range(45.0,45.0))
				new_pipe.position += new_pipe.transform.basis.y * ((new_pipe.height / 1.7) + new_pipe.radius)
				
			else:
				new_pipe.rotation_degrees.y = last_pipe.rotation_degrees.y + -turn * intersetion_angles.pick_random()
				
			
			
				new_pipe.position += new_pipe.transform.basis.y * ((new_pipe.height / 2) + new_pipe.radius)
			
		else:
			
			new_pipe.rotation = last_pipe.rotation
			
			new_pipe.position += last_pipe.transform.basis.y * ((last_pipe.height / 2) + (new_pipe.height / 2))
			
		#try_create_room(new_pipe)
		randomize_next_direction()
		combiner_content.add_child(new_pipe)
		
		last_pipe = new_pipe

func try_create_room(_pipe):
	if not randi_range(0,200) <= 50: return
	
	var direction = randi_range(0,1)
	
	var new_room = %Room.duplicate()
	
	new_room.transform.basis = _pipe.transform.basis
	new_room.position = _pipe.position
	new_room.position -= _pipe.transform.basis.x * 12
	
	
	new_room.visible = true
	
	combiner_content.add_child(new_room)
	
	var new_cover_cyl = %CoverCyl.duplicate()
	
	new_cover_cyl.transform.basis = new_room.transform.basis
	new_cover_cyl.rotation_degrees.y += 90
	new_cover_cyl.position = new_room.position
	new_cover_cyl.position += new_cover_cyl.transform.basis.y * (new_room.size.x/2)
	
	new_cover_cyl.visible = true
	combiner_content.add_child(new_cover_cyl)
	
	var new_hole_cyl = %Hole.duplicate()
	new_hole_cyl.position = new_cover_cyl.position
	new_hole_cyl.transform.basis = new_cover_cyl.transform.basis
	new_hole_cyl.visible = true
	combiner_content.add_child(new_hole_cyl)

#func verify_wall_collition():
	#%WallCollition.transform = last_pipe.transform
	#%WallCollition.position = last_pipe.position
	#%WallCollition.position += last_pipe.transform.basis.y * (last_pipe.height)
	#
	#
	#
	#if %WallCollition.is_colliding():
		#for angle in intersetion_angles:
			#%WallCollition.rotation_degrees.y = %WallCollition.rotation_degrees.y + angle

func erase_map():
	last_pipe = rect_pipe
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
	#
	#if turn == last_turn:
		#turn = -turn
		#
		##if randi_range(0,1):
			##
		##else:
			##turn = 0
	#
	#if last_turn != 0:
		#last_turn = turn
	
