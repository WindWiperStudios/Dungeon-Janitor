extends Label


func _on_area_exited(area):
	if area.get_parent().name == "Player":
		queue_free()
