extends CharacterBody2D

var speed: float = 350.0   # this gets set by the spawner

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()

	if global_position.x < -200:
		remove_from_group("wolves")
		queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		remove_from_group("wolves")
		queue_free()
