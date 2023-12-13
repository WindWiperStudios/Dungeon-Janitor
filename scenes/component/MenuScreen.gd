extends Node2D
class_name MenuScene

@onready var junkSpeedDetailText = $JunkingSpeedText/JunkSpeedDetailText
@onready var junkingSpeedPrice = $JunkingSpeedText/JunkingSpeedPrice

func _process(_delta):
	junkSpeedDetailText.text = str(GlobalVariables.junkingSpeed) + "s"
	junkingSpeedPrice.text = "$" + str(GlobalVariables.junkingSpeedUpgradePrice)
	


func _on_speed_upgrade_button_button_down():
	if GlobalVariables.gold >= GlobalVariables.junkingSpeedUpgradePrice and GlobalVariables.junkingSpeedUpgradeLevel < GlobalVariables.junkingSpeedUpgradeMax:
		GlobalVariables.gold -= GlobalVariables.junkingSpeedUpgradePrice
		GlobalVariables.goldPickedUp.emit()
		GlobalVariables.junkingSpeedUpgradeLevel += 1
		GlobalVariables.junkingSpeedUpgradePrice += (GlobalVariables.junkingSpeedUpgradeLevel * 5.5)
		GlobalVariables.junkingSpeed = 2.5 - (GlobalVariables.junkingSpeedUpgradeLevel * .5)
		print("Speed Upgrade Level is: " + str(GlobalVariables.junkingSpeedUpgradeLevel))
		print("Junking speed is: " + str(GlobalVariables.junkingSpeed))
