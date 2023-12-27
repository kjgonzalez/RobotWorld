extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    #print(position.global_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if(is_colliding()):

        print(get_collider().position)
        print('colliding, ',get_collision_normal())

