extends Node

signal apples_changed(new_count: int)

var apples: int = 0

func add_apple(count: int = 1) -> void:
	apples += count
	emit_signal("apples_changed", apples)

func reset() -> void:
	apples = 0
	emit_signal("apples_changed", apples)
