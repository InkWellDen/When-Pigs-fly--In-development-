extends Node2D

@export var speed: float = 250.0

var debug_id: int = 0
var debug_timer: float = 0.0

func _ready() -> void:
	debug_id = randi() % 10000
	print("APPLE READY id=", debug_id, " global_pos=", global_position)

	# Make sure the signal is connected to the correct function
	if not $Area2D.body_entered.is_connected(_on_Area2D_body_entered):
		$Area2D.body_entered.connect(_on_Area2D_body_entered)

func _process(delta: float) -> void:
	position.x += speed * delta

	debug_timer += delta
	if debug_timer >= 1.0:
		debug_timer = 0.0
		print("APPLE id=", debug_id, " pos=", global_position)

	if position.x > 1400:
		print("APPLE id=", debug_id, " despawned right")
		queue_free()

func _on_Area2D_body_entered(body):
	print("APPLE COLLISION:", body.name)

	if body.name == "Player":
		$Sprite2D.hide()
		$Area2D/CollisionShape2D.disabled = true
		Game.add_apple(1)
		await get_tree().create_timer(0.1).timeout
		queue_free()
