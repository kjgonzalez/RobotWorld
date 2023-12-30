extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var dir = 1
const HPMAX:float=4
var hp:float=HPMAX+0
const DAMAGE:float = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ray_eow:RayCast2D = $ray_endofworld
@onready var hpbar = $hpbar
func _ready():
    velocity.x = SPEED*dir
    hpbar.init(4)

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor(): velocity.y += gravity * delta # obey gravity
    #if(Input.is_action_just_pressed('btn_tilde')):
        #scale.x *= -1
    if(is_on_floor() and (not ray_eow.is_colliding() or is_on_wall())):
        dir *=-1
        scale.x *=-1
        $hpbar.scale.x *=-1
    velocity.x = SPEED*dir

    move_and_slide()

func change_hp(amount):
    $hpbar.change_hp(amount)
    if(hpbar.hp<=0):
        queue_free()
