extends CharacterBody2D

@onready var camera = $Camera2D
@onready var lanternLight = $Lantern/PointLight
@onready var sprite = $Sprite
@onready var animator = $AnimationPlayer
@onready var weaponNode = $WeaponPoint
@onready var weaponSprite = $WeaponPoint/Weapon

@export var moveSpeed = 300.0

enum State {
	idle,
	attack,
	walk,
	hit
}

var currentState = State.idle

var weaponNodeOrigin = Vector2(-3.36, 1.3)
var weaponNodeFlipped = Vector2(3.38, 1.3)
var attackTimer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	match currentState:
		State.idle:
			if animator.current_animation != "idle":
				animator.play("idle")
		State.attack:
			if animator.current_animation != "attack":
				attackTimer = 0.0
				animator.play("attack")
		State.walk:
			velocity = Input.get_vector("left", "right", "up", "down") * moveSpeed
			move_and_slide()
			
			if animator.current_animation != "walk":
				animator.play("walk")
		State.hit:
			pass
	
	var mousePos = get_global_mouse_position()
	if mousePos.x >= position.x:
		sprite.flip_h = false
		weaponNode.position = weaponNodeOrigin
	else:
		sprite.flip_h = true
		weaponNode.position = weaponNodeFlipped
	
	if Input.is_action_just_pressed("attack"):
		currentState = State.attack

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()
	
	if currentState == State.attack:
		attackTimer += delta
		if attackTimer >= 0.6:
			currentState = State.idle
	
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO and currentState != State.attack:
		currentState = State.walk
		
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)
		if currentState != State.attack:
			currentState = State.idle
