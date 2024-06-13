extends CharacterBody2D

@export var max_health: int = 100
var current_health: int

@export var move_speed: int = 200
@export var jump_force: int = 400
@export var gravity: int = 900
@export var slide_speed: int = 100
@export var attack_damage: int = 20
@export var attack_duration: float = 0.5

var on_ladder = false
var on_wall = false
var is_attacking = false

@onready var animation_player = $AnimationPlayer
@onready var anim = $AnimatedSprite2D
@onready var walldetector = $"../walldetector"
@onready var ladder_detector = $"../LadderDetector"
@onready var attack_area = $AttackArea


func _ready():
	current_health = max_health
	add_to_group("Player")  # Добавьте игрока в группу "Player"
	

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()
	else:
		print("Player health: %d" % current_health)  # Для отладки

func heal(amount: int):
	current_health += amount
	if current_health > max_health:
		current_health = max_health

func die():
	queue_free()  # Удаляет персонажа из сцены. Вы можете заменить это на логику для обработки смерти персонажа.

func _physics_process(delta):
	if not is_attacking:
		handle_input(delta)
	move_and_slide()

func handle_input(delta):
	on_ladder = ladder_detector.get_overlapping_bodies().size() > 0
	on_wall = walldetector.get_overlapping_bodies().size() > 0

	if Input.is_action_just_pressed("attack"):
		perform_attack()
		return

	if on_ladder:
		handle_ladder_input()
	else:
		handle_movement_input(delta)

func handle_ladder_input():
	if Input.is_action_pressed("ui_up"):
		velocity.y = -move_speed
		animation_player.play("Climb")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = move_speed
		animation_player.play("Climb")
	else:
		velocity.y = 0
		animation_player.play("Animation_Idle")

	velocity.x = 0

func handle_movement_input(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = move_speed
		anim.scale.x = 1  # Повернуть вправо
		animation_player.play("Walk")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -move_speed
		anim.scale.x = -1  # Повернуть влево
		animation_player.play("Walk")
	else:
		velocity.x = 0
		animation_player.play("Idle")

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
		animation_player.play("Jump")

	if not is_on_floor():
		velocity.y += gravity * delta  # Гравитация
		if velocity.y > 0:
			if on_wall:
				velocity.y = slide_speed
				animation_player.play("WallSlide")
			else:
				animation_player.play("Fall")

	if on_wall and velocity.y > 0 and not is_on_floor():
		velocity.y = slide_speed
		animation_player.play("WallSlide")

func perform_attack():
	is_attacking = true
	animation_player.play("Attack")
	$AttackTimer.start(attack_duration)

func _on_AttackArea_body_entered(body):
	if is_attacking and body.is_in_group("Enemy"):
		body.take_damage(attack_damage)

func _on_AttackTimer_timeout():
	is_attacking = false
	animation_player.play("Idle")
