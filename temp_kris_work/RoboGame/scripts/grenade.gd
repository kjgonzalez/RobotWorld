extends RigidBody2D
signal grenade_exploding()
# Called when the node enters the scene tree for the first time.
func _ready():
    # "autostart" is set in timer inspector
    $sound_launch.play()

func _on_explode_time_timeout():
    grenade_exploding.emit()
    $sound_explode.play()

func _on_sound_explode_finished():
    $".".queue_free() # auto-self-delete when timer's up
