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
@onready var hpBar = $HPBar
@onready var soundFXPlayer = $SoundFX
@onready var optionsMenu = $"../../../OptionsMenu"
@onready var minimap = $"../../Minimap"
@onready var devMenu = $"../../DevMenuUI"

@export var moveSpeed = 300.0

enum State {
	idle,
	attack,
	walk,
	hit,
	paused,
	unpaused
}

var currentState = State.idle

var fxPlayed = false
var flipLeft = false
var stunned = false
var stunnedCD : float
var stunTimer : float

var attackTimer = 0.0
var mousePos = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	attackBox.disabled = true
	hpBar.max_value = hp.maxHP
	hpBar.min_value = 0
	stunnedCD = 0.1

func _process(delta):
	if stunned:
		stunTimer += delta
		if stunTimer >= stunnedCD:
			stunned = false
			stunTimer = 0.0
	if hp.curHP == hp.maxHP:
		hpBar.visible = false
	else: hpBar.visible = true
	hpBar.value = hp.curHP
	match currentState:
		State.idle:
			if (animator.current_animation != "idleLeft" or animator.current_animation != "idle") and !flipLeft:
				animator.play("idle")
			if (animator.current_animation != "idleLeft" or animator.current_animation != "idle") and flipLeft:
				animator.play("idleLeft")
		State.attack:
			if !stunned:
				if (animator.current_animation != "attack" or animator.current_animation != "attackLeft") and !flipLeft:
					animator.play("attack")
				if (animator.current_animation != "attack" or animator.current_animation != "attackLeft") and flipLeft:
					animator.play("attackLeft")
		State.walk:
			if !stunned:
				velocity = Input.get_vector("left", "right", "up", "down") * moveSpeed
				move_and_slide()
			else: pass
			
			if (animator.current_animation != "walk" or animator.current_animation != "walkLeft") and !flipLeft:
				animator.play("walk")
			if (animator.current_animation != "walk" or animator.current_animation != "walkLeft") and flipLeft:
				animator.play("walkLeft")
		State.hit:
			pass
		State.paused:
			get_tree().paused = true
			self.visible = false
			minimap.visible = false
			devMenu.visible = false
			optionsMenu.visible = true
		State.unpaused:
			optionsMenu.visible = false
			self.visible = true
			minimap.visible = true
			devMenu.visible = true
			currentState = State.idle
	
	mousePos = get_global_mouse_position()
	if mousePos.x >= position.x:
		flipLeft = false
	else:
		flipLeft = true
	
	if Input.is_action_pressed("attack"):
		currentState = State.attack
	if Input.is_action_pressed("pause"):
		currentState = State.paused

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()
	
	if currentState == State.attack:
		attackTimer += delta
		if attackTimer >= 0.36 and !fxPlayed and !stunned:
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

func Unpause():
	currentState = State.unpaused


func _on_hurt_button_pressed():
	hp.takeDamage(3)
