extends Node

var apples: int = 0

signal apples_changed(new_total: int)

func _ready() -> void:
	apples = 0

func add_apple(amount: int = 1) -> void:
	apples += amount
	print("Apples:", apples)
	emit_signal("apples_changed", apples)

func reset() -> void:
	apples = 0
	emit_signal("apples_changed", apples)
