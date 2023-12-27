'''
will use this script (effectively "main") as primary place to post to-do's:

stat-descrip:
done proper platform movement (slopes)
???? x2 jump
???? wall slide
???? edge hang
???? power up: grappling hook
???? drop thru platform
???? death if fall
???? death if hp 0
???? walking enemy
???? flying enemy
???? win condition with level reset
'''


extends Node2D

var scn_grenade:PackedScene = preload("res://scenes/grenade.tscn")
var scn_bullet:PackedScene = preload("res://scenes/laser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if(Input.is_action_just_pressed("btn_tilde")):
        #var quotes:Array = FileAccess.open(
            #"res://assets/quotes_whenhit.txt", FileAccess.READ).get_as_text().split('\n')
        #print(quotes[randi_range(0,len(quotes)-1)])
        var thing = JSON.parse_string(FileAccess.open(
            "res://assets/quotes2.json",FileAccess.READ).get_as_text()
        )
        print(thing['a'])

func _on_player_p_1_grenade_activated(pos):
    var grenade = scn_grenade.instantiate() as RigidBody2D
    grenade.position = pos
    grenade.linear_velocity = Vector2(100,100)
    grenade.angular_velocity = 4
    $projectiles.add_child(grenade)

func _on_player_p_1_shoot_activated(pos, dir):
    var bullet = scn_bullet.instantiate() as Area2D
    bullet.position = pos+dir*50
    bullet.DIRECTION = dir
    bullet.scale = Vector2(0.2,0.2)
    #Vector2().angle()
    bullet.rotation = dir.angle()
    bullet.connect('sig_targ_hit',_on_laser_sig_targ_hit)
    #bullet.linear_velocity = dir*bullet.SPEED
    $projectiles.add_child(bullet)


func _on_laser_sig_targ_hit(body,laserid):
    print(body)
    if('CharacterBody2D' in str(body)):
        body.change_hp(-1)
    laserid.queue_free()


func _on_upgrade_hook_body_entered(body):
    if('player' in body.name):
        print("player")
