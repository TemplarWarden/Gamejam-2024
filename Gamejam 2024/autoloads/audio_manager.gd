extends AudioStreamPlayer

@onready var SFXplayer: AudioStreamPlayer = $GlobalSFX

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_music(music: AudioStreamWAV, volume: float = 0) -> void:
	if stream == music:
		return
	music.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream = music
	volume_db = volume
	play()
	
func transition_music(music: AudioStreamWAV, time: float, volume: float = 0):
	pass

func play_sound_effect_instance(path: String, volume: float = 0) -> AudioStreamPlayer:
	var sfx = AudioStreamPlayer.new()
	sfx.autoplay = true
	sfx.stream = load(path)
	volume_db = volume
	add_child(sfx)
	sfx.connect("finished", sfx.queue_free)
	return sfx
	
	
