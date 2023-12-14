extends Area2D


@onready var weapon = $"../../WeaponPoint/Weapon"
@onready var damage = weapon.attackDamage
@onready var attackBox = $AttackBox
@onready var fxAnimation = $"../FXAnimation"
@onready var soundFX = $"../../SoundFX"

@export var alreadyHit : bool = false

@export var hitTimer : float
var curTimer : float

func _process(delta):
	if alreadyHit:
		curTimer += delta
		TimerCheck()

func _on_area_entered(area):
	if area and area.name == "Hitbox" and !alreadyHit:
		DoDamage(area, damage)
		alreadyHit = true
	

func DoDamage(area : Area2D, weaponDamage : int):
	var thingHit = area.get_parent()
	thingHit.hp.takeDamage(weaponDamage)
	attackBox.set_deferred("disabled", true)

func TimerCheck() -> void:
	if curTimer >= hitTimer:
		alreadyHit = false
	else: return

