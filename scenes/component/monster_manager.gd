extends Node
class_name MonsterManager

class Enemy:
	var scene_path : String
	var spawn_chance : float
	
	func _init(scene_path: String, spawn_chance : float):
		self.scene_path = scene_path
		self.spawn_chance = spawn_chance

var monsters = [
	#Spider, 30% chance to spawn
	Enemy.new("res://scenes/entities/spider.tscn", 0.1),
	#Skeleton, 50% chance to spawn
	Enemy.new("res://scenes/entities/skeleton.tscn", 0.5),
]

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

enum State {
	waiting_to_spawn,
	spawning,
	reseting,
	waiting
}

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
			var instance = load(monster.scene_path).instantiate()
			spawn_location.add_child(instance)
			instance.global_position = spawn_location.global_position
			
func ChooseSpawnLocation():
	var valid_locations : Array[Node2D]
	for spawnPoint in enemySpawnsParent.get_children():
		if abs(spawnPoint.global_position - player.global_position) > Vector2(distToSpawn, distToSpawn):
			valid_locations.append(spawnPoint)
	if valid_locations.size() > 0:
		return valid_locations[randi() % valid_locations.size()]
	return null

func ChooseMonster():
	var total_chance = 0.0
	for monster in monsters:
		total_chance += monster.spawn_chance
	var rand_value = randf() * total_chance
	var cumulative_chance = 0.0
	
	for monster in monsters:
		cumulative_chance += monster.spawn_chance
		if rand_value <= cumulative_chance:
			curMobsAlive += 1
			return monster
		return null
