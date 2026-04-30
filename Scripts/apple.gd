extends Node2D

@export var speed: float = 250.0

var debug_id: int = 0
var debug_timer: float = 0.0

func _ready() -> void:
	debug_id = randi() % 10000
	print("APPLE READY id=", debug_id, " global_pos=", global_position)

	# Make sure the signal is connected
	if $Area2D.body_entered.is_connected(_on_body_entered) == false:
		$Area2D.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.x += speed * delta

	debug_timer += delta
	if debug_timer >= 1.0:
		debug_timer = 0.0
		print("APPLE id=", debug_id, " pos=", global_position)

	if position.x > 1400:
		print("APPLE id=", debug_id, " despawned right")
		queue_free()

func _on_body_entered(body: Node) -> void:
	print("APPLE id=", debug_id, " collided with ", body.name)

	if body.name == "Player":
		# Hide the apple visually
		$Sprite2D.hide()

		# Disable collision
		$Area2D/CollisionShape2D.disabled = true

		# Add to apple counter
		Game.add_apple(1)

		# Remove apple after short delay
		await get_tree().create_timer(0.1).timeout
		queue_free()
