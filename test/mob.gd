extends RigidBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
