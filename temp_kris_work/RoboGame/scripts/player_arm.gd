extends Sprite2D

func _process(_delta):
    look_at(get_global_mouse_position()) # player arm rotates
