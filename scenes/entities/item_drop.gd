extends Node2D
class_name ItemDrop



func _on_area_entered(area):
	#Add to count or w/e and then
	queue_free()
