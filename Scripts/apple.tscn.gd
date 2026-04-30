extends Label

func _ready() -> void:
	# Update immediately on start
	text = "Apples: %d" % Game.apples_collected

	# Listen for changes
	if not Game.apples_changed.is_connected(_on_apples_changed):
		Game.apples_changed.connect(_on_apples_changed)

func _on_apples_changed(new_count: int) -> void:
	text = "Apples: %d" % new_count
