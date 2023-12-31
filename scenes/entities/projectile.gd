extends Node2D
class_name Projectile

@export var doesEffect = false
@export var effectSTUN = false
@export var stunLength : float
@export var effectETC = false
@export var maxTimeAlive : float

var speed : float

var timeAlive = 0.0
var damage : int

var target : CharacterBody2D
var targetDir : Vector2
var hasTarget = false
var traveling = false

func _physics_process(delta):
	timeAlive += delta
	if timeAlive >= maxTimeAlive:
		queue_free()
	if !hasTarget:
		return
	if hasTarget and !traveling:
		targetDir = (target.global_position - self.global_position).normalized()
		traveling = true
	if hasTarget and traveling:
		self.position += targetDir * speed * delta


func _on_hurt_box_area_entered(area):
	if area.get_parent().name == "Player":
		DoDamage(area.get_parent())
	else: queue_free()

func DoDamage(area):
	if area.hp:
		area.hp.takeDamage(damage)
		if doesEffect:
			if effectSTUN:
				area.stunnedCD = stunLength
				area.stunned = true
				
	queue_free()
