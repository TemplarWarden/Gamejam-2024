extends CanvasLayer

enum AudioID {CONFIRM, NAVIGATE, CANCEL}

@export var sfxdict = {
	AudioID.CONFIRM: "res://audio/sfx/menuconfirm.wav",
	AudioID.NAVIGATE: "res://audio/sfx/menunavigate.wav",
	AudioID.CANCEL: "res://audio/sfx/menuexit.wav"
}

var has_navigate_sounds: bool = true
var main_menu_scene:String = "res://assets/scenes/mainmenu/mainmenu.tscn"
var is_paused = false

@onready var previous_focus: Control = %ResumeButton
@onready var menu: Control = $Menu
@onready var pause_control: Control = $Pause

# Called when the node enters the scene tree for the first time.
func _ready():
	has_navigate_sounds = false
	pause(false)

func _on_resume_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioID.CANCEL)
	pause(false)

func _on_menu_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioID.CONFIRM)
	get_tree().change_scene_to_file(main_menu_scene)

func _on_quit_button_pressed():
	has_navigate_sounds = false
	run_sfx(AudioID.CANCEL)
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("cui_menu"):
		pause(!is_paused)
	
func pause(passedbool: bool) -> void:
	has_navigate_sounds = false
	get_tree().paused = passedbool
	var current_focus
	if passedbool:
		previous_focus = get_viewport().gui_get_focus_owner()
		current_focus = %ResumeButton
	else:
		current_focus = previous_focus
	if is_instance_valid(current_focus): current_focus.grab_focus()	
	is_paused = passedbool
	has_navigate_sounds = passedbool
	menu.visible = passedbool
	pause_control.visible = !passedbool
	
func run_sfx(type: AudioID, will_wait: bool = false) -> bool:
	var ref = AudioManager.play_sound_effect_instance(sfxdict[type])
	if will_wait: await ref.finished
	return will_wait

func _button_exited() -> void:
	if has_navigate_sounds:
		run_sfx(AudioID.NAVIGATE)

func _on_pause_button_pressed():
	if has_navigate_sounds:
		run_sfx(AudioID.CONFIRM)
	pause_control.release_focus()
	pause(true)
