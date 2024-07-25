#THIS DOES NOTHING ON ITS OWN EXCEPT TRANSPORT INFORMATION

extends Area2D
class_name Clickable

signal _on_recieve_interact(myself: Clickable)
signal _on_recieve_hover(myself: Clickable, args: bool)

@export var pop_up: Node2D

var node_owner: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#called from player
func recieve_interact() -> void:
	_on_recieve_interact.emit(self)
	
func recieve_hover(args: bool = true) -> void:
	_on_recieve_hover.emit(self, args)
	if is_instance_valid(pop_up):
		pop_up.set_visible(args)

#on left button click or touch, sent signal to player
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_on_recieve_interact.emit(self)
	if event is InputEventScreenTouch and event.is_pressed():
		_on_recieve_interact.emit(self)

func _on_mouse_entered():
	recieve_hover(true)
	#_on_recieve_hover.emit(self, true)

func _on_mouse_exited():
	recieve_hover(false)
	#_on_recieve_hover.emit(self, false)
