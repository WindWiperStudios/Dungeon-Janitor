extends CharacterBody2D
class_name Entity

@onready var spriteNode = $Sprite

@onready var hp = $HPComponent
@onready var hpBar = $ProgressBar
@onready var dropParent = $"../../../../PlayerCanvas/DropParent"
@onready var player = $"../../../../PlayerCanvas/Player"
@onready var musicPlayer = $"../../../../../MusicPlayer"
@onready var monsterManager: MonsterManager = $"../../../../../../MonsterManager"

@export var itemDrops : Array[PackedScene]
@export var moveSpeed : float
@export var attackRange : Vector2
@export var hpBarOffset : Vector2
@export var attackCD : float
@export var attackDamage : int

var currentState : State = State.idle
var foundPlayer = false
var chasingPlayer = false
var attackingPlayer = false
var attackTime : float

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
	attackTime += delta
	hpBar.global_position = self.global_position + hpBarOffset
	if currentState == State.idle:
		pass
	
	if currentState == State.chasing:
		Chase()
		
	if currentState == State.attacking:
		if attackTime >= attackCD:
			print("AttackingPlayer")
			player.hp.takeDamage(attackDamage)
			attackTime = 0.0
	
	hpBar.value = hp.curHP
	if hp.curHP < hp.maxHP:
		hpBar.visible = true
	else: hpBar.visible = false

func Chase():
	if player != null:
		var direction = player.global_position - self.global_position
		velocity = direction.normalized() * moveSpeed
		move_and_slide()


func DropWhenDead():
	if monsterManager:
		monsterManager.curMobsAlive -= 1
	var root = get_tree().get_root()
	for i in range(0, itemDrops.size()):
		var item = itemDrops[i].instantiate()
		call_deferred("AddToRoot", item)
		item.global_position = self.global_position

func AddToRoot(itemDropped : Node):
	if itemDropped:
		dropParent.add_child(itemDropped)


func _on_search_area_entered(area):
	foundPlayer = true
	chasingPlayer = true
	musicPlayer.midState()
	currentState = State.chasing

func _on_search_area_exited(area):
	foundPlayer = false
	chasingPlayer = false
	musicPlayer.lowState()
	currentState = State.idle

func _on_attack_area_entered(area):
	attackingPlayer = true
	chasingPlayer = false
	musicPlayer.highState()
	currentState = State.attacking


func _on_attack_area_exited(area):
	attackingPlayer = false
	chasingPlayer = true
	musicPlayer.midState()
	currentState = State.chasing

