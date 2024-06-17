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
	pass


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
	
		bobbing_phase += delta * bobbing_speed
		bobbing_phase = wrapf(bobbing_phase, 0.0, 2.0 * PI)
	else:
		# Resetear la fase cuando el jugador deja de moverse
		bobbing_phase = 0.0

	# Calcular la nueva posición de la cámara
	var bobbing_offset = sin(bobbing_phase) * bobbing_amount
	position.y = bobbing_offset


func walk():
	%StepsSfx.pitch_scale = 0.74
	bobbing_amount = 0.015
	bobbing_speed = 12.0
	

func run():
	%StepsSfx.pitch_scale = 1.0
	bobbing_amount = 0.1
	bobbing_speed = 10.0

func crunch():
	%StepsSfx.pitch_scale = 0.64
	bobbing_amount = 0.05
	bobbing_speed = 9.0



func idle():

	%StepsSfx.playing = false

	bobbing_amount = 0.01
	bobbing_speed = 2.0

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
