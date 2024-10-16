extends HFlowContainer

var SHOPITEM : PackedScene = preload("res://scene/shop_item.tscn")

var data : Dictionary

func _ready() -> void:
	_update_shop_item()

func _update_shop_item() -> void:
	for item in data:
		var shopItem : Node = SHOPITEM.instantiate()
	
		shopItem.data["Id"] = item
		shopItem.data["Name"] = GlobalData.ref.get_unit_stat_data_copy(item)["Name"]
		shopItem.data["Cost"] = data[item]
		
		add_child(shopItem)
		
		shopItem.update_display()

		shopItem.connect("item_purchased", Callable(self, "update_shop_cost"))

func update_shop_cost() -> void:
	for item in get_children():
		item.update_cost_display()
