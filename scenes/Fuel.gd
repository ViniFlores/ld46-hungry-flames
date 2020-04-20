extends KinematicBody2D

var COLOR
var COLOR_VALUE
var FULL_LIFE = 10
var TIME_LEFT
var HOLD = false

func _ready():
	TIME_LEFT = FULL_LIFE
	randomize()
	var random_color = Global.rand_color()
	COLOR = random_color.name
	COLOR_VALUE = random_color.value
	$"Bottle Bottom".self_modulate = random_color.value

func _physics_process(delta):
	if !HOLD:
		TIME_LEFT -= delta
	if (TIME_LEFT < 4 && (int(TIME_LEFT)%2 == 1)):
		$"Bottle Bottom".self_modulate = Color(1, 1, 1)
	else:
		$"Bottle Bottom".self_modulate = COLOR_VALUE
	
	if TIME_LEFT < 0:
		queue_free()

func change_color(color):
	COLOR_VALUE = color
	$"Bottle Bottom".self_modulate = color

func holding():
	TIME_LEFT = FULL_LIFE
	HOLD = true

func drop():
	HOLD = false
