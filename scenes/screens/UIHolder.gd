extends Node2D

@export var goldIcons : Array[CompressedTexture2D]

@onready var junkAmount : Label = $JunkAmount
@onready var score = $Score
@onready var gold = $Gold
@onready var goldIcon = $GoldIcon

func _ready():
	GlobalVariables.connect("itemPickedUp", UpdateJunk)
	GlobalVariables.connect("goldPickedUp", UpdateGold)
	GlobalVariables.connect("junkDropped", UpdateScore)
	GlobalVariables.connect("restarting", ResetScore)
	GlobalVariables.connect("upgrading", UpdateUpgrades)
	UpdateJunk()
	
func UpdateJunk():
	junkAmount.text = "Junk: " + str(GlobalVariables.junkAmount) + "/" + str(GlobalVariables.maxJunk)

func UpdateScore():
	junkAmount.text = "Junk: " + str(GlobalVariables.junkAmount) + "/" + str(GlobalVariables.maxJunk)
	score.text = "Score: " + str(GlobalVariables.score)
	
func UpdateGold():
	var goldPercentage = float(GlobalVariables.gold) / float(GlobalVariables.maxGold)
	if GlobalVariables.gold > GlobalVariables.maxGold:
		GlobalVariables.gold = GlobalVariables.maxGold
	gold.text = str(GlobalVariables.gold)
	if goldPercentage < .33:
		goldIcon.texture = goldIcons[0]
	if goldPercentage >= .33 and goldPercentage < .66:
		goldIcon.texture = goldIcons[1]
	if goldPercentage >= .66:
		goldIcon.texture = goldIcons[2]

func ResetScore():
	UpdateJunk()
	UpdateScore()
	UpdateGold()

func UpdateUpgrades():
	UpdateGold()
	


func _on_add_gold_button_down():
	GlobalVariables.gold += 25
	UpdateGold()
