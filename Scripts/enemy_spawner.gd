extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 4.0

var timer: Timer

var current_speed: float = 350.0
var speed_increase: float = 5.0
var max_speed: float = 600.0

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_spawn_enemy)
	timer.start()

func start_spawning() -> void:
	if timer:
		timer.start()

func stop_spawning() -> void:
	if timer:
		timer.stop()

func _spawn_enemy() -> void:
	if get_tree().get_nodes_in_group("wolves").size() > 0:
		return

	var e = enemy_scene.instantiate()
	add_child(e)
	e.add_to_group("wolves")

	e.speed = current_speed

	current_speed += speed_increase
	if current_speed > max_speed:
		current_speed = max_speed

	e.global_position = Vector2(1200, randf_range(150, 500))
