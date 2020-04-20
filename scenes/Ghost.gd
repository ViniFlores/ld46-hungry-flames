extends KinematicBody2D

var torch_position = Vector2(512, 320)
var HIT = false
var dyingtime = 2


func _ready():
	if (position.x < 512):
		$Sprite.flip_h = true

func _physics_process(delta):
	if !HIT:
		var collision = move_and_collide(position.direction_to(torch_position)* 40 * delta)
		if collision:
			$AudioStreamPlayer.play()
			HIT = true
	else:
		dyingtime -= delta
		move_and_collide(-position.direction_to(torch_position)* 400 * delta)
		
		if (dyingtime < 0):
			queue_free()
