extends Node

enum DICVALUES { ID, PORTRAIT, TEXTCOLOR, TYPESOUND, TYPESPEED }

var dict_legend = {
		"id": "default",
		"portrait": "res://assets/player/detectiveportrait1.pn",
		"text color": Color.WHITE,
		"typing sound": "res://assets/player/protagdialogue.wav",
		"typing speed": 0.01,
}

var default_dict: Dictionary = {
	DICVALUES.ID: "default",
	DICVALUES.PORTRAIT: "res://assets/player/detectiveportrait1.png",
	DICVALUES.TEXTCOLOR: Color.WHITE,
	DICVALUES.TYPESOUND: "res://assets/player/protagdialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}
var player_dict: Dictionary = {
	DICVALUES.ID: "player",
	DICVALUES.PORTRAIT: "res://assets/player/detectiveportrait1.png",
	DICVALUES.TEXTCOLOR: Color.WHITE,
	DICVALUES.TYPESOUND: "res://assets/player/protagdialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}
var blue_dict: Dictionary = {
	DICVALUES.ID: "blue",
	DICVALUES.PORTRAIT: "res://assets/npc/blue/blueportrait1.png",
	DICVALUES.TEXTCOLOR: Color.BLUE,
	DICVALUES.TYPESOUND: "res://assets/npc/blue/bluedialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}
var green_dict: Dictionary = {
	DICVALUES.ID: "green",
	DICVALUES.PORTRAIT: "res://assets/npc/green/greenportrait1.png",
	DICVALUES.TEXTCOLOR: Color.GREEN,
	DICVALUES.TYPESOUND: "res://assets/npc/green/greendialogue.wav",
	DICVALUES.TYPESPEED: 0.08,
}
var orange_dict: Dictionary = {
	DICVALUES.ID: "orange",
	DICVALUES.PORTRAIT: "res://assets/npc/orange/orangeportrait1.png",
	DICVALUES.TEXTCOLOR: Color.ORANGE,
	DICVALUES.TYPESOUND: "res://assets/npc/orange/conehead_dialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}
var purple_dict: Dictionary = {
	DICVALUES.ID: "purple",
	DICVALUES.PORTRAIT: "res://assets/npc/purple/purpleportrait2.png",
	DICVALUES.TEXTCOLOR: Color.PURPLE,
	DICVALUES.TYPESOUND: "res://assets/npc/purple/purpledialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}
var red_dict: Dictionary = {
	DICVALUES.ID: "red",
	DICVALUES.PORTRAIT: "res://assets/npc/red/redportrait.png",
	DICVALUES.TEXTCOLOR: Color.RED,
	DICVALUES.TYPESOUND: "res://assets/npc/red/red_dialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}
var yellow_dict: Dictionary = {
	DICVALUES.ID: "yellow",
	DICVALUES.PORTRAIT: "res://assets/npc/yellow/yellowchef1.png",
	DICVALUES.TEXTCOLOR: Color.YELLOW,
	DICVALUES.TYPESOUND: "res://assets/npc/yellow/chef_dialogue.wav",
	DICVALUES.TYPESPEED: 0.05,
}

var character_array: Array = [
	default_dict,
	player_dict,
	blue_dict,
	green_dict,
	orange_dict,
	purple_dict,
	red_dict,
	yellow_dict
	]

func _init():
	pass

func fetch(character: String) -> Dictionary:
	for N in character_array:
		if N[DICVALUES.ID].to_lower() == character.to_lower():
			return N
	return default_dict
