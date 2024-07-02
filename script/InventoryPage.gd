extends PanelContainer

@onready var inventoryList = %InventoryList

var LOOTBOXITEM = preload("res://scene/lootbox_item.tscn")

func _ready() -> void:	
	_get_saved_generator()

func _get_saved_generator() -> void:
	# to be changed to get from saved file
	_add_generator("A1")

func _add_generator(pGenType : String) -> void:
	# might need to change input type later on, still need to decide on how I want to store generator data
	var lootboxItem = LOOTBOXITEM.instantiate()
	
	lootboxItem.boxType = pGenType
	inventoryList.add_child(lootboxItem)
