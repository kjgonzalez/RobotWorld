extends Area2D

@export var damage : int = 10

func _ready():
	#Ensure monitoring is always off
	monitoring = false
#connects to its own script? with the following line?
func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
			print_debug(body.name  + " took " + str(damage) + ".")
	
