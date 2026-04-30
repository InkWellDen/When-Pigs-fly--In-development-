extends Node2D

@export var speed: float = 250.0

var debug_id: int = 0
var debug_timer: float = 0.0

func _ready() -> void:
	debug_id = randi() % 10000
	print("APPLE READY id=", debug_id, " global_pos=", global_position)

func _process(delta: float) -> void:
	position.x += speed * delta

	debug_timer += delta
	if debug_timer >= 1.0:
		debug_timer = 0.0
		print("APPLE id=", debug_id, " pos=", global_position)

	if position.x > 1400:
		print("APPLE id=", debug_id, " despawned right")
		queue_free()

func _on_area_2d_body_entered(body: Node) -> void:
	print("APPLE id=", debug_id, " collided with ", body.name)
	$Sprite2D.hide()
	# queue_free()
