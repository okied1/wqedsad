extends Node2D

@onready var buttons = $Buttons


func _on_quit_pressed():
	buttons.play()
	await buttons.finished
	get_tree().quit()

func _on_play_pressed():
	buttons.play()
	await buttons.finished
	get_tree().change_scene_to_file("res://Player/leval/leval.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Settings/settings.tscn")
