extends Node
class_name MonsterManager

class Enemy:
	var scene_path : String
	var spawn_chance : float
	
	func _init(scene_path: String, spawn_chance : float):
		self.scene_path = scene_path
		self.spawn_chance = spawn_chance



@onready var player = $"../ScreenCanvas/ScreenMargin/PlayerCanvas/Player"
@onready var enemySpawnsParent = $"../ScreenCanvas/ScreenMargin/EnemyCanvas/EnemyParent"

@export var monsterChances : Array[float]
@export var maxMobsAlive : int
@export var curMobsAlive : int
@export var spawnCD : float
@export var curSpawnTimer : float

var distToSpawn : float = 25
var currentState : State = State.waiting_to_spawn
var monsterRNG
var monsters : Array[PackedScene]
var monsterAPath
var monsterBPath

enum State {
	waiting_to_spawn,
	spawning,
	reseting,
	waiting
}

func _ready():
	monsterAPath = "res://scenes/entities/skeleton.tscn"
	monsterBPath = "res://scenes/entities/spider.tscn"

func _process(delta):
	maxMobsAlive = 12 + (GlobalVariables.gameTimer / 5)
	clampi(maxMobsAlive, 12, 40)
	match currentState:
		State.waiting_to_spawn:
			ProcessSpawnTimer(delta)
			#List of checks before spawning monsters
			if curSpawnTimer >= spawnCD:
				currentState = State.spawning
				
		State.spawning:
			SpawnEnemy()
			currentState = State.reseting
			#Find Spawn Location
#			var spawnLocationCount = enemySpawnsParent.get_child_count()
#
#
#
#			monsterRNG = RandomNumberGenerator.new()
#			var rng = RandomNumberGenerator.new()
#
#			var spawnLocation = enemySpawnsParent.get_child(rng.randi_range(0, spawnLocationCount-2))
#			var distToPlayer = player.global_position - spawnLocation.global_position
#			if abs(distToPlayer.x) >= distToSpawn and abs(distToPlayer.y) >= distToSpawn:
#				#Then instantiate mob & add as child
#				var spawnChance = monsterRNG.randf_range(0, 1)
#				var monster
#				var cumulative = 0.0
#				for spawn in range(monsters.size()):
#					cumulative += monsterChances[spawn-1]
#					if spawnChance <= cumulative:
#						monster = monsters[spawn].instantiate()
#						spawnLocation.add_child(monster)
#						monster.global_position = spawnLocation.global_position
#						curMobsAlive += 1
#					currentState = State.reseting
				
			
		State.reseting:
			#Set state back to default
			curSpawnTimer = 0.0
			currentState = State.waiting
			
		State.waiting:
			if curMobsAlive > maxMobsAlive:
				return
			else: currentState = State.waiting_to_spawn
			

func ProcessSpawnTimer(delta : float) -> void:
	if curSpawnTimer < spawnCD:
		curSpawnTimer += delta
	else: return

func SpawnEnemy():
	var spawn_location = ChooseSpawnLocation()
	if spawn_location:
		var monster = ChooseMonster()
		if monster:
			var instance = load(monster).instantiate()
			curMobsAlive += 1
			spawn_location.add_child(instance)
			instance.global_position = spawn_location.global_position
			
func ChooseSpawnLocation():
	var valid_locations : Array[Node2D]
	for spawnPoint in enemySpawnsParent.get_children():
		var distanceToPlayer = spawnPoint.global_position - player.global_position
		if abs(distanceToPlayer) > Vector2(distToSpawn, distToSpawn) and abs(distanceToPlayer) < Vector2(distToSpawn + 150, distToSpawn + 150):
			valid_locations.append(spawnPoint)
	if valid_locations.size() > 0:
		return valid_locations[randi() % valid_locations.size()]
	return null

func ChooseMonster():
	var coinFlip = randi_range(0, 18)
	if coinFlip <= 4:
		return monsterBPath
	else: return monsterAPath
