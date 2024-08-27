extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var resource = get_tree().get_first_node_in_group("Resource")
@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var unitShopList = %UnitShopList

var SHOPITEM = preload("res://scene/shop_item.tscn")

var data = {}

func _ready() -> void:
	data = globalData.get_unit_combination_data_copy()
		
func update_shop_unlocks() -> void:
	var unitRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	for item in data:
		if not data[item].has("ItemNode"):
			var shopItem = SHOPITEM.instantiate()
		
			shopItem.data["Id"] = item
			shopItem.data["Name"] = globalData.get_unit_stat_data_copy(item)["Name"]
			shopItem.data["Cost"] = data[item]
			
			unitShopList.add_child(shopItem)
			
			shopItem.set_display()
			
			data[item]["ItemNode"] = shopItem
			shopItem.connect("item_purchased", Callable(self, "update_shop_cost"))
		else:
			data[item]["ItemNode"].set_cost_display()
			
func update_shop_cost() -> void:
	for item in unitShopList.get_children():
		item.set_cost_display()
