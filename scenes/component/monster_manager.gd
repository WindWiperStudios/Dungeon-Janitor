extends Node
class_name MonsterManager

@onready var player = $"../ScreenCanvas/ScreenMargin/PlayerCanvas/Player"
@onready var enemySpawnsParent = $"../ScreenCanvas/ScreenMargin/EnemyCanvas/EnemyParent"

@export var monsters : Array[PackedScene]
@export var maxMobsAlive : int
@export var curMobsAlive : int
@export var spawnCD : float
@export var curSpawnTimer : float

var distToSpawn : float = 50.0
var currentState : State = State.waiting_to_spawn

enum State {
	waiting_to_spawn,
	spawning,
	reseting,
	waiting
}

func _process(delta):
	match currentState:
		State.waiting_to_spawn:
			ProcessSpawnTimer(delta)
			#List of checks before spawning monsters
			if curSpawnTimer >= spawnCD:
				currentState = State.spawning
				
		State.spawning:
			#Find Spawn Location
			var spawnLocationCount = enemySpawnsParent.get_child_count()
			
			var rng = RandomNumberGenerator.new()
			
			var spawnLocation = enemySpawnsParent.get_child(rng.randi_range(0, spawnLocationCount-2))
			var distToPlayer = player.global_position - spawnLocation.global_position
			if abs(distToPlayer.x) >= distToSpawn and abs(distToPlayer.y) <= distToSpawn:
				#Then instantiate mob & add as child
				var monster = monsters[rng.randi_range(0, monsters.size() -1)].instantiate()
				spawnLocation.add_child(monster)
				monster.global_position = spawnLocation.global_position
				curMobsAlive += 1
				currentState = State.reseting
			
		State.reseting:
			#Set state back to default
			curSpawnTimer = 0.0
			currentState = State.waiting
			
		State.waiting:
			if curMobsAlive >= maxMobsAlive:
				return
			else: currentState = State.waiting_to_spawn
			

func ProcessSpawnTimer(delta : float) -> void:
	if curSpawnTimer < spawnCD:
		curSpawnTimer += delta
	else: return
