extends Area2D

@onready var animationPlayer = $AnimationPlayer
@onready var junkProgress : ProgressBar = $JunkProgress
@onready var upgradeAnimation = $UpgradeText/UpgradeAnimation
@onready var upgradeText = $UpgradeText

@export var menuScene : PackedScene


var zoneScene
var hasMenuScene = false

var droppingLoot = false
var totalTimeDropping = 0.0
var shownUpgrade = false
var upgradeShownTime = 0.0

var lootTime : float = 0
var lootCD = GlobalVariables.junkingSpeed
var lootPerDrop = 1

func _ready():
	upgradeText.visible = false
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
	if totalTimeDropping >= 5.0 and !shownUpgrade:
		shownUpgrade = true
		upgradeText.visible = true
		upgradeAnimation.play("intro")
	if shownUpgrade == true:
		upgradeShownTime += delta
		if upgradeShownTime >= 5.0:
			upgradeText.visible = false
	
	if droppingLoot == true:
		totalTimeDropping += delta
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
