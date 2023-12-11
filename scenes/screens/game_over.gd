extends Node

@export var levels : Array[PackedScene]

func _ready():
	pass

func _on_restart_button_pressed():
	get_tree().change_scene_to_packed(levels[0])


func _on_quit_button_pressed():
	get_tree().change_scene_to_packed(levels[1])
