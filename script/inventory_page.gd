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
	
func _get_saved_item() -> void:
	var savedItem : Array = GlobalData.ref.gameData.inventoryItem.keys()
	
	for item in savedItem:
		add_item(item)

func add_item(pId : String) -> void:
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
	
func get_item_node_ref(pId : String) -> Node:
	if data.has(pId):
		return data[pId]
	return null
