extends ProgressBar


func _ready():
	self.value = GlobalVariables.musicVolume

func _on_value_changed(value):
	GlobalVariables.musicVolume = self.value
