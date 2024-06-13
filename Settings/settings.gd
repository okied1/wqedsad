extends Node

var config_file = ConfigFile.new()
var settings_path = "user://settings.cfg"
var sound_volume = 75

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
	config_file.save(settings_path)


func _on_save_button_2_pressed():
	get_tree().change_scene_to_file("res://Player/leval/leval.tscn")
