extends CharacterBody2D

enum PLAYERSTATE{IDLE,WALK,JUMP,ATTACK,HURT,DEAD}

@export var currentState = PLAYERSTATE.IDLE
@export var previousState =  PLAYERSTATE.IDLE
# Setup constants
const UP = Vector2(0,-1)
const GRAVITY = 50
const MAXSPEED = 50
const MAXGRAVITY = 100
const JUMPSPEED = 500
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement = Vector2()
var PlayerLife = 100
var is_hit = false
var is_attacking = false

var WeaponDamage = 10
var left
var right
var jump
var attack

@onready var AnimatedSprite: = $AnimatedSprite2D
@onready var hitbox: = get_node("Sword/hitbox")

func _physics_process(delta):

	HandleInput()
	executeState()
	
	if movement.y > MAXGRAVITY:
		movement.y = MAXGRAVITY

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
func executeState():
	match currentState:
		PLAYERSTATE.IDLE:
			AnimatedSprite.play("idle")
			pass
		PLAYERSTATE.WALK:
			var direction = Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if left:
				AnimatedSprite.play("walk")
				AnimatedSprite.set_flip_h(true)
			if right:
				AnimatedSprite.play("walk")
				AnimatedSprite.set_flip_h(false)
			pass
		PLAYERSTATE.JUMP:
			if(is_on_floor()):
				velocity.y=-JUMPSPEED
				AnimatedSprite.play("jump")
			pass
		PLAYERSTATE.ATTACK:
			pass
		PLAYERSTATE.HURT:
			AnimatedSprite.play("hit")
			movement.x=-50
			movement.y=50
			pass
		PLAYERSTATE.DEAD:
			pass
	changeState()
func changeState():
	previousState = currentState
	match currentState:
		PLAYERSTATE.IDLE:
			if(left || right):
				currentState = PLAYERSTATE.WALK
			if attack:
				currentState = PLAYERSTATE.ATTACK
			if jump:
				currentState = PLAYERSTATE.JUMP
			pass
		PLAYERSTATE.WALK:
			if !(left && right):
				currentState = PLAYERSTATE.IDLE
			if attack:
				currentState = PLAYERSTATE.ATTACK
			pass
		PLAYERSTATE.JUMP:
			if(is_on_floor()):
				currentState = PLAYERSTATE.IDLE
			pass
		PLAYERSTATE.ATTACK:
			pass
		PLAYERSTATE.HURT:
			pass
		PLAYERSTATE.DEAD:
			pass
			
func HandleInput():
	left = Input.is_action_pressed("left")
	right = Input.is_action_pressed("right")
	jump = Input.is_action_pressed("jump")
	attack = Input.is_action_pressed("attack")
	
func Attack():
	if !is_attacking && AnimatedSprite.animation != ("attack"):
		AnimatedSprite.play("attack")
		hitbox.disabled = false
		is_attacking = true

func TakeDamage(damage):
	if !is_hit:
		PlayerLife-=damage
		is_hit = true
		AnimatedSprite.play("hit")
	if(PlayerLife<=0):
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	if is_hit && AnimatedSprite.animation == "hit":
		is_hit = false
		AnimatedSprite.play("idle")
	if AnimatedSprite.animation == "attack":
		hitbox.disabled = false
		AnimatedSprite.play("idle")
		is_attacking = false
		
func _on_area_2d_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(WeaponDamage)
