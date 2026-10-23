extends Node

const SAVE_PATH := "user://settings.cfg"

var music_volume := 1.0
var sfx_volume := 1.0

func _ready() -> void:
	load_settings()
	_apply_bus("Music", music_volume)
	_apply_bus("SFX", sfx_volume)

func set_music_volume(value: float) -> void:
	music_volume = value
	_apply_bus("Music", value)

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	_apply_bus("SFX", value)

func _apply_bus(bus_name: String, value: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(value))
	AudioServer.set_bus_mute(idx, value <= 0.001)

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", music_volume)
	cfg.set_value("audio", "sfx", sfx_volume)
	cfg.save(SAVE_PATH)

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	music_volume = cfg.get_value("audio", "music", 1.0)
	sfx_volume = cfg.get_value("audio", "sfx", 1.0)
