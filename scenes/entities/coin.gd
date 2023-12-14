extends ItemDrop
class_name coin

@onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("hover")
