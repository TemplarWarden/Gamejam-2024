extends Control

enum AudioID {CONFIRM, NAVIGATE, CANCEL}

@export var sfxdict = {
	AudioID.CONFIRM: "res://audio/sfx/menuconfirm.wav",
	AudioID.NAVIGATE: "res://audio/sfx/menunavigate.wav",
	AudioID.CANCEL: "res://audio/sfx/menuexit.wav"
}

@export var menu_music: AudioStreamWAV = load("res://audio/music/overworld.wav")

@onready var game_scene:String = "res://assets/scenes/gameplay/program_manager.tscn"

var has_navigate_sounds = true

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(menu_music)
	%PlayButton.grab_focus()
	%ContinueButton.set_visible(GameManager.has_running_game)
	if GameManager.has_running_game:
		%ContinueButton.grab_focus()

func _on_continue_button_pressed():
	has_navigate_sounds = false
	get_tree().change_scene_to_file(game_scene)
	_run_sfx(AudioID.CONFIRM)

func _on_play_button_pressed():
	has_navigate_sounds = false
	GameManager.reset_manager()
	GameManager.has_running_game = true
	_run_sfx(AudioID.CONFIRM)
	get_tree().change_scene_to_file(game_scene)

func _on_quit_button_pressed():
	has_navigate_sounds = false
	_run_sfx(AudioID.CANCEL, true)
	get_tree().quit()

func _button_navigate() -> void:
	pass	

func _run_sfx(type: AudioID, will_wait: bool = false) -> bool:
	var ref = AudioManager.play_sound_effect_instance(sfxdict[type])
	if will_wait: await ref.finished
	return will_wait

func _button_exited() -> void:
	if has_navigate_sounds: _run_sfx(AudioID.NAVIGATE)
