extends Control

@export var BGMWavs : Array[AudioStreamWAV]

@onready var mouseLight = $PointLight2D
@onready var animationPlayer = $AnimationPlayer
@onready var musicSlider = $VolumeText/MusicVolumeSlider

var introLength : int = 128

func _ready():
	musicSlider.value = GlobalVariables.musicVolume
	GlobalVariables.musicPlayer.stream = load("res://sounds/MainMenuBGMLoop.wav")
	GlobalVariables.musicPlayer.play()
	animationPlayer.play("ArrowMovement")

func _process(_delta):
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
