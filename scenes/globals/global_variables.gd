extends Node2D

@export var musicPlayer : MusicPlayer

var junkAmount : int
var maxJunkDefault : int = 15
var maxJunk = maxJunkDefault
var junkingSpeed : float = 2.5
var score : int
var gold : int
var maxGoldDefault : int = 100
var maxGold = maxGoldDefault

var pausedBool = false
var pauseTimer : float = 0.0

#Option Variables
var musicVolume : float
var sfxVolume : float
var musicPosition

#Player Variables
var playerHP
var playerMaxHP
var playerGlobalPosition
var playerStunned
var playerStunTimer
var playerCurrentState

#UpgradePriceVariables
var junkingSpeedUpgradePrice : int = 25

#UpgradeStageVariables
var junkingSpeedUpgradeLevel = 0
var junkingSpeedUpgradeMax = 4

#Monster related variables
var monstersAggrod = 0

signal itemPickedUp
signal goldPickedUp
signal junkDropped
signal paused
signal unpaused
signal restarting
signal upgrading

func _ready():
	restarting.connect(ResetScore)

func _process(delta):
	
	
	junkingSpeedUpgradePrice = 25 + (junkingSpeedUpgradeLevel * 5)
	
	if Input.is_action_just_pressed("pause") and pauseTimer == 0.0:
		pausedBool = true
		musicPosition = musicPlayer.get_playback_position()
		get_tree().paused = true
		musicPlayer.stop()
	
	if pausedBool == true and pauseTimer <= 1.0:
		pauseTimer += delta
	
	if Input.is_action_just_pressed("pause") and pauseTimer >= 1.0:
		musicPlayer.play(musicPosition)
		pausedBool = false
		pauseTimer = 0.0
		get_tree().paused = false
	
	if monstersAggrod < 1 and musicPlayer.currentState != 0:
		musicPlayer.lowState()
	if monstersAggrod > 0 and monstersAggrod < 2:
		musicPlayer.midState()
	if monstersAggrod > 1:
		musicPlayer.highState()

func ResetScore():
	junkAmount = 0.0
	maxJunk = maxJunkDefault
	maxGold = maxGoldDefault
	junkingSpeed = 2.5
	score = 0
	gold = 0
	playerMaxHP = 15
	playerHP = playerMaxHP
	junkingSpeedUpgradePrice = 25
	junkingSpeedUpgradeLevel = 0
	monstersAggrod = 0
