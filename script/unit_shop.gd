extends PanelContainer

@onready var unitShopList : Node = %UnitShopList

var SHOPITEM : PackedScene = preload("res://scene/shop_item.tscn")

var data : Dictionary

func _ready() -> void:
	data = GlobalData.ref.get_unit_combination_data_copy()
		
func update_shop_unlocks() -> void:
	var unitRegex : Object = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	for item in data:
		if not data[item].has("ItemNode"):
			var shopItem : Node = SHOPITEM.instantiate()
		
			shopItem.data["Id"] = item
			shopItem.data["Name"] = GlobalData.ref.get_unit_stat_data_copy(item)["Name"]
			shopItem.data["Cost"] = data[item]
			
			unitShopList.add_child(shopItem)
			
			shopItem.update_display()
			
			data[item]["ItemNode"] = shopItem
			shopItem.connect("item_purchased", Callable(self, "update_shop_cost"))
		else:
			data[item]["ItemNode"].update_cost_display()
			
func update_shop_cost() -> void:
	for item in unitShopList.get_children():
		item.update_cost_display()
