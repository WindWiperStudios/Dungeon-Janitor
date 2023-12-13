extends Node2D

@onready var mapWalls = $MapWalls



func _on_map_walls_area_exited(area):
	if area.get_parent().is_class("Projectile"):
		print(str(area.get_parent().name) + " has exited the world bounds")
