extends Node2D
class_name EnemyParent

@export var spawnPoints : Array[Node2D]
@export var enemyList : Array[PackedScene]



func SpawnEnemy():
	var s = randi_range(0, spawnPoints.size() - 1)
	var e = randi_range(0, enemyList.size() - 1)
	
	#Pick a random spawn point
	var parent = spawnPoints[s]
	var enemy = enemyList[e].instantiate()
	parent.add_child(enemy)
