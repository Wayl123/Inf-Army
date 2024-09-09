class_name UnitInventory
extends PanelContainer

static var ref : UnitInventory

@onready var heroUnitList : Node = %HeroUnitList
@onready var normalUnitList : Node = %NormalUnitList
@onready var unitShopToggle : Node = %UnitShopToggle
@onready var unitShop : Node = %UnitShop

var shopExpanded : bool = false

func _enter_tree() -> void:
	if not ref: ref = self

func _ready() -> void:
	unitShopToggle.connect("pressed", Callable(self, "_expand_unit_shop"))
	
func _expand_unit_shop() -> void:
	if not shopExpanded:
		unitShop.size_flags_vertical = SIZE_EXPAND_FILL
	else:
		unitShop.size_flags_vertical = SIZE_FILL
		
	shopExpanded = not shopExpanded
	unitShop.visible = shopExpanded

func add_unit(pUnits : Dictionary) -> void:
	var heroUnits : Dictionary
	var normalUnits : Dictionary
	
	for unit in pUnits:
		if unit.begins_with("H"):
			heroUnits[unit] = pUnits[unit]
		else:
			normalUnits[unit] = pUnits[unit]
			
	print_debug(pUnits)
			
	heroUnitList.add_unit(heroUnits)
	normalUnitList.add_unit(normalUnits)
	
	Exploration.ref.update_exploration_power()
	update_hero_display()
	unitShop.update_shop_unlocks()

func get_power_by_amount(pAmounts : Array) -> float:
	var power : float = 0
	
	power += heroUnitList.get_power_by_amount(pAmounts[0])
	power += normalUnitList.get_power_by_amount(pAmounts[1])
	
	return power

func get_unit_node_ref(pId : String) -> Node:
	return normalUnitList.get_unit_node_ref(pId)
	
func update_hero_display() -> void:
	heroUnitList.update_display()
	
func update_shop_cost() -> void:
	unitShop.update_shop_cost()
