extends Control

 
 
func _ready():
	pass
	

func _on_play_button_pressed()-> void:
	var gamescreenScene = load("res://scenes/screens/game_screen.tscn")
	get_tree().change_scene_to_file(gamescreenScene)
	
func _on_settings_button_pressed():
	pass # Replace with function body.
	

func _on_quit_pressed():
	pass # Replace with function body.
	
