extends Node2D
class_name ItemDrop

@export var itemValue : int
@export var currency = false
@export var junk = false
@export var healthItem = false
@onready var pickupBox : Area2D = $PickupBox
@onready var dropFX = $"../DropSoundFX"
@onready var animationPlayer = $AnimationPlayer


var itemsSpawnedWith
var checkedSpawnedItems = false
var spawnCheckTimer : float
var randX = RandomNumberGenerator.new()
var randY = RandomNumberGenerator.new()

#Initiate sounds
var bloodSound
var junkSound
var goldSound

func _ready():
	if animationPlayer:
		animationPlayer.play("hover")
	spawnCheckTimer = 0.0
	pickupBox.area_entered.connect(_on_pickupbox_area_entered)
	
	bloodSound = load("res://sounds/pickupJunk.wav")
	junkSound = load("res://sounds/bloodPickupSound.wav")
	goldSound = load("res://sounds/pickupCoin.wav")
	
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
		itemValue = randi_range(5, 15)
		dropFX.stream = goldSound
		dropFX.play()
		print("Picked up Gold")
		GlobalVariables.gold += itemValue
		GlobalVariables.goldPickedUp.emit()
		self.queue_free()
		
	
	if junk and area.get_parent().name == "Player" and GlobalVariables.junkAmount < GlobalVariables.maxJunk and currency == false:
		GlobalVariables.junkAmount += randi_range(1, 3)
		dropFX.stream = junkSound
		dropFX.play()
		print("Picked up Junk")
		if GlobalVariables.junkAmount > GlobalVariables.maxJunk:
			GlobalVariables.junkAmount = GlobalVariables.maxJunk
		GlobalVariables.itemPickedUp.emit()
		self.queue_free()
	
	if healthItem == true and area.get_parent().name == "Player" and GlobalVariables.playerHP < GlobalVariables.playerMaxHP:
		print("Picked up HP")
		dropFX.stream = bloodSound
		dropFX.play()
		area.get_parent().hp.curHP += randi_range(1, 3)
		self.queue_free()

func DetectItemOverlap(item):
	item.get_parent().position += Vector2(randX.randf_range(-5, 5), randY.randf_range(-5, 5))
