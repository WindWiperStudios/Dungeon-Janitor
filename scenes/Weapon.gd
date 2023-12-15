extends Sprite2D

@export var weaponSprite : Texture
@export var attackDamage : int

func _ready():
	texture = weaponSprite
	GlobalVariables.playerAttackDamage = attackDamage

