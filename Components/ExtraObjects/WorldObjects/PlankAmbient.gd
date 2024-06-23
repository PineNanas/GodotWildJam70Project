extends Node3D

@export var planks_mesh : Array[Mesh]
@export var plank_textures : Array[Texture2D]


func _ready():
	randomize_plank()

func randomize_plank():
	var new_plank = MeshInstance3D.new()
	
	new_plank.mesh = planks_mesh.pick_random()
	new_plank.material_override = StandardMaterial3D.new()
	var new_material = new_plank.material_override as StandardMaterial3D
	new_material.roughness = 0
	new_material.metallic_specular = 0.0
	new_plank.rotation_degrees.y = randf_range(0.0,275.0)
	new_material.albedo_texture = plank_textures[planks_mesh.find(new_plank.mesh)]
	
	add_child(new_plank)
	


