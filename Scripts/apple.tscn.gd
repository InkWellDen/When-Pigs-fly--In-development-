extends Label

func _ready() -> void:
	text = ": %d" % Game.apples

	if not Game.apples_changed.is_connected(_on_apples_changed):
		Game.apples_changed.connect(_on_apples_changed)

func _on_apples_changed(new_count: int) -> void:
	text = ": %d" % new_count
