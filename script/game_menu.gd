extends MenuButton

func _ready() -> void:
	get_popup().connect("index_pressed", Callable(self, "_menu_select"))
	
func _menu_select(index : int) -> void:
	var itemName = get_popup().get_item_text(index)
	match itemName:
		"Save":
			GlobalData.ref.save_game_data()
		"Load":
			print_debug("Currently save file is only loaded on game start")
