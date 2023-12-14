extends CharacterBody2D
class_name Entity

@onready var spriteNode = $Sprite

@onready var hp = $HPComponent
@onready var hpBar = $ProgressBar
@onready var dropParent = $"../../../../PlayerCanvas/DropParent"
@onready var player = $"../../../../PlayerCanvas/Player"
@onready var monsterManager: MonsterManager = $"../../../../../../MonsterManager"
@onready var attackRange = $AttackRadius/AttackShape
@onready var projectileParent = $"../../ProjectileParent"
@onready var range_attack_spawn_pos = $RangeAttackSpawnPos
@onready var entityAnimator : AnimationPlayer = $EntityAnimator
@onready var glow : PointLight2D = $Glow

@export var itemDrops : Array[PackedScene]
@export var moveSpeed : float
@export var hpBarOffset : Vector2
@export var attackCD : float
@export var attackDamage : int
@export var rangedMob = false
@export var projectileSpeed : float
@export var projectile : PackedScene
@export var glowStrength : float
@export var spawnRarity : float
@export var enemy = false

var currentState : State = State.idle
var foundPlayer = false
var chasingPlayer = false
var attackingPlayer = false
var attackTime : float
var maxAliveRange = 225.0

enum State {
	idle,
	chasing,
	attacking
}

func _ready():
	currentState = State.idle
	hp.DropItem.connect(DropWhenDead)
	hpBar.max_value = hp.maxHP
	hpBar.min_value = 0
	attackTime = attackCD

func _physics_process(delta):
	if enemy == true:
		if attackTime < attackCD:
			attackTime += delta
		hpBar.global_position = self.global_position + hpBarOffset
		if currentState == State.idle:
			glow.energy = 0
			entityAnimator.current_animation = "idle"
			if abs((player.global_position - self.global_position)) > Vector2(maxAliveRange,maxAliveRange):
				monsterManager.curMobsAlive -= 1
				queue_free()
		
		if currentState == State.chasing:
			entityAnimator.current_animation = "walking"
			glow.energy = glowStrength
			Chase()
			
		if currentState == State.attacking:
			entityAnimator.current_animation = "attacking"
			glow.energy = glowStrength
			Attack()
	else:
		glow.energy = 0
	
	hpBar.value = hp.curHP
	if hp.curHP < hp.maxHP:
		hpBar.visible = true
	else: hpBar.visible = false

func Chase():
	if enemy == true:
		if player != null:
			var direction = player.global_position - self.global_position
			velocity = direction.normalized() * moveSpeed
			move_and_slide()


func DropWhenDead():
	for i in range(0, itemDrops.size()):
		var item = itemDrops[i].instantiate()
		call_deferred("AddToRoot", item)
		item.global_position = self.global_position

func AddToRoot(itemDropped : Node):
	if itemDropped:
		dropParent.add_child(itemDropped)


func _on_search_area_entered(area):
	if enemy == true:
		if area.get_parent().name == "Player":
			foundPlayer = true
			chasingPlayer = true
			GlobalVariables.monstersAggrod += 1
			currentState = State.chasing

func _on_search_area_exited(area):
	if enemy == true:
		if area.get_parent().name == "Player":
			foundPlayer = false
			chasingPlayer = false
			GlobalVariables.monstersAggrod -= 1
			currentState = State.idle

func _on_attack_area_entered(area):
	if enemy == true:
		if area.get_parent().name == "Player":
			attackingPlayer = true
			chasingPlayer = false
			currentState = State.attacking


func _on_attack_area_exited(area):
	if enemy == true:
		if area.get_parent().name == "Player":
			attackingPlayer = false
			chasingPlayer = true
			currentState = State.chasing

func Attack():
	if !rangedMob:
		if attackTime >= attackCD:
			player.hp.takeDamage(attackDamage)
			attackTime = 0.0
	else:
		if attackTime >= attackCD:
			if projectile:
				var shot : Projectile = projectile.instantiate()
				projectileParent.add_child(shot)
				shot.target = player
				shot.speed = projectileSpeed
				shot.damage = attackDamage
				shot.hasTarget = true
				shot.global_position = range_attack_spawn_pos.global_position
				attackTime = 0.0
