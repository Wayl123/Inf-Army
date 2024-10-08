extends Control

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	
func _on_viewport_size_changed() -> void:
	_update_size()

func _update_size():
	pass
