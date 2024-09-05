extends "res://script/Resizer.gd"
	
func _update_size() -> void:
	var viewportSize : Vector2 = get_viewport().size
	
	size = Vector2(viewportSize.x * 0.8, viewportSize.y * 0.8)
	position = Vector2(viewportSize.x * 0.1, viewportSize.y * 0.1)
