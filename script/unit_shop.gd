extends PanelContainer

@onready var unitShopList : Node = %UnitShopList

var SHOPGROUP : PackedScene = preload("res://scene/shop_group.tscn")

var data : Dictionary

func _ready() -> void:
	data = GlobalData.ref.get_unit_combination_data_copy()
	
	update_shop_unlocks()
		
func update_shop_unlocks() -> void:	
	for shop in data:
		if not GlobalData.ref.gameData.unitShopUnlock.has(shop):
			var unlock = true
			
			for item in data[shop]["Unlock"]:
				if not GlobalData.ref.gameData.inventoryItem.has(item):
					unlock = false
					break
					
			if unlock:
				GlobalData.ref.gameData.unitShopUnlock.append(shop)
		
		if GlobalData.ref.gameData.unitShopUnlock.has(shop) and not data[shop].has("Unlocked"):
			var shopGroup : Node = SHOPGROUP.instantiate()
			
			shopGroup.data = data[shop]["Content"]
			unitShopList.add_child(shopGroup)
			
			data[shop]["Unlocked"] = true
			
	update_shop_cost()
			
func update_shop_cost() -> void:
	for item in unitShopList.get_children():
		item.update_shop_cost()
