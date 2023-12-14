extends Area2D

@onready var animationPlayer = $AnimationPlayer
@onready var playerCanvas = $"../../../../PlayerCanvas"

@export var menuScene : PackedScene
@export var menuOffset : Vector2


var zoneScene
var hasMenuScene = false

func _ready():
	animationPlayer.play("glow")
	if menuScene != null and !hasMenuScene:
		hasMenuScene = true
	
	if hasMenuScene:
		zoneScene = menuScene.instantiate()
		playerCanvas.add_child(zoneScene)
		#zoneScene.global_position = self.global_position + menuOffset
		zoneScene.visible = false
		
func _process(_delta):
	zoneScene.global_position = self.global_position + Vector2(-72.12, -65.76)

func _on_zone_entered(area):
	#If player entered zone:
	if area.get_parent().name == "Player":
		zoneScene.visible = true


func _on_zone_exited(area):
	if area.get_parent().name == "Player":
		zoneScene.visible = false
