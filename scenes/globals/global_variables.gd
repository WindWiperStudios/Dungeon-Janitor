extends Node2D

@export var musicPlayer : MusicPlayer

var junkAmount : int
var maxJunk : int = 15
var score : int

#Option Variables
var musicVolume : float
var sfxVolume : float

#Player Variables
var playerHP
var playerMaxHP
var playerGlobalPosition
var playerStunned
var playerStunTimer
var playerCurrentState

#Monster related variables
var monstersAggrod = 0

signal itemPickedUp


func _process(delta):
	if monstersAggrod < 1:
		musicPlayer.lowState()
	if monstersAggrod > 0 and monstersAggrod < 2:
		musicPlayer.midState()
	if monstersAggrod > 1:
		musicPlayer.highState()
