extends Control

enum AudioID {CONFIRM, NAVIGATE, CANCEL}

@export var sfxdict = {
	AudioID.CONFIRM: "res://audio/sfx/menuconfirm.wav",
	AudioID.NAVIGATE: "res://audio/sfx/menunavigate.wav",
	AudioID.CANCEL: "res://audio/sfx/menuexit.wav"
}

@export var menu_music: AudioStreamWAV = preload("res://audio/music/themedraft.wav")
@export var game_music: AudioStreamWAV = preload("res://audio/music/overworld.wav")

@onready var game_scene:String = "res://assets/scenes/gameplay/program_manager.tscn"

var has_navigate_sounds = true

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(menu_music)
	has_navigate_sounds = false
	%PlayButton.grab_focus()
	%ContinueButton.set_visible(GameManager.has_running_game)
	if GameManager.has_running_game:
		%ContinueButton.grab_focus()	
	has_navigate_sounds = true

func _on_continue_button_pressed():
	has_navigate_sounds = false
	get_tree().change_scene_to_file(game_scene)
	run_sfx(AudioID.CONFIRM)

func _on_play_button_pressed():
	has_navigate_sounds = false
	GameManager.reset_manager()
	GameManager.has_running_game = true
	AudioManager.play_music(game_music)
	run_sfx(AudioID.CONFIRM)
	change_scene()

func _on_quit_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioID.CANCEL, true)
	get_tree().quit()

func _button_navigate() -> void:
	pass	

func change_scene():
	get_tree().change_scene_to_file(game_scene)

func run_sfx(type: AudioID, will_wait: bool = false) -> bool:
	var ref = AudioManager.play_sound_effect_instance(sfxdict[type])
	if will_wait: await ref.finished
	return will_wait

func _button_exited() -> void:
	if has_navigate_sounds:
		run_sfx(AudioID.NAVIGATE)
