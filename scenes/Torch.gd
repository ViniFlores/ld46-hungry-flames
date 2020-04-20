extends StaticBody2D

var COLOR
var FLAME_HP = 600
var INITIAL_FLAME = 600
var FUEL_COLLECTED = 0
var TIME = 0
export var HARD = false

func _ready():	
	reset_color()

func _process(delta):
	TIME += delta
	
	refresh_hp()
	
	if (FLAME_HP != $Fire.amount):
		$Fire.amount = FLAME_HP
		$Light2D.scale = Vector2($Fire.amount* 0.001, $Fire.amount * 0.001)
	pass


func _on_Area2D_body_entered(body):
	if ("Fuel" in body.get_name()):
		body.queue_free()
		if (body.COLOR == COLOR):
			add_fuel()
			$addflameaudio.play()
			reset_color()
		else:
			$wrongaudio.play()
	
	if ("Ghost" in body.get_name()):
		body.queue_free()
		remove_fuel(100)

func reset_color():
	var random_color = null
	if (!HARD):
		random_color = Global.rand_color()
	else:
		random_color = Global.rand_color_extended()
	COLOR = random_color.name
	$Fire.self_modulate = random_color.value

func add_fuel():
	FUEL_COLLECTED += 100
	refresh_hp()

func remove_fuel(amount):
	FUEL_COLLECTED -= amount
	refresh_hp()

func refresh_hp():
	var new_FLAME_HP = int(INITIAL_FLAME + FUEL_COLLECTED - 30*int(TIME/3))
	if new_FLAME_HP < 1:
		new_FLAME_HP = 1
	FLAME_HP = new_FLAME_HP
