extends Control

@onready var map = $Map
@onready var player = $"../PlayerCanvas/Player"
@onready var playerPixel = $Map/PlayerPixel

var coors


func _process(delta):
	GetPlayerLocation()

func GetPlayerLocation():
	coors = snapped(player.global_position, Vector2(1, 1))
	var coorsX : int = coors.x
	var coorsY : int = coors.y
	coors = Vector2((coorsX / 16), (coorsY / 16))
	playerPixel.position = coors
