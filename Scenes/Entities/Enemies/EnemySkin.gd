extends Node3D
class_name EnemySkin

@onready var animation_tree: AnimationTree = $AnimationTree

@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")



@onready var is_moving : bool = false :
	set(value):
		is_moving = value
		if is_moving:
			state_machine.travel("Move")
		else:
			state_machine.travel("Idle")

# func hit() -> void:
# 	animation_tree["parameters/HitShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

# func death() -> void:
# 	state_machine.start("Death")