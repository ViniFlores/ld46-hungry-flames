extends StaticBody2D

var POTIONS = 0

func _process(delta):
	pass

func addPotion(object):
	if (object.COLOR in ['red', 'blue', 'yellow']):
		if (POTIONS == 0):
			object.get_parent().remove_child(object)
			$Potion1.add_child(object)
			POTIONS = 1
		elif (POTIONS == 1):
			if ($Potion1.get_children()[0].COLOR == object.COLOR):
				object.get_parent().remove_child(object)
				$Potion2.add_child(object)
				POTIONS = 2
			else:
				var pot = $Potion1.get_children()[0]
				var new_color = Global.mixture(object.COLOR, pot.COLOR)
				object.queue_free()
				$Potion1.remove_child(pot)
				get_parent().add_child(pot)
				pot.scale = Vector2(1, 1)
				pot.COLOR = new_color.name
				pot.change_color(new_color.value)
				pot.global_position = $ResultPotion.global_position
				pot.set_collision_layer(2)
				pot.set_collision_layer(3)
				POTIONS = 0
		return true
	else:
		return false

func get_potion():
	print(POTIONS)
	if POTIONS == 1:
		POTIONS = 0
		return $Potion1.get_children()[0]
	elif POTIONS == 2:
		POTIONS = 1
		return $Potion2.get_children()[0]
