extends Node2D

# --- APPLE SETTINGS ---
@export var apple_scene: PackedScene
@export var min_y: float = 100.0
@export var max_y: float = 550.0

# --- CALLED BY PLAYER WHEN GAME STARTS ---
func start_spawning() -> void:
	$Timer.start()

# --- SPAWN APPLE EACH TIME TIMER FIRES ---
func _on_timer_timeout() -> void:
	var apple = apple_scene.instantiate()
	apple.position = Vector2(1152, randf_range(min_y, max_y))
	get_tree().current_scene.add_child(apple)
