@tool
extends Node2D
class_name Door

@export var owned_clickable: Clickable:
	set(object):
		owned_clickable = object
		update_configuration_warnings()
	get:
		return owned_clickable
		
@export var owned_interactable: Interactable:
	set(object):
		owned_interactable = object
		update_configuration_warnings()
	get:
		return owned_interactable

@export var target_door: Door:
	set(door):
		target_door = door
		door.pair_door(self)
		update_configuration_warnings()
	get:
		return target_door
		
@export var reciever_node: Node2D:
	set(node):
		reciever_node = node
		update_configuration_warnings()
	get:
		return reciever_node
		
@export var my_room: RoomHandler
@export var door_sound: AudioStreamPlayer2D

func _get_configuration_warnings() -> PackedStringArray:
	var warningArray = []
	if owned_clickable == null:
		warningArray.append("Does not have a Clickable")
	if owned_interactable == null:
		warningArray.append("Does not have an Interactable")
	if target_door == null:
		warningArray.append("Does not have a paired door")
	elif target_door.reciever_node == null:
		warningArray.append("target door does not have a reciever node")
	if reciever_node == null:
		warningArray.append("Does not have a reciever node, where player will arrive")
	if my_room == null:
		warningArray.append("Does not have a room to make active")
	return warningArray

func pair_door(door:Door):
	if door == target_door:
		return
	else:
		target_door = door
		door.pair_door(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	owned_clickable.node_owner = self
	owned_interactable.node_owner = self
	#attempt to pair this door with another door, will only be necessary if door is accidentally unpaired
	pair_door(target_door)
	listen_child_object()

func listen_child_object():
	owned_clickable.connect("_on_recieve_interact", recieve_click)
	owned_interactable.connect("_on_recieve_interact",use_door)
	
func use_door(_object):
	trigger_transition()

func trigger_transition():
	var target = target_door.reciever_node.global_position
	if is_instance_valid(door_sound): door_sound.play()
	target_door.my_room.enter_room()
	GameManager.player_reference.position = target
	

func recieve_click(object: Clickable) -> void:
	signal_player_target(object)

func signal_player_target(object: Clickable) -> void:
	GameManager.player_reference.recieve_target(object)
	
