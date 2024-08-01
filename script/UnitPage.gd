extends PanelContainer

@onready var exploration = get_tree().get_first_node_in_group("Exploration")

@onready var heroUnitList = %HeroUnitList
@onready var normalUnitList = %NormalUnitList
@onready var unitShopToggle = %UnitShopToggle
@onready var unitShop = %UnitShop

var shopExpanded = false

func _ready() -> void:
	unitShopToggle.connect("pressed", Callable(self, "_expand_unit_shop"))
	
func _expand_unit_shop() -> void:
	if not shopExpanded:
		unitShop.size_flags_vertical = SIZE_EXPAND_FILL
	else:
		unitShop.size_flags_vertical = SIZE_FILL
		
	shopExpanded = not shopExpanded

func add_unit(pUnits : Dictionary) -> void:
	var heroUnits = {}
	var normalUnits = {}
	
	for unit in pUnits:
		if unit.begins_with("H"):
			heroUnits[unit] = pUnits[unit]
		else:
			normalUnits[unit] = pUnits[unit]
			
	print_debug(pUnits)
			
	heroUnitList.add_unit(heroUnits)
	normalUnitList.add_unit(normalUnits)
	
	exploration.update_exploration_power()
	unitShop.update_shop_unlocks()

func get_power_by_amount(pAmounts : Array) -> int:
	var power = 0
	
	power += heroUnitList.get_power_by_amount(pAmounts[0])
	power += normalUnitList.get_power_by_amount(pAmounts[1])
	
	return power

func get_unit_node_ref(pId : String) -> Node:
	return normalUnitList.get_unit_node_ref(pId)
