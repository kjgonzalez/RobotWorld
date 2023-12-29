extends State

# Declare variables as needed
@export var return_state : State
@export var return_animation_node : String = "move"
@export var attack1_name : String = "attack1"
@export var attack2_name : String = "attack2" #name is for action
@export var attack2_node : String = "attack2" #node is for animation
@onready var timer : Timer = $attackTimer

#Check to see if animation has finished

func state_input(event : InputEvent):
	if(event.is_action_pressed("attack")):
		timer.start()

func _on_animation_tree_animation_finished(anim_name):
	if (anim_name == attack1_name):
		if(timer.is_stopped()):
			next_state = return_state
			playback.travel(return_animation_node)
		else:
			playback.travel(attack2_node)
	if (anim_name == attack2_name):
		next_state = return_state
		playback.travel(return_animation_node)
