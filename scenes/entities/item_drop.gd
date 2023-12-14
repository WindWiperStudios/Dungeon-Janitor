extends Node2D
class_name ItemDrop

@export var itemValue : int
@export var currency = false
@export var healthItem = false
@onready var pickupBox : Area2D = $PickupBox

var itemsSpawnedWith
var checkedSpawnedItems = false
var spawnCheckTimer : float
var randX = RandomNumberGenerator.new()
var randY = RandomNumberGenerator.new()

func _ready():
	spawnCheckTimer = 0.0
	pickupBox.area_entered.connect(_on_pickupbox_area_entered)
	
func _process(delta):
	randX = RandomNumberGenerator.new()
	randY = RandomNumberGenerator.new()
	if checkedSpawnedItems == false:
		spawnCheckTimer += delta
		if spawnCheckTimer > randf_range(.2, .5):
			itemsSpawnedWith = pickupBox.get_overlapping_areas()
			for item in itemsSpawnedWith:
				DetectItemOverlap(item)
			checkedSpawnedItems = true

func _on_pickupbox_area_entered(area):
	if currency and area.get_parent().name == "Player" and GlobalVariables.gold < GlobalVariables.maxGold:
		GlobalVariables.gold += itemValue
		GlobalVariables.goldPickedUp.emit()
		self.queue_free()
		
	
	if area.get_parent().name == "Player" and GlobalVariables.junkAmount < GlobalVariables.maxJunk and !currency:
		GlobalVariables.junkAmount += itemValue
		if GlobalVariables.junkAmount > GlobalVariables.maxJunk:
			GlobalVariables.junkAmount = GlobalVariables.maxJunk
		GlobalVariables.itemPickedUp.emit()
		self.queue_free()
	
	if healthItem == true and area.get_parent().name == "Player" and GlobalVariables.playerHP < GlobalVariables.playerMaxHP:
		area.get_parent().hp.curHP += itemValue
		self.queue_free()

func DetectItemOverlap(item):
	item.get_parent().position += Vector2(randX.randf_range(-5, 5), randY.randf_range(-5, 5))
