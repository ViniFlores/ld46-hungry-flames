extends Node

var INITIAL_FLAME = 800
var FUEL_COLLECTED = 0
var TIME = 0
var FLAME_HP = 800

var COLORS = {
	'blue': Color( 0.27, 0.51, 0.71, 1 ),
	'red': Color( 0.8, 0.36, 0.36, 1 ),
	'yellow': Color( 1, 0.84, 0, 1 ),
	'orange': Color( 1, 0.5, 0.31, 1 ),
	'green' : Color( 0.13, 0.55, 0.13, 1 ),
	'purple' : Color( 0.63, 0.13, 0.94, 1 )
}

func _process(delta):
	var aux = TIME
	TIME += delta
	rand_color()
	
	if (int(aux) != int(TIME)):
		refresh_hp()

func rand_color():
	randomize()
	var rand = randi() % 3
	match rand:
		0:
			return {'name': 'blue', 'value': COLORS.blue}
		1:
			return {'name': 'red', 'value': COLORS.red}
		2:
			return {'name': 'yellow', 'value': COLORS.yellow}

func rand_color_extended():
	randomize()
	var rand = randi() % 6
	match rand:
		0:
			return {'name': 'blue', 'value': COLORS.blue}
		1:
			return {'name': 'red', 'value': COLORS.red}
		2:
			return {'name': 'yellow', 'value': COLORS.yellow}
		3:
			return {'name': 'green', 'value': COLORS.green}
		4:
			return {'name': 'purple', 'value': COLORS.purple}
		5:
			return {'name': 'orange', 'value': COLORS.orange}
	

func mixture(color1, color2):
	if ('red' in [color1, color2] and 'blue' in [color1, color2]):
		return {'name': 'purple', 'value': COLORS.purple }
	if ('red' in [color1, color2] and 'yellow' in [color1, color2]):
		return {'name': 'orange', 'value': COLORS.orange }
	if ('blue' in [color1, color2] and 'yellow' in [color1, color2]):
		return {'name': 'green', 'value': COLORS.green }


func add_fuel():
	FUEL_COLLECTED += 100
	refresh_hp()

func remove_fuel(amount):
	FUEL_COLLECTED -= amount
	refresh_hp()

func refresh_hp():
	var new_FLAME_HP = int(INITIAL_FLAME + FUEL_COLLECTED - 20*int(TIME/3))
	if new_FLAME_HP > 0:
		FLAME_HP = new_FLAME_HP
