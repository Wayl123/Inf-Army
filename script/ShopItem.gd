extends PanelContainer

@onready var itemName = %ItemName
@onready var itemCost = %ItemCost

var data = {}
	
func set_display():
	itemName = data["Name"]
