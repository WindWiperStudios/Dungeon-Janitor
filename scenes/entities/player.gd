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
@onready var aimDot = $AimDot
@onready var dash_sprite = $AttackEffect/DashSprite



@export var moveSpeed = 300.0

enum State {
	idle,
	attack,
	walk,
	hit,
}

var currentState = State.idle

var fxPlayed = false
var flipLeft = false
var stunned = false
var stunnedCD : float
var stunTimer : float
var pauseTimer : float = 0
var attackCD : float = 0.6
var dashTimer : float = 0
var dashCD : float = .7

var attackTimer = 0.0
var mousePos = Vector2.ZERO
var rightStickDir
var dirLastTraveled = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func UpdateGlobalVars():
	GlobalVariables.playerHP = hp.curHP
	GlobalVariables.playerMaxHP = hp.maxHP
	GlobalVariables.playerGlobalPosition = self.global_position
	GlobalVariables.playerCurrentState = currentState
	GlobalVariables.playerStunTimer = stunTimer
	GlobalVariables.playerStunned = stunned
	attackCD = GlobalVariables.playerAttackCD
	GlobalVariables.playerDashTimer = dashTimer
	GlobalVariables.playerDashCD = dashCD
	
func _ready():
	rightStickDir = Vector2(0, 0)
	GlobalVariables.paused.connect(Pause)
	GlobalVariables.unpaused.connect(Unpause)
	UpdateGlobalVars()
	attackBox.disabled = true
	hpBar.max_value = hp.maxHP
	hpBar.min_value = 0
	stunnedCD = 0.1

func _process(delta):
	if rightStickDir != Vector2(0, 0):
		aimDot.visible = true
		aimDot.position = (rightStickDir * 10) + Vector2(-2, -2)
	else: 
		aimDot.position = Vector2(-2, -2)
		aimDot.visible = false
	UpdateGlobalVars()
	if dashTimer < dashCD:
		dashTimer += delta
	if stunned:
		stunTimer += delta
		if stunTimer >= stunnedCD:
			stunned = false
			stunTimer = 0.0
	
	if Input.is_action_pressed("map"):
		minimap.visible = true
	
	if Input.is_action_pressed("map") == false:
		minimap.visible = false
	
	if Input.is_action_just_pressed("dash") and GlobalVariables.playerHasDash == true:
		Dash(delta)
	
	rightStickDir = Input.get_vector("contollerAimLeft", "contollerAimRight", "contollerAimUp", "contollerAimDown")
	
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
		if attackTimer >= (attackCD / 2) and !fxPlayed and !stunned:
			fxPlayed = true
			if rightStickDir != Vector2(0, 0):
				AimController(rightStickDir)
			else: Aim(mousePos)
			soundFXPlayer.volume_db = 0
			fxAnimator.play("slashFX")
		if attackTimer >= attackCD:
			fxPlayed = false
			attackTimer = 0.0
			currentState = State.idle
	
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO and currentState != State.attack:
		currentState = State.walk
		dirLastTraveled = Input.get_vector("left", "right", "up", "down")
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)
		if currentState != State.attack:
			currentState = State.idle

func Aim(mousePosAim : Vector2):
	var direction = (global_position - mousePosAim).normalized()
	var newAngle = PI + atan2(direction.y, direction.x)
	attackFXNode.rotation = newAngle
	
func AimController(rightStickAngle):
	if rightStickAngle:
		var direction = -rightStickAngle.normalized()
		var newAngle = PI + atan2(direction.y, direction.x)
		attackFXNode.rotation = newAngle
	

func Pause():
	self.visible = false
	minimap.visible = false
	get_tree().paused = true

func Unpause():
	get_tree().paused = false
	self.visible = true
	minimap.visible = true


func _on_hurt_button_pressed():
	hp.takeDamage(3)

func Dash(delta):
	if dirLastTraveled != Vector2.ZERO and currentState != State.attack and dashTimer >= dashCD:
		global_position += dirLastTraveled * 500 * delta
		var dashDirection = dirLastTraveled.normalized()
		var newAngle = PI + atan2(dashDirection.y, dashDirection.x)
		dash_sprite.rotation = newAngle
		fxAnimator.play("dash")
		soundFXPlayer.stream = soundFXPlayer.sounds[2]
		soundFXPlayer.volume_db = -20
		soundFXPlayer.play()
		dashTimer = 0.0
