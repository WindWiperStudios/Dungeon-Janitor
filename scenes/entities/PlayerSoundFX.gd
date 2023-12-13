extends AudioStreamPlayer
class_name PlayerSoundFX

@export var sounds : Array[AudioStreamWAV]
@export var attacking = false

@export var up = false
@export var down = false


func _process(_delta):
	if up:
		PlayUp()
	if down:
		PlayDown()

func PlayUp():
	up = false
	play()

func PlayDown():
	down = false
	play()
