extends Node2D

@export var speed: float = 200.0

func _process(delta: float) -> void:
	position.x -= speed * delta
	
	# Despawn when off-screen
	if position.x < -100:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Sprite2D.hide()
	queue_free()    # remove apple after collecting
