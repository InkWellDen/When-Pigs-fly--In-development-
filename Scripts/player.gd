extends CharacterBody2D

var game_started := false
var float_timer := 0.0
var start_y := 0.0

const SPEED = 490.0
var input_cooldown := 0.50
var was_colliding := false

func _ready() -> void:
	start_y = position.y

func _physics_process(delta: float) -> void:
	if not game_started:
		float_timer += delta
		position.y = start_y + sin(float_timer * 2.0) * 10.0

		if Input.is_anything_pressed():
			game_started = true
			get_tree().current_scene.get_node("StartLabel").visible = false

			var angle = randf() * TAU
			velocity = Vector2(cos(angle), sin(angle)) * SPEED

		return

	input_cooldown -= delta

	var collision = move_and_collide(velocity * delta)
	var is_colliding := collision != null

	if is_colliding:
		var normal = collision.get_normal()

		if not was_colliding:
			global_position += normal * 1.0

		velocity = velocity.bounce(normal) * 0.9

		if abs(velocity.x) < 5:
			velocity.x = 0
		if abs(velocity.y) < 5:
			velocity.y = 0

		# --- PARTICLES ON WALL HIT ---
		$WallParticles.restart()

		input_cooldown = 0.15

	was_colliding = is_colliding

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and input_cooldown <= 0.0:
		velocity.x = direction * SPEED

	direction = Input.get_axis("ui_up", "ui_down")
	if direction and input_cooldown <= 0.0:
		velocity.y = direction * SPEED

	if velocity.length() > 5:
		var target_angle = velocity.angle()

		if abs(velocity.x) > abs(velocity.y):
			rotation = lerp_angle(rotation, 0, delta * 10)
			$Sprite2D.flip_h = velocity.x < 0
		else:
			rotation = lerp_angle(rotation, target_angle, delta * 10)
			$Sprite2D.flip_h = false
