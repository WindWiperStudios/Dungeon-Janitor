extends Node2D
class_name MenuScene

@onready var junkSpeedDetailText = $JunkingSpeedText/JunkSpeedDetailText

func _process(delta):
	junkSpeedDetailText.text = str(GlobalVariables.junkingSpeed) + "s"


func _on_speed_upgrade_button_button_down():
	if GlobalVariables.gold >= GlobalVariables.junkingSpeedUpgradePrice and GlobalVariables.junkingSpeedUpgradeLevel < GlobalVariables.junkingSpeedUpgradeMax:
		GlobalVariables.gold -= GlobalVariables.junkingSpeedUpgradePrice
		GlobalVariables.junkingSpeedUpgradeLevel += 1
		GlobalVariables.junkingSpeedUpgradePrice += (GlobalVariables.junkingSpeedUpgradeLevel * .5)
		print("Speed Upgrade Level is: " + str(GlobalVariables.junkingSpeedUpgradeLevel))
		print("Junking speed is: " + str(GlobalVariables.junkingSpeed))
