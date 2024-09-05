extends "res://script/resizer.gd"
	
func _update_size() -> void:
	var viewportSize : Vector2 = get_viewport().size
	
	size = Vector2(viewportSize.x, 32)
	position = Vector2.ZERO
