extends Node3D

@export var meshes : Array[MeshInstance3D]

@export var crown_mesh : Array[MeshInstance3D]
func _ready():
	add_textures()

func _process(delta):
	$Crown.rotation_degrees.y += 0.5
	
func interact_action():
	get_tree().quit()
	
func add_textures():
	var new_material = StandardMaterial3D.new() as StandardMaterial3D
	
	new_material.albedo_texture = load("res://Assets/Textures/DungeonTexture/DefaultMaterial_BaseColor.png")
	new_material.roughness = 0.0
	new_material.metallic_specular = 0.0
	new_material.metallic = 0.0
	
	for mesh in meshes:
		mesh.material_override = new_material
	
	new_material = StandardMaterial3D.new()
	
	new_material.albedo_texture = load("res://Assets/Textures/Entities/Enemies/King/xk Texel 1k 2k 4k.001_BaseColor.png")
	new_material.roughness = 0.0
	new_material.metallic_specular = 0.0
	new_material.metallic = 0.0
	
	for mesh in crown_mesh:
		mesh.material_override = new_material
	
	pass
