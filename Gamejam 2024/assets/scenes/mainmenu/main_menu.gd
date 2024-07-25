extends Control

@onready var game_scene:String = "res://assets/scenes/gameplay/program_manager.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	%PlayButton.grab_focus()
	%ContinueButton.set_visible(GameManager.has_running_game)
	if GameManager.has_running_game:
		%ContinueButton.grab_focus()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_continue_button_pressed():
	get_tree().change_scene_to_file(game_scene)

func _on_play_button_pressed():
	GameManager.reset_manager()
	GameManager.has_running_game = true
	get_tree().change_scene_to_file(game_scene)

func _on_quit_button_pressed():
		get_tree().quit()
