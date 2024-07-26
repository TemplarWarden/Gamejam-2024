extends Node

enum DICVALUES { ID, PORTRAIT, TEXTCOLOR, TYPESOUND, TYPESPEED }

var dict_legend = {
		"id": "default",
		"portrait": "res://Graphics (Placeholder)/yellowchef1.png",
		"text color": Color.WHITE,
		"typing sound": "res://audio/chef_dialogue.wav",
		"typing speed": 0.01,
}

var default_dict: Dictionary = {
		DICVALUES.ID: "default",
		DICVALUES.PORTRAIT: "res://Graphics (Placeholder)/yellowchef1.png",
		DICVALUES.TEXTCOLOR: Color.WHITE,
		DICVALUES.TYPESOUND: "res://audio/chef_dialogue.wav",
		DICVALUES.TYPESPEED: 0.05,
}

var character_array: Array = [

	default_dict,
	 {
		DICVALUES.ID: "test",
		DICVALUES.PORTRAIT: "res://assets/npc/orange/orangeportrait1.png",
		DICVALUES.TEXTCOLOR: Color.ORANGE,
		DICVALUES.TYPESOUND: "res://assets/npc/orange/conehead_dialogue.wav",
		DICVALUES.TYPESPEED: 0.04,
}
]

func _init():
	pass

func fetch(character: String) -> Dictionary:
	for N in character_array:
		if N[DICVALUES.ID].to_lower() == character.to_lower():
			return N
	return default_dict
