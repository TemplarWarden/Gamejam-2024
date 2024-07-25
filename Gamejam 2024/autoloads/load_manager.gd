extends Node

signal _progress_changed(progress)
signal _load_done

var loading_screen_path: String = "res://loading_screen.tscn"
var loading_screen = load(loading_screen_path)
var loaded_scene: PackedScene
var loaded_scene_path: String
var loading_progress: Array = []

var use_sub_threads: bool = false

func load_scene(path: String):
	loaded_scene_path = path
	var new_loading_scene = loading_screen.instantiate()
	get_tree().get_root().add_child(new_loading_scene)
	
	#have new scene listen to loading manager signals
	self._progress_changed.connect(new_loading_scene._update_progress)
	self._load_done.connect(new_loading_scene._end_progress)
	
	#await Signal(new_loading_scene, "_in_place")
	start_load()
	
func start_load():
	var load_state = ResourceLoader.load_threaded_request(loaded_scene_path,"",use_sub_threads)
	if load_state == OK:
		set_process(true)
		
func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(loaded_scene_path, loading_progress)
	match load_status:
		0, 2:	#no resource, load failed
			set_process(false)
			return
	match load_status:
		1:	#loading
			emit_signal("_progress_changed",loading_progress[0])
	match load_status:
		3: #finished
			loaded_scene = ResourceLoader.load_threaded_get(loaded_scene_path)
			emit_signal("_load_done")
			get_tree().change_scene_to_packed(loaded_scene)
