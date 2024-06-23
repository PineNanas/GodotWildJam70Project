extends MeshInstance3D

@export var maze_builder : MazeBuilder
@export var gui = CanvasLayer

var exit_door := false


	
func interact_action():

	for room_scape:RoomScapeSystem in maze_builder.all_room_scapes:
		
		if not room_scape.finished:
			return
	
	if exit_door:
		gui.exit_dungeon()
		CONFIGAUTOLOAD.finished_mazes += 1
		
		await get_tree().create_timer(1.0).timeout
		if CONFIGAUTOLOAD.finished_mazes >= 3:
			get_tree().change_scene_to_file("res://Scenes/World/Eooms/king_room.tscn")
		else:
			get_tree().change_scene_to_file("res://Components/MazeBuildComponent/MazeBuilder.tscn")

