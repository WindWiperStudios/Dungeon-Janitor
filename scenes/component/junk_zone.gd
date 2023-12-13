extends Area2D

@onready var animationPlayer = $AnimationPlayer
@onready var junkProgress : ProgressBar = $JunkProgress

@export var menuScene : PackedScene


var zoneScene
var hasMenuScene = false

var droppingLoot = false

var lootTime : float = 0
var lootCD = GlobalVariables.junkingSpeed
var lootPerDrop = 1

func _ready():
	junkProgress.min_value = 0
	junkProgress.max_value = 1
	junkProgress.visible = false
	animationPlayer.play("glow")
	if menuScene != null and !hasMenuScene:
		hasMenuScene = true
	
	if hasMenuScene:
		zoneScene = menuScene.instantiate()
		zoneScene.visible = false
		
func _process(delta):
	if droppingLoot == true:
		lootTime += delta
		junkProgress.value = lootTime / lootCD
		if lootTime >= lootCD and GlobalVariables.junkAmount > 0:
			DropLoot()
		elif lootTime >= lootCD and GlobalVariables.junkAmount == 0:
			lootTime = 0

func _on_zone_entered(area):
	#If player entered zone:
	if area.get_parent().name == "Player":
		lootCD = GlobalVariables.junkingSpeed
		lootTime = 0.0
		droppingLoot = true
		junkProgress.visible = true


func _on_zone_exited(area):
	if area.get_parent().name == "Player":
		lootCD = GlobalVariables.junkingSpeed
		droppingLoot = false
		junkProgress.visible = false

func DropLoot():
	lootTime = 0.0
	GlobalVariables.junkAmount -= lootPerDrop
	GlobalVariables.score += lootPerDrop
	GlobalVariables.junkDropped.emit()
