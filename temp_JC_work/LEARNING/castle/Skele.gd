extends CharacterBody2D
# Setup constants
const UP = Vector2(0,-1)
const GRAVITY = 25
const MAXSPEED = 50
const MAXGRAVITY = 50
const JUMPSPEED = 500
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WeaponDamage = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement = Vector2()
var moving_right = true
var player_in_range = false
var is_attacking = false
var EnemyLife = 50
var is_hit = false

@onready var AnimatedSprite: = $AnimatedSprite2D
@onready var hitbox: = get_node("Area2D/hitbox")

func _physics_process(delta):
	if(!$DownRay.is_colliding() || $RightRay.is_colliding()):
		var collider = $RightRay.get_collider()
		if collider && collider.name == "Player":
			movement = Vector2.ZERO
			player_in_range = true
		else:
			#This causes skeleton to just stay stuck and flip direction
			moving_right =  !moving_right
			scale.x = -scale.x
	attack()
	animate()
	move_enemy()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func attack():
	if is_hit:
		return
	if player_in_range && AnimatedSprite.animation != ("attack"):
		AnimatedSprite.play("attack")
		is_attacking = true
	elif player_in_range && AnimatedSprite.animation != ("attack"):
		is_attacking = false
func animate():
	if is_attacking:
		return
	if movement!=Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

func move_enemy():
	movement.y= movement.y + GRAVITY
	if(movement.y > MAXGRAVITY):
		movement.y = MAXGRAVITY
		
	if(is_on_floor()):
		movement.y = 0
	if !player_in_range:
		movement.x = MAXSPEED if moving_right else -MAXSPEED
	velocity.x = movement.x
	#movement = move_and_slide()

func TakeDamage(damage):
	if !is_hit:
		EnemyLife-=damage
		is_hit = true
		$AnimatedSprite2D.play("hit")
	if(EnemyLife<=0):
		queue_free()

func _on_animated_sprite_2d_frame_changed():
	if AnimatedSprite.animation == "attack" && AnimatedSprite.frame >=7 && AnimatedSprite.frame <=8	:
		hitbox.disabled = false
		print("hitbox activated")
	else:
		hitbox.disabled = true
		print("hitbox disactivated")

func _on_area_2d_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(WeaponDamage)


func _on_animated_sprite_2d_animation_finished():
	if is_hit && $AnimatedSprite2D.animation == "hit":
		is_hit = false
		print("enemy hit")
		$AnimatedSprite2D.play("idle")
