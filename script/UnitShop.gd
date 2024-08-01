extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")
@onready var resource = get_tree().get_first_node_in_group("Resource")

@onready var unitShopList = %UnitShopList

var SHOPITEM = preload("res://scene/shop_item.tscn")

var data = {}

func _ready():
	data = globalData.get_unit_combination_data_copy()
		
func update_shop_unlocks():
	var unitRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	for item in data:
		if not data[item].has("ItemNode"):
			var shopData = {}
			var unlock = true
			
			for cost in data[item]:
				if unitRegex.search(cost) != null:
					var unitNode = unitInventory.get_unit_node_ref(cost)
					
					if unitNode != null:
						var unitName = globalData.get_unit_stat_data_copy(cost)["Name"]
						shopData[unitName] = {}
						shopData[unitName]["Node"] = unitNode
						shopData[unitName]["Req"] = data[item][cost]
					else:
						unlock = false
						break
				else:
					shopData[cost] = {}
					shopData[cost]["Node"] = resource
					shopData[cost]["Req"] = data[item][cost]
				
			print_debug(shopData)
			print_debug(unlock)
				
			if unlock:
				var shopItem = SHOPITEM.instantiate()
			
				shopItem.data["Name"] = globalData.get_unit_stat_data_copy(item)["Name"]
				shopItem.data["Cost"] = shopData
				
				unitShopList.add_child(shopItem)
				
				shopItem.set_display()
				
				data[item]["ItemNode"] = shopItem
