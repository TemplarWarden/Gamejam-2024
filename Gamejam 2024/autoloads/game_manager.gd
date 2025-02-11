extends Node

var player_reference: Player
var flag_dictonary : Dictionary = {}
var new_game: bool = true
var has_running_game: bool = false

func bind_player(player: Player) -> void:
	player_reference = player

func unbind_player(_player: Player) -> bool:
	player_reference = null
	return true

func toggle_player_move(args: bool) -> void:
	player_reference.can_move = args

#call when starting new game
func reset_manager() -> void:
	#remove player reference
	#unbind_player(player_reference)
	
	#remove all object references and create new object array
	#for N in object_array:
	#	unbind_NPObject(N)
	player_reference = null
	
	#object_array = []
	
	flag_dictonary = {}
	
	has_running_game = false

#set key in dictionary to args, will add key if does not exist, will override existing value according to override
func set_flag(key: String, args: int = 0, override = true) -> void:
	if !override and flag_dictonary.has(key):
		return
	else:
		flag_dictonary[key] = args

#poll key in dictionary,if no key exists will create one
func get_flag(key: String) -> int:
	if !flag_dictonary.has(key):
		set_flag(key)
	return flag_dictonary[key]

func call_good_end() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/endings/good_end_screen.tscn")
	AudioManager.play_loaded_music("goodend")

func call_bad_end() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/endings/bad_end_screen.tscn")
	AudioManager.play_loaded_music("badend")
