extends Control

@export var BGMWavs : Array[AudioStreamWAV]
@export var splashPlayed = false

@onready var mouseLight = $PointLight2D
@onready var animationPlayer = $AnimationPlayer
@onready var musicSlider = $VolumeText/MusicVolumeSlider

var introLength : int = 128

func _ready():
	splashPlayed = false
	musicSlider.value = GlobalVariables.musicVolume
	GlobalVariables.musicPlayer.stream = load("res://sounds/MainMenuBGMLoop.wav")
	GlobalVariables.musicPlayer.play()

func _process(_delta):
	if splashPlayed == false:
		animationPlayer.play("splash")
	if splashPlayed == true:
		animationPlayer.play("ArrowMovement")
	if Input.is_action_just_pressed("A"):
		_on_play_button_pressed()
	if Input.is_action_just_pressed("X"):
		_on_quit_pressed()
	mouseLight.global_position = get_global_mouse_position()
	

func _on_play_button_pressed()-> void:
	var gamescreenScene = load("res://scenes/screens/game_screen.tscn")
	get_tree().change_scene_to_packed(gamescreenScene)
	GlobalVariables.musicPlayer.stream = load("res://sounds/BGMLow.wav")
	GlobalVariables.musicPlayer.play()
	GlobalVariables.restarting.emit()

func _on_quit_pressed():
	get_tree().quit()
	


func _on_music_volume_slider_value_changed(value):
	GlobalVariables.musicPlayer.volume_db = musicSlider.value
	if musicSlider.value == musicSlider.min_value:
		GlobalVariables.musicPlayer.volume_db = -80
