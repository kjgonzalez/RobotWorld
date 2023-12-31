extends Node

class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockbback_direction : Vector2)

# look up getter and setter in the following, bit confused?
@export var health : float = 20 : 
	get:
		return health
	set(value):
		#changedHealth = value - health
		SignalBus.emit_signal("on_health_changed", get_parent(),value-health)
		health = value
@export var dead_animation_name : String = "dead"

func hit(damage : int, knockback_direction: Vector2):
	health -= damage
	emit_signal("on_hit", get_parent(), damage, knockback_direction)



func _on_animation_tree_animation_finished(anim_name):
	if(anim_name == dead_animation_name):
		#remove char after dying
		get_parent().queue_free()
