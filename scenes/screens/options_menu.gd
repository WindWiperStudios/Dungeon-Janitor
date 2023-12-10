extends Control
class_name OptionsMenu

@onready var musicSlider = $MusicVolumeSlider
@onready var sfxSlider = $SFXVolSlider
@onready var musicPlayer = $"../MusicPlayer"
@onready var player = $"../ScreenMargin/PlayerCanvas/Player"



func _on_sfx_vol_slider_drag_ended(value_changed):
	player.soundFXPlayer.volume_db = sfxSlider.value

