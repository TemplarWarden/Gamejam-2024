extends CanvasLayer

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

@onready var balloon: Control = %Balloon
#@onready var character_label: RichTextLabel = %CharacterLabel


@onready var container_left: Control= %DialogueLeft
@onready var container_right: Control = %DialogueRight
@onready var dialogue_label_left: DialogueLabel = %DialogueLabelLeft
@onready var dialogue_label_right: DialogueLabel = %DialogueLabelRight
@onready var portrait_left: TextureRect = %PortraitLeft
@onready var portrait_right: TextureRect = %PortraitRight

@onready var left_audio: AudioStreamPlayer2D = %LeftSpeaker
@onready var right_audio: AudioStreamPlayer2D = %RightSpeaker

#active dialogue_label
@onready var dialogue_label: DialogueLabel = dialogue_label_left
@onready var portrait: TextureRect = portrait_left
@onready var containter: Control = container_left

@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

var _locale: String = TranslationServer.get_locale()

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			GameManager.toggle_player_move(true)
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		#determine character/dialogue talking
		dialogue_label = pick_label(dialogue_line)

		#character_label.visible = not dialogue_line.character.is_empty()
		#character_label.text = tr(dialogue_line.character, "dialogue")

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	GameManager.toggle_player_move(false)
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	
	if dialogue_label.is_typing:
		var skip_button_was_pressed: bool = (event.is_action_pressed("cui_interact")) or (event is InputEventScreenTouch and event.pressed)
		#var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		#var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return
		#if mouse_was_clicked or skip_button_was_pressed:
			#get_viewport().set_input_as_handled()
			#dialogue_label.skip_typing()
			#return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	#get_viewport().set_input_as_handled()

	var new_button_was_pressed: bool = (event.is_action_pressed("cui_interact")) or (event is InputEventScreenTouch and event.pressed)
	if new_button_was_pressed:
		next(dialogue_line.next_id)
	#if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		#next(dialogue_line.next_id)
	#elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		#next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


#endregion

#custom controls

#pick label to be active and hide/transparent other label/portrait
func pick_label(line: DialogueLine) -> DialogueLabel:
	layer_visibiity(container_left)
	layer_visibiity(container_right)
	layer_visibiity(portrait_left, true, 0.5)
	layer_visibiity(portrait_right,true,0.5)
	
	var new_label = dialogue_label
	var new_portrait = portrait
	var new_container = containter
	var audio
	var tag = line.get_tag_value("side")
	if tag == "left" or  tag == "Left":
			new_label = dialogue_label_left
			new_portrait = portrait_left
			new_container = container_left
			audio = left_audio
	if tag == "right" or tag == "Right":
			new_label = dialogue_label_right
			new_portrait = portrait_right
			new_container = container_right
			audio = right_audio
	
	#set balloon features according to characer name from resource 
	set_label_details(new_label, new_portrait, audio, line.character)
	
	layer_visibiity(new_portrait, true, 1)
	layer_visibiity(new_container, true, 1)
	
	return new_label	

func layer_visibiity(control: Control, state: bool = false, value: float = 0) -> void:
	control.set_visible(state)
	control.modulate.a = value

func read_character_resource(character: String) -> Dictionary:
	CharacterTextResourceManager.fetch(character)
	return CharacterTextResourceManager.fetch(character)
	
func set_label_details(label: DialogueLabel, portrait: TextureRect, audio: AudioStreamPlayer2D, character: String) -> void:
	var details: Dictionary = read_character_resource(character)
	portrait.texture = load(details[CharacterTextResourceManager.DICVALUES.PORTRAIT])
	

func _on_dialogue_label_left_spoke(letter, letter_index, speed):
	if letter in [".", " "]:
		left_audio.pitch_scale = randf_range(0.9, 1.1)
		left_audio.play()

func _on_dialogue_label_right_spoke(letter, letter_index, speed):
	if letter in [".", " "]:
		right_audio.pitch_scale = randf_range(0.9, 1.1)
		right_audio.play()

