#THIS DOES NOTHING ON ITS OWN EXCEPT TRANSPORT INFORMATION

extends Area2D
class_name Interactable

signal _on_recieve_interact(myself: Interactable)
signal _on_recieve_hover(myself: Interactable, args: bool)

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
		
