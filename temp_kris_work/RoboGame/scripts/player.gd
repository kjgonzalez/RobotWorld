'''
various states to capture:
    on floor
    in air
    on wall
affected attributes:
    facing direction
    gravity
    number of available jumps
'''
extends CharacterBody2D
signal p1_grenade_activated(pos)
signal p1_shoot_activated(pos,dir)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dmax:float = 10000
var dL:float = dmax
var dR:float = dmax
var dist_to_floor:float = -1
var njumps_available=2
var facing = 1 # positive = right
@onready var hpbar = $hpbar

func _ready():
    hpbar.init(10)
    hpbar.change_hp(-1)
func _physics_process(delta):
    var inp_dir = Input.get_vector('btn_a','btn_d','btn_w','btn_s')
    var inp_jmp = Input.is_action_just_pressed("btn_w")
    var inp_atk = Input.is_action_just_pressed("btn_k")
    var inp_dbg = Input.is_action_just_pressed("btn_tilde")
    var inp_lclick = Input.is_action_just_pressed('click-left')
    var inp_rclick = Input.is_action_just_pressed('click-right')
    ## horiz velocity in all cases
    if (inp_dir.x!=0):
        velocity.x = move_toward(velocity.x,sign(inp_dir.x) *SPEED,100)
        facing = sign(inp_dir.x)
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    if(not is_on_floor() and is_on_wall() and inp_dir.x!=0 and velocity.y>0):
        velocity.y += gravity*delta*0.5
        #print('on wall')
        velocity.x +=0
    elif(is_on_floor()):
        pass
    else:
        velocity.y += gravity*delta

    if(is_on_floor() and velocity.y!=0):
        print(velocity.y)


    if(inp_jmp and njumps_available>0):
        if(is_on_floor()):
            njumps_available=1
        elif(is_on_wall_only()):
            njumps_available=1
            #velocity.x = -1*sign(inp_dir.x)*SPEED*10
        else:
            njumps_available=0
        velocity.y=JUMP_VELOCITY
    elif(is_on_floor()):
        njumps_available=2

    #if (Input.is_action_just_pressed("btn_j") and is_on_floor()): # initial jump
        #flag_jump2_available = true
        #velocity.y = JUMP_VELOCITY
    ## jump 2
    #elif(Input.is_action_just_pressed("btn_j") and flag_jump2_available):
        #flag_jump2_available=false
        #velocity.y = JUMP_VELOCITY

    if(inp_atk):
        print('attack')
    if(inp_lclick):
        var pos_shoot =position
        var direc = (get_global_mouse_position()-position).normalized()
        p1_shoot_activated.emit(pos_shoot,direc)

    if(inp_rclick):
        var pos_grenade = position+Vector2(50,0)
        p1_grenade_activated.emit(pos_grenade)



    move_and_slide()

