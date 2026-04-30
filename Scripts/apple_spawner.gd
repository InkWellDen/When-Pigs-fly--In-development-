extends Node2D

# ---------------------------------------------------------
# Apple Spawner Script
# Spawns apples at X = 1138 and Y between 138 and 512
# ---------------------------------------------------------

@export var spawn_x: float = 1138
@export var min_y: float = 138
@export var max_y: float = 512

# Time between spawns
@export var spawn_interval: float = 1.0

# Apple scene to instantiate
@export var apple_scene: PackedScene

# Timer reference
@onready var timer := $Timer

# ---------------------------------------------------------
# Start the spawning process
# ---------------------------------------------------------
func start_spawning() -> void:
	timer.wait_time = spawn_interval
	timer.start()

# ---------------------------------------------------------
# Timer timeout → spawn an apple
# ---------------------------------------------------------
func _on_Timer_timeout() -> void:
	spawn_apple()

# ---------------------------------------------------------
# Spawn a single apple at the defined X and random Y
# ---------------------------------------------------------
func spawn_apple() -> void:
	if apple_scene == null:
		push_error("AppleSpawner: apple_scene is not assigned!")
		return

	var apple = apple_scene.instantiate()

	# Add apple to the current scene
	get_tree().current_scene.add_child(apple)

	# Set spawn position
	var spawn_position := Vector2(
		spawn_x,
		randf_range(min_y, max_y)
	)

	apple.global_position = spawn_position

	# Debug print (optional)
	print("Spawned apple at:", spawn_position)

# ---------------------------------------------------------
# Optional: stop spawning if needed
# ---------------------------------------------------------
func stop_spawning() -> void:
	if timer:
		timer.stop()

# ---------------------------------------------------------
# Optional: reset spawner state
# ---------------------------------------------------------
func reset_spawner() -> void:
	if timer:
		timer.stop()
		timer.wait_time = spawn_interval
