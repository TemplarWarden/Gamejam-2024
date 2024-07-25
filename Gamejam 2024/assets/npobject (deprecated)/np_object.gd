extends StaticBody2D
class_name NPObject

signal _on_targeted(myself: NPObject)
signal _on_recieve_interact(player: Player)

@export var pop_up: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.bind_NPObject(self)
	show_pop_up(false)

#recieves interact instruction from player
func recieve_interact(player: Player):
	show_pop_up(false)
	_on_recieve_interact.emit(player)

func recieve_hover(args: bool = true) -> void:
	show_pop_up(args)

#on left button click or touch, sent signal to player
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print_debug(self, "selected")
		_on_targeted.emit(self)
	if event is InputEventScreenTouch and event.is_pressed():
		_on_targeted.emit(self)

func show_pop_up(args: bool):
	pop_up.set_visible(args)
	
func _on_mouse_entered():
	recieve_hover()
	pass # Replace with function body.

func _on_mouse_exited():
	recieve_hover(false)
	pass # Replace with function body.
