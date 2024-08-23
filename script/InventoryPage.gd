extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@onready var inventoryList = %InventoryList

var LOOTBOXITEM = preload("res://scene/lootbox_item.tscn")
var NORMALITEM = preload("res://scene/normal_item.tscn")

var data = {}

func add_item(pId : String, pAmount : int) -> void:
	var item : Node
	var itemData : Dictionary
	
	if not data.has(pId):
		if pId.begins_with("L"):
			item = LOOTBOXITEM.instantiate()
			itemData = globalData.get_lootbox_gen_data_copy(pId)
		else:
			item = NORMALITEM.instantiate()
			itemData = globalData.get_item_stat_data_copy(pId)
		
		item.data = itemData
		inventoryList.add_child(item)
		
		data[pId] = item
	else:
		item = data[pId]
		
	item.update_amount(pAmount)
	
func get_item_node_ref(pId : String) -> Node:
	if data.has(pId):
		return data[pId]
	return null
