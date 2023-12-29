extends Label

@export var float_speed : Vector2 = Vector2(0,-60)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#move the text (goes up)
	position += float_speed*delta
	#dissapear after some time

#connect timer out to script itself
func _on_timer_timeout():
	queue_free()
