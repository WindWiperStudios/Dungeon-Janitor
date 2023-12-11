extends Control
class_name OptionsMenu

@onready var musicSlider = $MusicVolumeSlider
@onready var sfxSlider = $SFXVolSlider
@onready var musicPlayer = $"../MusicPlayer"
@onready var player = $"../ScreenMargin/PlayerCanvas/Player"



func _on_sfx_vol_slider_drag_ended(value_changed):
	player.soundFXPlayer.volume_db = sfxSlider.value

func _on_music_volume_slider_drag_ended(value_changed):
	musicPlayer.volume_db = musicSlider.value
	if musicSlider.value == musicSlider.min_value:
		musicPlayer.volume_db = -80

func _on_resume_button_down():
	player.Unpause()
	get_tree().paused = false


