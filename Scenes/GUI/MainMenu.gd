extends Node3D

var preloadded_bush = preload("res://Assets/Models/WorldObjects/dead_bushes.glb")
var list_of_trees = [preload("res://Assets/Models/WorldObjects/Tree 2 LFD.glb"),preload("res://Assets/Models/WorldObjects/WhiteSpruce LFD V1.glb")]

@onready var ground = %Ground


func _ready():
	auto_config()


func auto_config():
	intro_splah()
	auto_generate_menu_enviroment_objects()


func intro_splah():
	var alpha := 1.0
	var time := 1.6
	var t_splash : Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t_splash.tween_property(%SplashScreenIntro,"modulate",Color(1.0,1.0,1.0,alpha),time)
	await t_splash.finished
	await get_tree().create_timer(0.2).timeout
	alpha = 0.0
	time = 0.8
	t_splash = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t_splash.tween_property(%SplashScreenIntro,"modulate",Color(1.0,1.0,1.0,alpha),time)

	var t_sound : Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t_sound.tween_property(%BGsound,"volume_db",0,time)
	await t_sound.finished
	t_splash = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t_splash.tween_property($GUI/ColorRect,"modulate",Color(1.0,1.0,1.0,alpha),time)

func outro():
	var t_splash : Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	t_splash.tween_property($GUI/ColorRect,"modulate",Color(1.0,1.0,1.0,1.0),4.0)
	%PlayTrans.play()
	await t_splash.finished
	
	return(true)
	
func auto_generate_menu_enviroment_objects():
	
	for x in randi_range(50,100):
		var new_brush = preloadded_bush.instantiate()
		
		new_brush.position.x = (randf_range(ground.size.x/4,-10.0))
		new_brush.position.z = (randf_range(ground.size.z/4,-10.0))
		
		new_brush.rotation_degrees.y = randf_range(0,180)
		
		
		%Brushes.add_child(new_brush)
		
	for x in randi_range(45,45):
		var new_tree = list_of_trees.pick_random().instantiate()
		
		new_tree.position.x = (randf_range(ground.size.x / 2,2.0))
		new_tree.position.z = (randf_range(ground.size.z / 2,2.0))
		
		new_tree.rotation_degrees.y = randf_range(0,180)
		
		
		%Trees.add_child(new_tree)


func _on_enter_button_input_event(camera, event, position, normal, shape_idx):
	
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			await outro()
			get_tree().change_scene_to_file("res://Scenes/World/OverWorld/OverworldScene.tscn")
	

func _on_exit_buton_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().quit()
