extends CanvasLayer


func enter_dungeon():
	var t_transition : Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t_transition.tween_property($TransitionColor,"modulate",Color(1.0,1.0,1.0,0.0),1.0)

func exit_dungeon():
	var t_transition : Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t_transition.tween_property($TransitionColor,"modulate",Color(1.0,1.0,1.0,1.0),1.0)
