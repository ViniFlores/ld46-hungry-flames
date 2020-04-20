extends Node2D

var FUEL = preload("res://scenes/Fuel.tscn")
var GHOST = preload("res://scenes/Ghost.tscn")
var cooldown_fuel = 0.7
var cooldown_ghost = 15
var count = 0
var TIME = 0
var TIME_LEFT = 210
var END = false

func _process(delta):
	if !END:
		TIME += delta
		$Control/TimeLeft.text = 'Time: ' + str(TIME_LEFT - int(TIME))
	
	if (TIME_LEFT - TIME < 1):
		END = true
		remove_all_fuels()
		$CanvasModulate.visible = false
		$Torch.visible = false
		$WinScreen.visible = true
		$"Mixing Table".visible = false
	if ($Torch.FLAME_HP == 1):
		$LoseScreen.visible = true
		$Torch.visible = false
		$CanvasModulate.visible = false
		$"Mixing Table".visible = false
		END = true
		remove_all_fuels()
		
	cooldown_fuel -= delta
	cooldown_ghost -= delta
	if (!END and cooldown_fuel < 0):
		create_fuel()
	if (!END and cooldown_ghost < 0):
		create_ghost()
	if (!END and Input.is_action_just_pressed("pickup")):
		$Camera2D.shake(0.1, 500, 3)

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
		cooldown_fuel = 0.7

func create_ghost():
	$Path2D/PathFollow2D.offset = randi()
	var ghost = GHOST.instance()
	ghost.position = $Path2D/PathFollow2D.position
	add_child(ghost)
	cooldown_ghost = randi()%14 + 4

func remove_all_fuels():
	for child in get_children():
		if 'Fuel' in child.get_name():
			child.queue_free()
