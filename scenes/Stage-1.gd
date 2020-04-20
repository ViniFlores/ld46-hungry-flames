extends Node2D

var FUEL = preload("res://scenes/Fuel.tscn")
var cooldown_fuel = 1.5
var count = 0
var TIME_LEFT = 70
var TIME = 0
var END = false


func _process(delta):
	if (!END):
		TIME += delta
		$Control/Time.text = 'Time: ' + str(TIME_LEFT - int(TIME))
	if (TIME_LEFT - int(TIME) < 1):
		$WinScreen.visible = true
		$Torch.visible = false
		$CanvasModulate.visible = false
		END = true
		remove_all_fuels()
	cooldown_fuel -= delta
	if (cooldown_fuel < 0 && !END):
		create_fuel()
	if (Input.is_action_just_pressed("pickup") && !END):
		$Camera2D.shake(0.1, 500, 2)
	if ($Torch.FLAME_HP == 1):
		$LoseScreen.visible = true
		$Torch.visible = false
		$CanvasModulate.visible = false
		END = true
		remove_all_fuels()
		

func create_fuel():
	randomize()
	var position = Vector2(randi()%856 + 64, randi()%440 + 130)
	if (position.x < 600 && position.x > 400 ) && (position.y > 220 && position.y < 400):
		create_fuel()
	else:
		var new_fuel = FUEL.instance()
		new_fuel.set_name('Fuel-' + str(count))
		count += 1
		new_fuel.position = position
		add_child(new_fuel)
		cooldown_fuel = 1.5

func remove_all_fuels():
	for child in get_children():
		if 'Fuel' in child.get_name():
			child.queue_free()
