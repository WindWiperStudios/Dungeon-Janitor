extends Node2D

@onready var junkAmount : Label = $JunkAmount

func _ready():
	GlobalVariables.connect("itemPickedUp", UpdateJunk)
	UpdateJunk()
	
func UpdateJunk():
	junkAmount.text = "Junk: " + str(GlobalVariables.junkAmount) + "/" + str(GlobalVariables.maxJunk)
