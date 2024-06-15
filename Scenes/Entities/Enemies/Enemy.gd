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


@onready var player: MainPlayer

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var character_rotation_root: Node3D = $CharacterRotationRoot
# @onready var enemy_skin: EnemySkin = $CharacterRotationRoot/EnemySkin


func _ready() -> void:
	player = get_tree().current_scene.get_node("MainPlayer")

func _physics_process(delta: float) -> void:
	if is_death:
		return
	var direction_3d := (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	velocity = direction_3d * speed
	if navigation_agent_3d.distance_to_target() > stop_distance:
		# enemy_skin.is_moving = true
		if is_on_floor():
			velocity.y = 0
		move_and_slide()
	else:
		# enemy_skin.is_moving = false
		pass
	var direction_2d := Vector2(direction_3d.z, direction_3d.x)
	var target_quaternion:Quaternion = Quaternion.from_euler(Vector3(0, direction_2d.angle(),0))
	character_rotation_root.quaternion = character_rotation_root.quaternion.slerp(target_quaternion, delta * 10)


func _on_timer_timeout() -> void:
	print("timer")
	navigation_agent_3d.target_position = player.global_position
	navigation_agent_3d.target_position = navigation_agent_3d.get_final_position()

func take_damage(damage:int) -> void:
	print("damaged",damage)
	current_health = current_health - damage

func enemy_death() -> void:
	# enemy_skin.death()
	await  get_tree().create_timer(3).timeout
	queue_free()
