extends CharacterBody2D

var dir:float = 0
const SPD_ATTACK = 100.0
const SPD_PATROL = 50
const R_PATROL = 60
const JUMP_VELOCITY = -400.0
const DAMAGE:int = 4
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var info_speed = Vector2.ZERO

enum ST {PATROL, ATTACK}
var state = ST.PATROL
var home:Vector2 = Vector2(0,0)
var minitime = 0
var targBody:CharacterBody2D = null
var targLoc:Vector2 = Vector2.ZERO
var targPrev:Vector2 = Vector2.ZERO
var shape2d = CircleShape2D.new()
@onready var hpbar = $hpbar

func _ready():
    home = position
    hpbar.init(10)
    hpbar.change_hp(-1)
    #velocity.x = SPD_PATROL*dir
    #update_direction()

    # set initial target
    targLoc = home+Vector2(R_PATROL,0)
    dir = sign((targLoc-position).x)
    #print('initial dir:',dir)
    state = ST.PATROL
    shape2d.radius = 200
    var alertradius:CollisionShape2D = null

func update_direction(newdir):
    if(newdir == dir): return
    dir = newdir
    scale.x *=-1
    hpbar.scale.x *=-1

func process_patrol(delta):

    if((targLoc-position).x*dir<0):
        targLoc = (home)+Vector2(R_PATROL*dir*-1,0)
        update_direction(sign((targLoc-position).x))

    velocity.y = 15*sin(minitime*PI*2)+(targLoc-position).y
    velocity.x = dir*SPD_PATROL


func process_attack(delta):
    targLoc = targBody.position
    var newval = -1
    if((targLoc-position).x>0): newval = 1
    else: newval = -1
    update_direction(newval)
    if(minitime<0.5): return # mini "alert!" pause
    var err = targLoc - position

    velocity = SPD_ATTACK * (err.normalized())
    #velocity = min(100,err.length()) * (err.normalized())
    #print(velocity.length())



func _physics_process(delta):
    minitime+=delta
    if(state == ST.PATROL): process_patrol(delta)
    elif(state == ST.ATTACK): process_attack(delta)


    #if(state == ST.PATROL): process_patrol()
    #else: process_attack()
    info_speed = velocity

    #if(Input.is_action_just_pressed('btn_tilde')):
        ##print('dir:',dir,'scale:',scale.x,'vel',sign(velocity.x))
        #print('random update:')
        #update_direction(sign((targLoc-position).x))
        ##update_direction()

    move_and_slide()

func _on_area_2d_body_entered(body):
    if(body.name != 'player'): return # only activate on player
    state = ST.ATTACK
    ## initialize "attack" state
    targBody = body # will update targLoc in process_attack
    targPrev = targLoc*1
    #print('state:',str(state))
    minitime = 0
    velocity.x = 0
    velocity.y = 0
    $Area2D/alert_radius.shape.radius = 300
    #print()
    #print(get_node("res://scenes/buzzer.tscn::CircleShape2D_j2k47"))

func _on_area_2d_body_exited(body):
    if(body.name != 'player'): return # only activate on player
    #print('out:',body)
    #print('state',state)
    state = ST.PATROL
    targBody = null
    targLoc = targPrev
    $Area2D/alert_radius.shape.radius = 180

    #print('state',state)

func change_hp(amount):
    var abc = 123
    abc +=1
    $hpbar.change_hp(amount)
    if(hpbar.hp<=0):
        queue_free()
