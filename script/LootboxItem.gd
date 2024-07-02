extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@onready var display = %AttributeDisplay

var boxType : String
var data = {}

func _ready() -> void:
	if boxType:
		data = globalData.get_lootbox_gen_data_copy(boxType)
		
		display.set_display(data)
