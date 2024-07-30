extends AudioStreamPlayer

@onready var SFXplayer: AudioStreamPlayer = $GlobalSFX

enum MenuAudioID {CONFIRM, NAVIGATE, CANCEL, BUMP}

@export var menusfxdict = {
	MenuAudioID.CONFIRM: "res://audio/sfx/menuconfirm.wav",
	MenuAudioID.NAVIGATE: "res://audio/sfx/menunavigate.wav",
	MenuAudioID.CANCEL: "res://audio/sfx/menuexit.wav",
	MenuAudioID.BUMP: "res://audio/sfx/bumpsfx.wav"
}

@export var musictracks = {
	"menu": preload("res://audio/music/themedraft.wav"),
	"overworld": preload("res://audio/music/overworld.wav"),
	"trialtense": preload("res://audio/music/trialtense.wav"),
	"culpritsting": preload("res://audio/music/culprit_decision_sting.wav"),
	"goodend": preload("res://audio/music/goodend.wav"),
	"badend": preload("res://audio/music/badend.wav")
}

var mastervolume: float = -6
var musicvolume: float = -24
var musicFXvolume: float = 0
var SFXvolume: float = 0
var dialogueFXvolume: float = 12

var last_loop_track: AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()

func set_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), mastervolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background Music"), musicvolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music FX"), musicFXvolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), SFXvolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogue FX"), dialogueFXvolume)

func play_loaded_music(music: String, loop: bool = true, volume: float = 0) -> void:
	var track = musictracks[music]
	play_music(track, loop, volume)

func play_music(music: AudioStreamWAV, loop: bool = true, volume: float = 0) -> void:
	if stream == music:
		return
	stream = music
	volume_db = volume
	if loop:
		last_loop_track = music
		music_loop_catcher(music)
	else:
		music_loop_catcher(last_loop_track)
	play()
	
func transition_music(music: AudioStreamWAV, time: float, volume: float = 0):
	pass

func play_sound_effect_instance(path: String, volume: float = 0) -> AudioStreamPlayer:
	var sfx = AudioStreamPlayer.new()
	sfx.autoplay = true
	sfx.stream = load(path)
	sfx.bus = "SFX"
	volume_db = volume
	add_child(sfx)
	sfx.connect("finished", sfx.queue_free)
	return sfx
	
func music_loop_catcher(track: AudioStreamWAV) -> void:
	await finished
	play_music(track)

func music_waiter() -> bool:
	await finished
	return true
