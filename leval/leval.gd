extends Node

@export var day_duration: float = 300.0  # Длительность дня в секундах
@export var night_duration: float = 300.0  # Длительность ночи в секундах

@onready var directional_light = $Light/Sun
@onready var animation_player = $Light/AnimationLight  # Анимационный плеер для управления анимациями времени суток

var is_day: bool = true
var timer: float = 0.0

func _ready():
	set_day()
	timer = day_duration
	set_process(true)

func _process(delta):
	timer -= delta
	if timer <= 0:
		if is_day:
			set_night()
			timer = night_duration
		else:
			set_day()
			timer = day_duration

func set_day():
	is_day = true
	directional_light.color = Color(1, 1, 1)  # Светлый цвет для дня
	directional_light.energy = 1.0
	animation_player.play("DayToNight")  # Воспроизводим анимацию дня
	print("Daytime")

func set_night():
	is_day = false
	directional_light.color = Color(0, 0, 0.5)  # Темный цвет для ночи
	directional_light.energy = 0.3
	animation_player.play("NightToDay")  # Воспроизводим анимацию ночи
	print("Nighttime")
