extends CharacterBody2D

@onready var camera = $Camera2D
@onready var lanternLight = $Lantern/PointLight
@onready var sprite = $Sprite
@onready var animator = $AnimationPlayer
@onready var fxAnimator = $AttackEffect/FXAnimation
@onready var weaponNode = $WeaponPoint
@onready var weaponSprite = $WeaponPoint/Weapon
@onready var attackFXNode = $AttackEffect
@onready var hp = $HPComponent
@onready var attackBox = $AttackEffect/Attack/AttackBox

@export var moveSpeed = 300.0

enum State {
	idle,
	attack,
	walk,
	hit
}

var currentState = State.idle

var fxPlayed = false
var flipLeft = false

var attackTimer = 0.0
var mousePos = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	attackBox.disabled = true

func _process(_delta):
	match currentState:
		State.idle:
			if (animator.current_animation != "idleLeft" or animator.current_animation != "idle") and !flipLeft:
				animator.play("idle")
			if (animator.current_animation != "idleLeft" or animator.current_animation != "idle") and flipLeft:
				animator.play("idleLeft")
		State.attack:
			if (animator.current_animation != "attack" or animator.current_animation != "attackLeft") and !flipLeft:
				animator.play("attack")
			if (animator.current_animation != "attack" or animator.current_animation != "attackLeft") and flipLeft:
				animator.play("attackLeft")
		State.walk:
			velocity = Input.get_vector("left", "right", "up", "down") * moveSpeed
			move_and_slide()
			
			if (animator.current_animation != "walk" or animator.current_animation != "walkLeft") and !flipLeft:
				animator.play("walk")
			if (animator.current_animation != "walk" or animator.current_animation != "walkLeft") and flipLeft:
				animator.play("walkLeft")
		State.hit:
			pass
	
	mousePos = get_global_mouse_position()
	if mousePos.x >= position.x:
		flipLeft = false
	else:
		flipLeft = true
	
	if Input.is_action_pressed("attack"):
		currentState = State.attack

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()
	
	if currentState == State.attack:
		attackTimer += delta
		if attackTimer >= 0.36 and !fxPlayed:
			fxPlayed = true
			Aim(mousePos)
			fxAnimator.play("slashFX")
		if attackTimer >= 0.6:
			fxPlayed = false
			attackTimer = 0.0
			currentState = State.idle
	
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO and currentState != State.attack:
		currentState = State.walk
		
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)
		if currentState != State.attack:
			currentState = State.idle

func Aim(mousePosAim : Vector2):
	var direction = (global_position - mousePosAim).normalized()
	var newAngle = PI + atan2(direction.y, direction.x)
	attackFXNode.rotation = newAngle
