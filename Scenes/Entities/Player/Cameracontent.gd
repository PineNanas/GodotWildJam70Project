extends Node3D

class_name CameraContent
 # Variables para controlar el balanceo
var bobbing_speed = 12.0  # Velocidad del balanceo
var bobbing_amount = 0.02  # Cantidad de balanceo
var bobbing_phase = 0.0  # Fase actual del balanceo

var is_moving = true
# Referencia a la cámara


@onready var camera_content_animation = %CameraContentAnimation as AnimationPlayer
var base_path:= "PlayerCamera/"
enum camera_animations {
	WALK,
	RUN,
	CRUNCH,
	IDLE
}
var id_to_string = {
	camera_animations.WALK:"walk",
	camera_animations.RUN:"run",
	camera_animations.CRUNCH:"crunch",
	camera_animations.IDLE:"idle"
	
} as Dictionary

func start_camera_animation(_animation:camera_animations):
	#if camera_content_animation.current_animation == base_path+id_to_string.get(_animation):return
	
	
	call(id_to_string.get(_animation))




# Variables para controlar el movimiento del jugador


func _process(delta):
	# Si el jugador está moviéndose, actualiza la fase del balanceo
	if is_moving:
		bobbing_phase += delta * bobbing_speed
		bobbing_phase = wrapf(bobbing_phase, 0.0, 2.0 * PI)
	else:
		# Resetear la fase cuando el jugador deja de moverse
		bobbing_phase = 0.0

	# Calcular la nueva posición de la cámara
	var bobbing_offset = sin(bobbing_phase) * bobbing_amount
	position.y = bobbing_offset

func walk():
	bobbing_amount = 0.015
	bobbing_speed = 12.0
	

func run():
	bobbing_amount = 0.1
	bobbing_speed = 10.0

func crunch():
	bobbing_amount = 0.05
	bobbing_speed = 9.0

func idle():
	bobbing_amount = 0.01
	bobbing_speed = 2.0

# Actualizar el estado de movimiento (llamar esto desde tu controlador de movimiento)
func set_moving(moving):
	is_moving = moving
