extends Area2D
class_name WorldZone

@export var menuScene : PackedScene
var zoneScene
var hasMenuScene = false

func _ready():
	if menuScene != null and !hasMenuScene:
		hasMenuScene = true
	
	if hasMenuScene:
		zoneScene = menuScene.instantiate()
		zoneScene.visible = false

func _on_zone_entered(area):
	#If player entered zone:
	if area.get_parent().name == "Player":
		if hasMenuScene:
			zoneScene.visible = true


func _on_area_exited(area):
	if area.get_parent().name == "Player":
		if hasMenuScene:
			zoneScene.visible = false
