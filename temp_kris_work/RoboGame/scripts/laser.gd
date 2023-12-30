extends Area2D
signal sig_targ_hit(body,laserid)

const SPEED = 1000 # px/s
# Called when the node enters the scene tree for the first time.
var DIRECTION = Vector2(1,0)
func _ready():
    $sound.play()

func _process(delta):
    pass # todo: process this to make sure moving in correct direction
    position += DIRECTION*SPEED*delta

func _on_time_alive_timeout():
    queue_free()

func _on_body_entered(body):
    if('player' in body.name): return
    sig_targ_hit.emit(body,self)
