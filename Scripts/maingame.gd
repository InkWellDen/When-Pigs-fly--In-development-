extends Node2D

signal apples_changed(new_count: int)

var apples: int = 0
var apples_reserved: int = 0
var game_started: bool = false

@onready var player := $Player
@onready var spawner := $AppleSpawner
@onready var start_label := $StartLabel

func _ready() -> void:
	apples = 0
	apples_reserved = 0
	emit_signal("apples_changed", apples)

	# DO NOT start spawning here
	if spawner:
		spawner.stop_spawning()
	else:
		push_error("AppleSpawner node not found at path: $AppleSpawner")

func _unhandled_input(event: InputEvent) -> void:
	if game_started:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		game_started = true

		if start_label:
			start_label.hide()

		if player:
			player.start_game()

		if spawner:
			spawner.start_spawning()

func add_apple(count: int = 1) -> void:
	apples += max(0, count)
	emit_signal("apples_changed", apples)
	print("Game: apples =", apples)

func use_apple(count: int = 1) -> bool:
	count = max(0, count)
	if apples >= count:
		apples -= count
		emit_signal("apples_changed", apples)
		print("Game: used", count, "apple(s); remaining =", apples)
		return true
	return false

func reserve_apples(count: int = 1) -> bool:
	count = max(0, count)
	if apples - apples_reserved >= count:
		apples_reserved += count
		print("Game: reserved", count, "apple(s); reserved =", apples_reserved)
		return true
	return false

func release_reserved(count: int = 1) -> void:
	count = max(0, count)
	apples_reserved = max(0, apples_reserved - count)
	print("Game: released", count, "reserved; reserved =", apples_reserved)

func consume_reserved(count: int = 1) -> bool:
	count = max(0, count)
	if apples_reserved >= count and apples >= count:
		apples_reserved -= count
		apples -= count
		emit_signal("apples_changed", apples)
		print("Game: consumed", count, "reserved apples; remaining =", apples, "reserved =", apples_reserved)
		return true
	return false
