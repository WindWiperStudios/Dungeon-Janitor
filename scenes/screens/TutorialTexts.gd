extends Label
class_name TutorialTexts



func _on_read_zone_area_exited(area):
	if area.get_parent().name == "Player":
		queue_free()
