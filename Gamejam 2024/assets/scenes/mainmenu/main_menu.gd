extends Control

@export var menu_music: AudioStreamWAV = preload("res://audio/music/themedraft.wav")
@export var game_music: AudioStreamWAV = preload("res://audio/music/overworld.wav")

@onready var game_scene:String = "res://assets/scenes/gameplay/program_manager.tscn"

var has_navigate_sounds = true

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(menu_music)
	has_navigate_sounds = false
	%PlayButton.grab_focus()
	#%ContinueButton.set_visible(GameManager.has_running_game)
	#if GameManager.has_running_game:
	#	%ContinueButton.grab_focus()	
	has_navigate_sounds = true

func _on_continue_button_pressed():
	has_navigate_sounds = false
	get_tree().change_scene_to_file(game_scene)
	run_sfx(AudioManager.MenuAudioID.CONFIRM)

func _on_play_button_pressed():
	has_navigate_sounds = false
	GameManager.reset_manager()
	GameManager.has_running_game = true
	AudioManager.play_music(game_music)
	run_sfx(AudioManager.MenuAudioID.CONFIRM)
	change_scene()

func _on_quit_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioManager.MenuAudioID.CANCEL, true)
	get_tree().quit()

func _button_navigate() -> void:
	pass	

func change_scene():
	get_tree().change_scene_to_file(game_scene)

func run_sfx(type, will_wait: bool = false) -> bool:
	var ref = AudioManager.play_sound_effect_instance(AudioManager.menusfxdict[type])
	if will_wait: await ref.finished
	return will_wait

func _button_exited() -> void:
	if has_navigate_sounds:
		run_sfx(AudioManager.MenuAudioID.NAVIGATE)
