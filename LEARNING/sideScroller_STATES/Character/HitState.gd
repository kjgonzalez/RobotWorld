extends State

#make it a class to use in other scenes
class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var dead_animation_node : String = "dead"
@export var knockback_speed : float = 300.0
@export var return_state : State

@onready var timer : Timer = $Timer
func _ready():
	damageable.connect("on_hit", on_damageable_hit)
func on_enter():
	timer.start()

func on_exit():
	character.velocity = Vector2.ZERO
	
func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		character.velocity = knockback_speed * knockback_direction
		#switch to hit state again
		emit_signal("interrupt_state", self)
		#add hitback
	else:
		#switch to dead state
		emit_signal("interrupt_state", dead_state)
		playback.travel(dead_animation_node)

func _on_timer_timeout():
	next_state = return_state
