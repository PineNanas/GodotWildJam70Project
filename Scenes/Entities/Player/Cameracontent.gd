extends Node3D

class_name CameraContent
 # Variables para controlar el balanceo
var bobbing_speed = 12.0  # Velocidad del balanceo
var bobbing_amount = 0.02  # Cantidad de balanceo
var bobbing_phase = 0.0  # Fase actual del balanceo

var is_moving = true
# Referencia a la cámara

@onready var steps_sfx = %StepsSfx as AudioStreamPlayer3D
@onready var main_player = $".." as CharacterBody3D

@onready var camera_content_animation = %CameraContentAnimation as AnimationPlayer
var base_path:= "PlayerCamera/"


# Variables para controlar la animación
var horizontal_amplitude = 0.04 # La amplitud del movimiento horizontal
var vertical_amplitude = 0.02 # La amplitud del movimiento vertical
var object_speed = 7.0 # La velocidad del movimiento
var object_angle = 0.0 # El ángulo inicial

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

func _ready():
	object_angle = 0.0


func start_camera_animation(_animation:camera_animations):
	#if camera_content_animation.current_animation == base_path+id_to_string.get(_animation):return
	
	
	call(id_to_string.get(_animation))




# Variables para controlar el movimiento del jugador


func _process(delta):
	# Si el jugador está moviéndose, actualiza la fase del balanceo
	if is_moving:
		if not steps_sfx.playing:
			var step_sound = randi_range(1,16)
			steps_sfx.stream = load("res://Assets/Audio/SFX/PlayerActions/MP3 Grass Footsteps/Grass Footstep "+str(step_sound)+" LFD-2.mp3")
			steps_sfx.play()
			object_angle += object_speed * delta
	
		bobbing_phase += delta * bobbing_speed
		object_angle += object_speed * delta
		
		bobbing_phase = wrapf(bobbing_phase, 0.0, 2.0 * PI)

	else:
		# Resetear la fase cuando el jugador deja de moverse
		bobbing_phase = 0.0
		object_angle = 0
		
	#var new_x = sin(object_angle) * horizontal_amplitude

	# Calcular las nuevas posiciones usando la función sin
	
	var new_y = sin(object_angle) * (vertical_amplitude * 0.5)

	# Aplicar las nuevas posiciones
	#%Shovel.position.x = new_x
	
	%Shovel.position.y = new_y

	# Aplicar la rotación en el eje Y para un movimiento horizontal
	
	# Calcular la nueva posición de la cámara
	var bobbing_offset = sin(bobbing_phase) * bobbing_amount
	position.y = bobbing_offset
	


func walk():
	%StepsSfx.pitch_scale = 0.74
	bobbing_amount = 0.015
	bobbing_speed = 12.0
	object_speed = 3

func run():
	%StepsSfx.pitch_scale = 1.0
	bobbing_amount = 0.1
	bobbing_speed = 10.0
	object_speed = 7
func crunch():
	%StepsSfx.pitch_scale = 0.64
	bobbing_amount = 0.05
	bobbing_speed = 9.0
	object_speed = 4.1
	object_angle
	vertical_amplitude = 0.03

func idle():

	%StepsSfx.playing = false

	bobbing_amount = 0.01
	bobbing_speed = 2.0
	object_speed = 0
	
# Actualizar el estado de movimiento (llamar esto desde tu controlador de movimiento)
func set_moving(moving):
	is_moving = moving


func _on_steps_sfx_finished():
	if is_moving and main_player.is_on_floor():
		var step_sound = randi_range(1,16)
		steps_sfx.stream = load("res://Assets/Audio/SFX/PlayerActions/MP3 Grass Footsteps/Grass Footstep "+str(step_sound)+" LFD-2.mp3")
		steps_sfx.play()
	else:
		pass
