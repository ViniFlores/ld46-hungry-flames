extends KinematicBody2D

var SPEED = Vector2(0, 0)
var DIRECTION = 'down'
var STATE = 'idle'
var holding = false
var object_in_hand
var VELOCITY
var VELOCITY_HOLDING = 150
var VELOCITY_FREE = 400

func _physics_process(delta):
	SPEED = Vector2(0, 0)
	if Input.is_action_pressed("ui_down"):
		SPEED.y += 1
	if Input.is_action_pressed("ui_up"):
		SPEED.y -= 1
	if Input.is_action_pressed("ui_right"):
		SPEED.x += 1
	if Input.is_action_pressed("ui_left"):
		SPEED.x -= 1
	
	if (SPEED != Vector2(0,0)):
		STATE = 'walk'
	else:
		STATE = 'idle'
	
	if (SPEED.x > 0):
		DIRECTION = 'right'
	elif (SPEED.x < 0):
		DIRECTION = 'left'
	elif (SPEED.y > 0):
		DIRECTION = 'down'
	elif (SPEED.y < 0):
		DIRECTION = 'up'
	
	change_anim()
	if (holding):
		VELOCITY = VELOCITY_HOLDING
	else:
		VELOCITY = VELOCITY_FREE
	move_and_collide(SPEED.normalized() * VELOCITY * delta)
	
	if (Input.is_action_just_pressed("pickup")):
		if (!holding):
			var bodies = $PickupArea.get_overlapping_bodies()
			if (bodies.size() > 0):
				var closest_body = null
				for body in bodies:
					if (closest_body == null or (position.distance_to(body.position) < position.distance_to(closest_body.position))):
						closest_body = body
				if(bodies[0].get_class() == 'KinematicBody2D'):
					call_deferred("pickup", bodies[0])
				
			var overlapping_areas = $PickupArea.get_overlapping_areas()
			if (!holding and overlapping_areas.size() > 0 and 'Mixing' in overlapping_areas[0].get_parent().get_name() && overlapping_areas[0].get_parent().POTIONS > 0):	
				var potion = overlapping_areas[0].get_parent().get_potion()
				call_deferred("pickup", potion)
		else:
			call_deferred("drop", object_in_hand)
	
	# Attack
	if (Input.is_action_pressed("attack")):
		attack()
	
	pass

func change_anim():
	if (DIRECTION == 'left'):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	$Anim.play(DIRECTION + "_" + STATE)

func attack():
	if (holding and 'Sword' in object_in_hand.get_name()):
		object_in_hand.set_collision_mask(8)
		$AnimSlash.play(DIRECTION + "_slash")

func pickup(object):
	if ('Sword' in object.get_name()):
		$pickupsound.play()
		object.get_parent().remove_child(object)
		$SwordPosition.add_child(object)
		object.position = Vector2(0, 0)
		object.scale = Vector2(0.5, 0.5)
		object.rotation = 0
		object.set_collision_layer(0)
		object.set_collision_mask(0)
		holding = true
		object_in_hand = object
	elif ('Fuel' in object.get_name()):
		$pickupsound.play()
		object.holding()
		object.get_parent().remove_child(object)
		$ItemPosition.add_child(object)
		object.position = Vector2(0, 0)
		object.scale = Vector2(0.5, 0.5)
		object.set_collision_layer(0)
		object.set_collision_mask(0)
		holding = true
		object_in_hand = object

func drop(object):
	if ('Sword' in object.get_name()):
		$dropsound.play()
		$SwordPosition.remove_child(object)
		get_parent().add_child(object)
		object.rotation = randi()%360
		object.position = $SwordPosition.global_position
		object.scale = Vector2(1, 1)
		object.set_collision_layer(16)
		object.set_collision_mask(0)
		holding = false
		object_in_hand = null
	
	elif ('Fuel' in object.get_name()):
		var overlapping_areas = $PickupArea.get_overlapping_areas()
		var dropped = false
		if (overlapping_areas.size() > 0 and 'Mixing' in overlapping_areas[0].get_parent().get_name() && overlapping_areas[0].get_parent().POTIONS < 2):	
			var mixing_table = overlapping_areas[0].get_parent()
			dropped = mixing_table.addPotion(object)
		if (!dropped):
			$ItemPosition.remove_child(object)
			$dropsound.play()
			object.drop()
			get_parent().add_child(object)
			object.position = $ItemPosition.global_position
			object.scale = Vector2(1, 1)
			object.set_collision_layer(2)
			object.set_collision_mask(3)
		holding = false
		object_in_hand = null


func _on_AnimSlash_animation_finished(anim_name):
	if holding:
		object_in_hand.set_collision_mask(0)
