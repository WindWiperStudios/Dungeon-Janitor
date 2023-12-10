extends Node
class_name HPComponent

@export var curHP : int
@export var maxHP : int

@onready var parent = get_parent()

signal DropItem

var timeToDamage = 1.0
var damageTime = 1.0

func _ready():
	curHP = maxHP

func takeDamage(damage : int):
	damageTime = 0.0
	curHP -= damage
	if curHP <= 0:
		Die()


func Die():
	if parent.name != "Player":
		DropItem.emit()
	parent.queue_free()
