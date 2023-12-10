extends ItemDrop
class_name coin

@export var itemValue : int



func _on_hitbox_area_entered(area):
	print("Thing")
	self.queue_free()
