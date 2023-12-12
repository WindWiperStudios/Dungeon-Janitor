extends Control

@export var BGMWavs : Array[AudioStreamWAV]

@onready var bgm : AudioStreamPlayer = $BGM
@onready var mouseLight = $PointLight2D

var introLength : int = 128

func _process(_delta):
	mouseLight.global_position = get_global_mouse_position()
	

func IntroFinished():
	bgm.stream = BGMWavs[1]

func _on_play_button_pressed()-> void:
	var gamescreenScene = load("res://scenes/screens/game_screen.tscn")
	get_tree().change_scene_to_packed(gamescreenScene)
	

func _on_quit_pressed():
	get_tree().quit()
	

func _on_options_pressed():
	pass # Replace with function body.
