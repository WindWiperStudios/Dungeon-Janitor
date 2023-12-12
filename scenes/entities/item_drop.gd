extends Node2D
class_name ItemDrop

@export var itemValue : int
@onready var pickupBox = $PickupBox

func _ready():
	pickupBox.connect("area_entered", _on_pickupbox_area_entered)

func _on_pickupbox_area_entered(area):
	if area.get_parent().name == "Player" and GlobalVariables.junkAmount < GlobalVariables.maxJunk:
		GlobalVariables.junkAmount += itemValue
		if GlobalVariables.junkAmount > GlobalVariables.maxJunk:
			GlobalVariables.junkAmount = GlobalVariables.maxJunk
		GlobalVariables.itemPickedUp.emit()
		self.queue_free()
