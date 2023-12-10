extends Node2D
class_name EnemyParent

@export var spawnPoints : Array[Node2D]
@export var enemyList : Array[PackedScene]



func SpawnEnemy():
	var s = randi_range(0, spawnPoints.size())
	var e = randi_range(0, enemyList.size())
	
	
