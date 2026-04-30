extends Node2D

@export var apple_scene: PackedScene
@export var spawn_x: float = 1138.0
@export var min_y: float = 138.0
@export var max_y: float = 512.0
@export var spawn_interval: float = 2.5

var spawn_timer: Timer

func _ready() -> void:
	if apple_scene == null:
		push_error("Spawner: apple_scene not assigned in Inspector")

	spawn_timer = get_node_or_null("SpawnTimer") as Timer
	if spawn_timer == null:
		spawn_timer = Timer.new()
		spawn_timer.name = "SpawnTimer"
		spawn_timer.wait_time = spawn_interval
		spawn_timer.one_shot = false
		add_child(spawn_timer)

	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	print("SPAWNER ready; spawn interval=", spawn_interval)
	# Do NOT call start_spawning() here


func start_spawning() -> void:
	if spawn_timer == null:
		push_error("Spawner: spawn_timer missing")
		return
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()
	print("SPAWNER start_spawning called")


func stop_spawning() -> void:
	if spawn_timer:
		spawn_timer.stop()
		print("SPAWNER stop_spawning called")


func _on_spawn_timer_timeout() -> void:
	if apple_scene == null:
		return

	var apple = apple_scene.instantiate()
	var container: Node = get_node_or_null("Pickups")
	if container == null:
		container = self
	container.add_child(apple)

	apple.global_position = Vector2(spawn_x, randf_range(min_y, max_y))

	if "speed" in apple:
		apple.speed = -abs(apple.speed)

	apple.scale.x = abs(apple.scale.x)
	apple.scale.y = abs(apple.scale.y)

	print("SPAWNER instantiated apple at", apple.global_position, " parent=", container.name, " parent_scale=", container.scale)
