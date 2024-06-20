extends Node3D


func _ready():
	
	erase_splash()

func erase_splash():
	%CutSceneAnimation.play("CutScene")
	
	await get_tree().create_timer(4.0).timeout
	var t_splash : Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t_splash.tween_property($Canvas/ColorRect,"modulate",Color(1.0,1.0,1.0,0.0),2.5)
	await t_splash.finished

