class_name Inventory
extends PanelContainer

static var ref : Inventory

@onready var inventoryList : Node = %InventoryList

var LOOTBOXITEM : PackedScene = preload("res://scene/lootbox_item.tscn")
var NORMALITEM : PackedScene = preload("res://scene/normal_item.tscn")

var data : Dictionary

func _enter_tree() -> void:
	if not ref: ref = self
	
func _ready() -> void:
	_get_saved_item()
	
	GlobalData.ref.gameData.update_inventory_item_amount("P1", 1)
	
func _get_saved_item() -> void:
	var savedItem = GlobalData.ref.gameData.inventoryItem
	
	for item in savedItem:
		add_item(item)

func add_item(pId : String, pAmount : int = 0) -> void:
	var item : Node
	var itemData : Dictionary
	
	if not data.has(pId):
		if pId.begins_with("L"):
			item = LOOTBOXITEM.instantiate()
			itemData = GlobalData.ref.get_lootbox_gen_data_copy(pId)
		else:
			item = NORMALITEM.instantiate()
			itemData = GlobalData.ref.get_item_stat_data_copy(pId)
		
		item.id = pId
		item.data = itemData
		inventoryList.add_child(item)
		
		data[pId] = item
	else:
		item = data[pId]
		
	GlobalData.ref.gameData.update_inventory_item_amount(pId, pAmount)
	
func get_item_node_ref(pId : String) -> Node:
	if data.has(pId):
		return data[pId]
	return null
