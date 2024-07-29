extends Control

enum AudioID {CONFIRM, NAVIGATE, CANCEL}

@export var sfxdict = {
	AudioID.CONFIRM: "res://audio/sfx/menuconfirm.wav",
	AudioID.NAVIGATE: "res://audio/sfx/menunavigate.wav",
	AudioID.CANCEL: "res://audio/sfx/menuexit.wav"
}

var has_navigate_sounds = false
var main_menu_scene:String = "res://assets/scenes/mainmenu/mainmenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	has_navigate_sounds = false
	%PlayButton.grab_focus()
	has_navigate_sounds = true

func _on_play_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioID.CONFIRM)
	get_tree().change_scene_to_file(main_menu_scene)

func _on_quit_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioID.CANCEL, true)
	get_tree().quit()

func run_sfx(type: AudioID, will_wait: bool = false) -> bool:
	var ref = AudioManager.play_sound_effect_instance(sfxdict[type])
	if will_wait: await ref.finished
	return will_wait

func _button_exited() -> void:
	if has_navigate_sounds:
		run_sfx(AudioID.NAVIGATE)
