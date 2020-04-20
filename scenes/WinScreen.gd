extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String, FILE, "*.tscn,*.scn") var next_stage


func _on_Button_pressed():
	get_tree().change_scene(next_stage)
