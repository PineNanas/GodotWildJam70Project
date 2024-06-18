extends CharacterBody3D
class_name Enemy

@export var current_health:int = 3:
	set(value):
		if value <= 0:
			current_health = 0
			is_death = true
			enemy_death()
		else:
			current_health = value
			# enemy_skin.hit()


@export var max_health:int = 3
@export var attack_power:int = 1
@export var is_death:bool = false
@export var speed:float = 10.0
@export var stop_distance:float = 2.0
@export var chase_distance:float = 10.0
@export var patrol: bool = false
@export var patrol_points: Array[Patrol_Point] = []


@onready var player: MainPlayer

@onready var is_patroling: bool = false
@onready var partrol_point_index = 0
var target_patrol_point:Patrol_Point
@onready var is_chasing: bool = false
var is_player_in_chase_area: bool = false

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var character_rotation_root: Node3D = $CharacterRotationRoot
@onready var chase_area_collision: CollisionShape3D = $CharacterRotationRoot/ChaseArea/ChaseAreaCollision
@onready var chase_timer: Timer = $ChaseTimer
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var enemy_skin: EnemySkin = $CharacterRotationRoot/EnemySkin

func _ready() -> void:
	player = get_tree().current_scene.get_node("MainPlayer")
	chase_area_collision.shape.radius = chase_distance
	if patrol:
		target_patrol_point = patrol_points[0]
		is_patroling = true
		target_patrol_point.body_entered.connect(_on_patrol_point_entered)

func _physics_process(delta: float) -> void:
	if is_death:
		return
	if ray_cast.get_collider() is MainPlayer:
		if is_chasing:
			chase_timer.start()
		# print("start chase")
		is_chasing = true
	if is_player_in_chase_area:
		_refresh_chase_ray()

	var direction_3d := (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	velocity = direction_3d * speed
	if navigation_agent_3d.distance_to_target() > stop_distance:
		print(navigation_agent_3d.distance_to_target())
		enemy_skin.is_moving = true
		move_and_slide()
	else:
		print(navigation_agent_3d.distance_to_target())
		enemy_skin.is_moving = false

	var direction_2d := Vector2(direction_3d.z, direction_3d.x)
	var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, direction_2d.angle() - PI/2,0)).normalized()
	character_rotation_root.quaternion = character_rotation_root.quaternion.slerp(target_quaternion, delta * 10)

func take_damage(damage:int) -> void:
	print("damaged",damage)
	current_health = current_health - damage

func enemy_death() -> void:
	# enemy_skin.death()
	await  get_tree().create_timer(3).timeout
	queue_free()


func _on_chase_area_body_entered(body: Node3D) -> void:
	if body is MainPlayer:
		is_player_in_chase_area = true
		# print("chase_area_body_entered")
		_refresh_chase_ray()

func _on_chase_area_body_exited(body: Node3D) -> void:
	if body is MainPlayer:
		is_player_in_chase_area = false
		# print("chase_area_body_exited")
		ray_cast.target_position = Vector3.ZERO

func _refresh_chase_ray() -> void:
	ray_cast.target_position =  player.global_position - ray_cast.global_position

func _on_timer_timeout() -> void:
	if is_chasing:
		navigation_agent_3d.target_position = player.global_position
		navigation_agent_3d.target_position = navigation_agent_3d.get_final_position()
	elif is_patroling:
		navigation_agent_3d.target_position = target_patrol_point.global_position
		navigation_agent_3d.target_position = navigation_agent_3d.get_final_position()
	else:
		navigation_agent_3d.target_position = global_position
		navigation_agent_3d.target_position = navigation_agent_3d.get_final_position()

func _on_chase_timer_timeout() -> void:
	# print("stop chase")
	is_chasing = false

func _on_patrol_point_entered(body: Node3D) -> void:
	if body == self:
		if is_patroling:
			partrol_point_index += 1
			if partrol_point_index >= patrol_points.size():
				partrol_point_index = 0
			target_patrol_point.body_entered.disconnect(_on_patrol_point_entered)
			target_patrol_point = patrol_points[partrol_point_index]
			target_patrol_point.body_entered.connect(_on_patrol_point_entered)
