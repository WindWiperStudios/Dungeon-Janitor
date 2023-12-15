extends Node

@export var levels : Array[PackedScene]

func _process(delta):
	if Input.is_action_just_pressed("A"):
		_on_restart_button_pressed()
	if Input.is_action_just_pressed("X"):
		_on_quit_button_pressed()

func _on_restart_button_pressed():
	GlobalVariables.restarting.emit()
	get_tree().change_scene_to_packed(levels[0])


func _on_quit_button_pressed():
	get_tree().change_scene_to_packed(levels[1])
