extends Node2D
class_name Entity

@onready var spriteNode = $Sprite

@onready var hp = $HPComponent
@onready var hpBar = $ProgressBar

@onready var root = get_tree().get_root()

@export var itemDrops : Array[PackedScene]
@export var dropParent : Node2D

func _ready():
	hp.DropItem.connect(DropWhenDead)
	hpBar.max_value = hp.maxHP
	hpBar.min_value = 0

func _process(delta):
	hpBar.value = hp.curHP
	if hp.curHP < hp.maxHP:
		hpBar.visible = true
	else: hpBar.visible = false

func DropWhenDead():
	var root = get_tree().get_root()
	for i in range(0, itemDrops.size()):
		var item = itemDrops[i].instantiate()
		call_deferred("AddToRoot", item)
		item.global_position = self.global_position

func AddToRoot(itemDropped : Node):
	dropParent.add_child(itemDropped)
