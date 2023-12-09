extends Node2D
class_name Entity

@onready var spriteNode = $Sprite

@onready var hp = $HPComponent

@onready var root = get_tree().get_root()

@export var itemDrops : Array[PackedScene]

func _ready():
	hp.DropItem.connect(DropWhenDead)


func DropWhenDead():
	var root = get_tree().get_root()
	for i in range(0, itemDrops.size()):
		var item = itemDrops[i].instantiate()
		print(item.name)
		item.global_position = self.global_position
		call_deferred("AddToRoot", item)

func AddToRoot(itemDropped : Node):
	root.add_child(itemDropped)
