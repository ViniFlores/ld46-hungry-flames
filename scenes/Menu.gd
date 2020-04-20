extends Control

var TIME = float(0)

func _process(delta):
	TIME += delta
	if (Input.is_action_just_pressed("pickup")):
		get_tree().change_scene("res://scenes/Stage-1.tscn")

	if (TIME - int(TIME) < 0.1):
		$CTA.visible = false
	else: 
		$CTA.visible = true
