extends Control
@onready var light2d = $PointLight2D

 
 

func _on_play_button_pressed()-> void:
	var gamescreenScene = load("res://scenes/screens/game_screen.tscn")
	get_tree().change_scene_to_packed(gamescreenScene)
	
func _on_settings_button_pressed():
	pass # Replace with function body.
	

func _on_quit_pressed():
	get_tree().quit()
	

#func _on_timer_timeout():
#	var lightTimer = randf_range(0.1, 0.7)
#	$Timer.wait_time = lightTimer
#	print(lightTimer)
#	lightLevelChanger()

#func lightLevelChanger():
#	light2d.energy = randf_range(0, 2)
#	$Timer.start()
