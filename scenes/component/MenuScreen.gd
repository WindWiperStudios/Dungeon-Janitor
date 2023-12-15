extends Node2D
class_name MenuScene

@onready var junking_speed_text = $JunkingSpeedText
@onready var junkSpeedDetailText = $JunkingSpeedText/JunkSpeedDetailText
@onready var junkingSpeedPrice = $JunkingSpeedText/JunkingSpeedPrice
@onready var attack_speed_text = $AttackSpeedText
@onready var attk_speed_detail_text = $AttackSpeedText/AttkSpeedDetailText
@onready var attk_speed_price = $AttackSpeedText/AttkSpeedPrice
@onready var wallet_size_text = $WalletSizeText
@onready var wallet_detail_text = $WalletSizeText/WalletDetailText
@onready var wallet_price = $WalletSizeText/WalletPrice
@onready var dash_text = $DashText
@onready var dash_detail_text = $DashText/DashDetailText
@onready var dash_price = $DashText/DashPrice

func _process(_delta):
	if Input.is_action_just_pressed("A"):
		_on_speed_upgrade_button_button_down()
	if Input.is_action_just_pressed("B"):
		_on_attack_speed_upgrade_button_button_down()
	if Input.is_action_just_pressed("X"):
		_on_wallet_upgrade_button_button_down()
	if Input.is_action_just_pressed("Y"):
		_on_dash_upgrade_button_button_down()
	
	if GlobalVariables.junkingSpeedUpgradeLevel < GlobalVariables.junkingSpeedUpgradeMax:
		junkSpeedDetailText.text = str(GlobalVariables.junkingSpeed) + "s"
		junkingSpeedPrice.text = "$" + str(GlobalVariables.junkingSpeedUpgradePrice)
	elif GlobalVariables.junkingSpeedUpgradeLevel >= GlobalVariables.junkingSpeedUpgradeMax:
		junking_speed_text.visible = false
	
	if GlobalVariables.attackSpeedUpgradeLevel < GlobalVariables.attackSpeedUpgradeMax:
		attk_speed_detail_text.text = "." + str(GlobalVariables.playerAttackCD) + "s"
		attk_speed_price.text = "$" + str(GlobalVariables.attackSpeedUpgradePrice)
	elif GlobalVariables.attackSpeedUpgradeLevel >= GlobalVariables.attackSpeedUpgradeMax:
		attack_speed_text.visible = false
		
	if GlobalVariables.walletSizeUpgradeLevel < GlobalVariables.walletSizeUpgradeMax:
		wallet_detail_text.text = str(GlobalVariables.maxGold + 100)
		wallet_price.text = "$" + str(GlobalVariables.walletSizeUpgradePrice)
	elif GlobalVariables.walletSizeUpgradeLevel >= GlobalVariables.walletSizeUpgradeMax:
		wallet_size_text.visible = false
	
	if GlobalVariables.playerHasDash == false:
		dash_detail_text.text = "Unlock"
		dash_price.text = "$" + str(GlobalVariables.dashUpgradePrice)
	elif GlobalVariables.playerHasDash == true:
		dash_text.visible = false

func _on_speed_upgrade_button_button_down():
	if GlobalVariables.gold >= GlobalVariables.junkingSpeedUpgradePrice and GlobalVariables.junkingSpeedUpgradeLevel < GlobalVariables.junkingSpeedUpgradeMax:
		GlobalVariables.gold -= GlobalVariables.junkingSpeedUpgradePrice
		GlobalVariables.goldPickedUp.emit()
		GlobalVariables.junkingSpeedUpgradeLevel += 1
		GlobalVariables.junkingSpeedUpgradePrice = (25 + (GlobalVariables.junkingSpeedUpgradeLevel * 5))
		GlobalVariables.junkingSpeed = 2.5 - (GlobalVariables.junkingSpeedUpgradeLevel * .5)


func _on_attack_speed_upgrade_button_button_down():
	if GlobalVariables.gold >= GlobalVariables.attackSpeedUpgradePrice and GlobalVariables.attackSpeedUpgradeLevel < GlobalVariables.attackSpeedUpgradeMax:
		GlobalVariables.gold -= GlobalVariables.attackSpeedUpgradePrice
		GlobalVariables.goldPickedUp.emit()
		GlobalVariables.attackSpeedUpgradeLevel += 1
		GlobalVariables.attackSpeedUpgradePrice = (35 + (GlobalVariables.attackSpeedUpgradeLevel * 30))
		GlobalVariables.playerAttackCD = GlobalVariables.playerAttackCDDefault - (GlobalVariables.attackSpeedUpgradeLevel * .15)


func _on_wallet_upgrade_button_button_down():
	if GlobalVariables.gold >= GlobalVariables.walletSizeUpgradePrice and GlobalVariables.walletSizeUpgradeLevel < GlobalVariables.walletSizeUpgradeMax:
		GlobalVariables.gold -= GlobalVariables.walletSizeUpgradePrice
		GlobalVariables.goldPickedUp.emit()
		GlobalVariables.walletSizeUpgradeLevel += 1
		GlobalVariables.walletSizeUpgradePrice = (35 + (GlobalVariables.walletSizeUpgradeLevel * 45))
		GlobalVariables.maxGold = GlobalVariables.maxGoldDefault + (GlobalVariables.walletSizeUpgradeLevel * 100)


func _on_dash_upgrade_button_button_down():
	if GlobalVariables.gold >= GlobalVariables.dashUpgradePrice and GlobalVariables.playerHasDash == false:
		GlobalVariables.gold -= GlobalVariables.dashUpgradePrice
		GlobalVariables.goldPickedUp.emit()
		GlobalVariables.playerHasDash = true
