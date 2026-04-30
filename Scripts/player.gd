extends CharacterBody2D

# --- GAME STATE ---
var game_started := false
var float_timer := 0.0
var start_y := 0.0

# --- MOVEMENT CONSTANTS ---
const SPEED = 490.0
var input_cooldown := 0.50
var was_colliding := false

# --- READY: STORE START POSITION ---
func _ready() -> void:
	start_y = position.y

# --- MAIN PHYSICS LOOP ---
func _physics_process(delta: float) -> void:

	# --- FLOATING PHASE BEFORE GAME STARTS ---
	if not game_started:
		float_timer += delta
		position.y = start_y + sin(float_timer * 2.0) * 10.0

		# --- START GAME ON ANY KEY PRESS ---
		if Input.is_anything_pressed():
			game_started = true
			get_tree().current_scene.get_node("StartLabel").visible = false

			# --- START APPLE SPAWNING ---
			get_tree().current_scene.get_node("AppleSpawner").start_spawning()

			# --- RANDOM LAUNCH ANGLE ---
			var angle = randf() * TAU
			velocity = Vector2(cos(angle), sin(angle)) * SPEED

		return

	# --- INPUT COOLDOWN ---
	input_cooldown -= delta

	# --- COLLISION + BOUNCE ---
	var collision = move_and_collide(velocity * delta)
	var is_colliding := collision != null

	if is_colliding:
		var normal = collision.get_normal()

		# --- PUSH OFF WALL ON FIRST HIT ---
		if not was_colliding:
			global_position += normal * 1.0

		# --- BOUNCE + DAMPING ---
		velocity = velocity.bounce(normal) * 0.9

		# --- STOP MICRO-JITTER ---
		if abs(velocity.x) < 5:
			velocity.x = 0
		if abs(velocity.y) < 5:
			velocity.y = 0

		# --- PARTICLES ON WALL HIT ---
		$WallParticles.restart()

		input_cooldown = 0.15

	# --- UPDATE COLLISION MEMORY ---
	was_colliding = is_colliding

	# --- INPUT: LEFT/RIGHT ---
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and input_cooldown <= 0.0:
		velocity.x = direction * SPEED

	# --- INPUT: UP/DOWN ---
	direction = Input.get_axis("ui_up", "ui_down")
	if direction and input_cooldown <= 0.0:
		velocity.y = direction * SPEED

	# --- ROTATION + SPRITE FLIP ---
	if velocity.length() > 5:
		var target_angle = velocity.angle()

		if abs(velocity.x) > abs(velocity.y):
			rotation = lerp_angle(rotation, 0, delta * 10)
			$Sprite2D.flip_h = velocity.x < 0
		else:
			rotation = lerp_angle(rotation, target_angle, delta * 10)
			$Sprite2D.flip_h = false
