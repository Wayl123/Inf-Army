extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@onready var inventoryList = %InventoryList

var LOOTBOXITEM = preload("res://scene/lootbox_item.tscn")
var NORMALITEM = preload("res://scene/normal_item.tscn")

var itemContent = {}

func add_item(pType : String, pId : String, pAmount : int) -> void:
	var item : Node
	var data : Dictionary
	
	if not itemContent.has(pId):
		if pType == "lootbox":
			item = LOOTBOXITEM.instantiate()
			data = globalData.get_lootbox_gen_data_copy(pId)
		else:
			item = NORMALITEM.instantiate()
			data = globalData.get_item_stat_data_copy(pId)
		
		item.data = data
		inventoryList.add_child(item)
		
		itemContent[pId] = item
	else:
		item = itemContent[pId]
		
	item.update_stored_amount(pAmount)
