extends Button

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@onready var display = %AttributeDisplay

var boxType : String
var data = {}

func _ready() -> void:
	connect("pressed", Callable(self, "_claim_lootbox"))
	
	if boxType:
		data = globalData.get_lootbox_gen_data_copy(boxType)
		
		display.set_display(data)
	
func _claim_lootbox() -> void:
	print_debug(display.get_and_empty_stored_amount())
