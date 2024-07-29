@tool
extends Node2D
class_name NPC

@export var owned_clickable: Clickable:
	set(object):
		owned_clickable = object
		#owned_clickable.node_owner = self
		update_configuration_warnings()
	get:
		return owned_clickable
		
@export var owned_interactable: Interactable:
	set(object):
		owned_interactable = object
		#owned_interactable.node_owner = self
		update_configuration_warnings()
	get:
		return owned_interactable

@export var npcdialogue: DialogueResource

func _get_configuration_warnings() -> PackedStringArray:
	var warningArray = []
	if owned_clickable == null:
		warningArray.append("Does not have a Clickable")
	if owned_interactable == null:
		warningArray.append("Does not have an Interactable")
	return warningArray
		
# Called when the node enters the scene tree for the first time.
func _ready():
	owned_clickable.node_owner = self
	owned_interactable.node_owner = self
	
	owned_clickable.connect("_on_recieve_interact", recieve_click)
	owned_clickable.connect("_on_recieve_hover", recieve_hover)
	owned_interactable.connect("_on_recieve_interact", recieve_interact)
	owned_interactable.connect("_on_recieve_hover", recieve_hover)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

	
func talk_to():
	DialogueManager.show_dialogue_balloon(npcdialogue)
	
func recieve_click(object: Clickable) -> void:
	signal_player_target(object)
	
func recieve_interact(_object) -> void:
	talk_to()
	
func recieve_hover(_object, _args) -> void:
	pass
	
func signal_player_target(object: Clickable) -> void:
	GameManager.player_reference.recieve_target(object)
	

