extends Node2D
class_name GameScreen

@onready var minimap = $ScreenCanvas/ScreenMargin/Minimap

# Called when the node enters the scene tree for the first time.
func _ready():
	minimap.visible = true
