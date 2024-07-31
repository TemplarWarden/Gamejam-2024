extends CharacterBody2D
class_name Player

@export var movement_speed:float
var target_move: Vector2
var target_object: Clickable
var area_object: Interactable

var has_interact_target:bool = false
var has_interact_body:bool = false

var can_move:bool = true
var is_moving:bool = false

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	GameManager.bind_player(self)
	target_move = position

func _process(delta):
	update_direction()

#move to target location, if very close, stop movement (prevent jittering)
func _physics_process(delta):
	velocity = position.direction_to((target_move)) * movement_speed
	if position.distance_to(target_move) > movement_speed * delta:
		move_and_slide()
		update_animation(true)
	else:
		move_to(position)
		update_animation(false)

#reads input to set movement to location
func move_to(target_position):
	target_move = target_position

func update_animation(is_walking: bool = false) -> void:
	if is_walking:
		sprite.play("walking")
	else:
		sprite.play("default")
		

func _unhandled_input(event):
	#moveto location
	if event.is_action("c_left") || event.is_action("c_right") || event.is_action("c_up") || event.is_action("c_down"):
		var movement = Input.get_vector("c_left", "c_right", "c_up", "c_down")
		move_to(position + movement * movement_speed)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		move_to(get_global_mouse_position())
		has_interact_target = false
	if event is InputEventScreenTouch and event.is_pressed():
		move_to(get_global_mouse_position())
		has_interact_target = false
	#if interact button is pushed, attempt to interact with object (if unhandled, eg. not target button check	
	if event.is_action_pressed("c_interact"):
		interact_check(true)

#pass true if called from unhandled input function, only checks for area_object, else checks if area_object and target_object exist match to fires
func interact_check(args:bool = false) -> void:
	print ("interact check")
	if has_interact_body:
		if has_interact_target:
			if target_object.node_owner == area_object.node_owner:
				send_interact(area_object)
				move_to(global_position)
				has_interact_target = false
			else:
				return
		elif args:
			send_interact(area_object)
			move_to(global_position)

#send to recieving object (turn into signals to decouple?)
func send_interact(object):
	object.recieve_interact()

#recieve target from with object upon click
func recieve_target(target: Clickable):
		target_object = target
		has_interact_target = true
		move_to(target_object.node_owner.global_position)
		#interact check due to potentially being in interact range already
		interact_check()

func poll_entered(object) -> void:
	if object is Interactable:
		has_interact_body = true
		area_object = object
		object.recieve_hover(true)
		interact_check()

func poll_exited(object) -> void:
	if object is Interactable:
		has_interact_body = false
		object.recieve_hover(false)
		area_object = null

func _on_interaction_area_body_entered(body):
	poll_entered(body)

func _on_interaction_area_body_exited(body):
	poll_exited(body)

func _on_interaction_area_area_entered(area):
	poll_entered(area)

func _on_interaction_area_area_exited(area):
	poll_exited(area)

func update_direction():
	if position != target_move:
		var direction = position.direction_to(target_move)
		if direction.x > 0:
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.flip_h = true
		
