extends CharacterBody3D
class_name MainPlayer

#CONFIGURATIONS
@export_category("Player")
@export_range(1, 1000, 1) var speed: float = 10 # m/s
var run_speed := 10
var crunch_speed = 2.0
var slide_speed := 20


#MOVE SYSTEM
@export_range(10, 1200, 1) var acceleration: float = 100 # m/s^2
@export_range(0.1, 15.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

#NODES
@onready var player_camera = %PlayerCamera as Camera3D
@onready var player_coll = %PlayerColl.shape as BoxShape3D
@onready var cameracontent = $Cameracontent as CameraContent


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var runing: bool = false
var crunching: bool = false
var sliding: bool = false
var walking: bool = false
var jumping: bool = false


var last_dir : Transform3D

var last_input_dir : Vector2
var slide_dir: Vector2 # Slide direction
var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim


var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity


func _unhandled_input(event):
	if event is InputEventMouseMotion and not sliding:
		look_dir = event.relative * 0.001
		if CONFIGAUTOLOAD.mouse_captured: _rotate_camera()
	
	if event.is_action_pressed("shift") and !runing and !crunching:
		disabled_all_movement_bools()
		runing = true
	if event.is_action_released("shift") and runing and !sliding:
		disabled_all_movement_bools()
	
	if event.is_action_pressed("control") and runing and !walking:
		disabled_all_movement_bools()
		sliding = true
		modify_camera(0.653,0.9,1.0,-5.0)
		%SlideTime.start()
	elif event.is_action_pressed("control") and !runing and !sliding:
		disabled_all_movement_bools()
		crunching = true
		modify_camera()
		modify_camera(0.653,0.9,1.0)
	elif event.is_action_released("control") and crunching:
		disabled_all_movement_bools()
		crunching = false
		modify_camera(0.653,0.9,1.0)
		modify_camera()
	
	if Input.is_action_just_pressed("jump") and not sliding: jumping = true

func _physics_process(delta):
	
	# if nothing happends, but player are in movement, automaticly walking on true
	if Input.get_vector("left_m", "right_m", "forward_m", "backward_m") != Vector2.ZERO and !runing and !walking and !sliding and !crunching:
		walking = true
	elif Input.get_vector("left_m", "right_m", "forward_m", "backward_m") == Vector2.ZERO:
		walking = false
	
	# if is sliding, last input dir can't save
	if !sliding:
		last_input_dir = Input.get_vector("left_m", "right_m", "forward_m", "backward_m")
		
	
	
#region For edward refact
	# IMPORTANT i refactorize this in other moment, not touch
	if walking:
		cameracontent.start_camera_animation(cameracontent.camera_animations.WALK)
		velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	elif runing:
		cameracontent.start_camera_animation(cameracontent.camera_animations.RUN)
		velocity = _run(delta) + _gravity(delta) + _jump(delta)
	elif sliding:
		velocity = _slide(delta) + _gravity(delta) + _jump(delta)
	elif crunching:
		cameracontent.start_camera_animation(cameracontent.camera_animations.CRUNCH)
		velocity = _crunch(delta) + _gravity(delta) + _jump(delta)
	else:
		cameracontent.start_camera_animation(cameracontent.camera_animations.IDLE)
		velocity = _gravity(delta) + _jump(delta)
	#end-
#endregion
	
	move_and_slide()


#region Movement region
func _walk(delta: float) -> Vector3:
	
	move_dir = Input.get_vector("left_m", "right_m", "forward_m", "backward_m")
	
	var _forward: Vector3 = global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	last_dir = global_transform.basis

	return walk_vel
func _run(delta: float) -> Vector3:
	
	move_dir = Input.get_vector("left_m", "right_m", "forward_m", "backward_m")
	
	var _forward: Vector3 = global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * run_speed * move_dir.length(), acceleration * delta)
	last_dir = global_transform.basis
	
	return walk_vel
func _slide(delta):
	#move_dir = Input.get_vector("left_m", "right_m", "forward_m", "backward_m")
	
	var _forward: Vector3 = last_dir * Vector3(last_input_dir.x, 0, last_input_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * slide_speed * last_input_dir.length(), acceleration * delta)
	
	return walk_vel
func _crunch(delta):
	move_dir = Input.get_vector("left_m", "right_m", "forward_m", "backward_m")
	
	var _forward: Vector3 = global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * crunch_speed * move_dir.length(), acceleration * delta)
	last_dir = global_transform.basis
	
	return walk_vel

#endregion

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	
	return grav_vel
func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

func disabled_all_movement_bools():
	runing = false
	sliding = false
	walking = false
	jumping = false
	crunching = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	rotation.y -= look_dir.x * camera_sens * sens_mod
	player_camera.rotation.x = clamp(player_camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func modify_camera(_player_coll_pos=1.302,_player_coll_size=2.0,_player_camera_position=1.96,_player_camera_rotation:=0.0):
		#NORMAL CAMERA
		%PlayerColl.position.y = _player_coll_pos
		player_coll.size.y = _player_coll_size
		player_camera.position.y = _player_camera_position
		player_camera.rotation_degrees.z = _player_camera_rotation


#region SIGNALS
# GINALS

func _on_slide_time_timeout():
	disabled_all_movement_bools()
	modify_camera()
#endregion

