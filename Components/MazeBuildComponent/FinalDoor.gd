extends MeshInstance3D

var exit_door := false

func interact_action():
	if exit_door:
		get_tree().change_scene_to_file("res://Components/MazeBuildComponent/MazeBuilder.tscn")
	
