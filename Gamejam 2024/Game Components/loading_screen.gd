extends CanvasLayer
class_name loading_screen
signal _in_place

func _ready():
	pass
	
func _update_progress(new: float):
	print_debug(new)
	pass

func _end_progress():
	self.queue_free()
