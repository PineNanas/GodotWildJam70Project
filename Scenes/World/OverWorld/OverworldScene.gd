extends Node3D

var preloadded_bush = preload("res://Assets/Models/WorldObjects/dead_bushes.glb")
var list_of_trees = [preload("res://Assets/Models/WorldObjects/Tree 2 LFD.glb"),preload("res://Assets/Models/WorldObjects/WhiteSpruce LFD V1.glb")]


@onready var ground = %Ground as CSGBox3D


func _ready():
	auto_config()

func auto_config():
	randomize_bushes()

func randomize_bushes():
	
	for x in randi_range(500,500):
		var new_brush = preloadded_bush.instantiate()
		
		new_brush.position.x = (randf_range(ground.size.x / 2,-ground.size.x / 2))
		new_brush.position.z = (randf_range(ground.size.z / 2,-ground.size.z / 2))
		
		new_brush.rotation_degrees.y = randf_range(0,180)
		
		
		%Brushes.add_child(new_brush)
		
	for x in randi_range(15,25):
		var new_tree = list_of_trees.pick_random().instantiate()
		
		new_tree.position.x = (randf_range(ground.size.x / 2,-ground.size.x / 2))
		new_tree.position.z = (randf_range(ground.size.z / 2,-ground.size.z / 2))
		
		new_tree.rotation_degrees.y = randf_range(0,180)
		
		
		%Trees.add_child(new_tree)
