extends "res://script/Resizer.gd"
	
func _update_size() -> void:
	var viewportSize = get_viewport().size
	size = Vector2(viewportSize.x, 32)
	position = Vector2.ZERO
