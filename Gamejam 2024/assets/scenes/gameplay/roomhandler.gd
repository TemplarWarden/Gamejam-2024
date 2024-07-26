extends Node2D
class_name RoomHandler

@export var music: AudioStreamWAV

@onready var assignedcamera: Camera2D = $Camera2D
@onready var assignedlistener: AudioListener2D = $AudioListener2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enter_room():
	assignedlistener.make_current()
	assignedcamera.make_current()
	if is_instance_valid(music): AudioManager.play_music(music)
