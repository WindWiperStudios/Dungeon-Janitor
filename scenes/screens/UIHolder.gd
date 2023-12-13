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
	UpdateJunk()
	
func UpdateJunk():
	junkAmount.text = "Junk: " + str(GlobalVariables.junkAmount) + "/" + str(GlobalVariables.maxJunk)

func UpdateScore():
	junkAmount.text = "Junk: " + str(GlobalVariables.junkAmount) + "/" + str(GlobalVariables.maxJunk)
	score.text = "Score: " + str(GlobalVariables.score)
	
func UpdateGold():
	gold.text = str(GlobalVariables.gold)
	if GlobalVariables.gold >= 10:
		goldIcon = goldIcons[1]
	if GlobalVariables.gold >= 15:
		goldIcon = goldIcons[2]
