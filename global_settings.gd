extends Node

var config_file = ConfigFile.new()
var settings_path = "user://settings.cfg"
var sound_volume = 100

func _ready():
	load_settings()

func load_settings():
	var error = config_file.load(settings_path)
	if error == OK:
		sound_volume = config_file.get_value("audio", "sound_volume", 100)
		apply_settings(sound_volume)
	else:
		save_settings()

func apply_settings(volume):
	print("Applying settings: Sound Volume =", volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)

func save_settings():
	config_file.set_value("audio", "sound_volume", sound_volume)
	var error = config_file.save(settings_path)
	if error != OK:
		print("Error saving settings:", error)

func change_sound_volume(new_volume):
	sound_volume = int(new_volume)
	save_settings()
	apply_settings(new_volume)
