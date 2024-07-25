extends CanvasLayer

var main_menu_scene:String = "res://assets/scenes/mainmenu/mainmenu.tscn"
var is_paused = false
@onready var previous_focus: Control = %ResumeButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pause(false)

func _on_resume_button_pressed():
	pause(false)

func _on_menu_button_pressed():
	get_tree().change_scene_to_file(main_menu_scene)

func _on_quit_button_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("cui_menu"):
		pause(!is_paused)
	

func pause(passedbool: bool) -> void:
	get_tree().paused = passedbool
	var current_focus
	if passedbool:
		previous_focus = get_viewport().gui_get_focus_owner()
		current_focus = %ResumeButton
	else:
		current_focus = previous_focus
	current_focus.grab_focus()	
	is_paused = passedbool
	visible = passedbool
