extends CSGBox3D

func interact_action():
	get_tree().change_scene_to_file("res://Components/MazeBuildComponent/MazeBuilder.tscn")

