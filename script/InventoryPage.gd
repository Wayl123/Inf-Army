extends PanelContainer

@onready var inventoryList = %InventoryList

var LOOTBOXITEM = preload("res://scene/lootbox_item.tscn")

var itemContent = {}

func add_item(pType : String, pId : String, pData : Dictionary, pAmount : int) -> void:
	if pType == "lootbox":
		if not itemContent.has(pId):
			var lootboxItem = LOOTBOXITEM.instantiate()
			
			lootboxItem.lootboxData = pData
			inventoryList.add_child(lootboxItem)
			lootboxItem.update_stored_amount(pAmount)
			
			itemContent[pId] = lootboxItem
		else:
			var lootboxItem = itemContent[pId]
			
			lootboxItem.update_stored_amount(pAmount)
