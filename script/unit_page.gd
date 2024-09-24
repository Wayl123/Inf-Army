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
	
	_get_saved_unit()
	
func _get_saved_unit() -> void:
	var savedNormalUnitKey : Array = GlobalData.ref.gameData.normalUnit.keys()
	var savedNormalUnit : Dictionary
	var savedHeroUnit : Dictionary = GlobalData.ref.gameData.heroUnit.duplicate(true)
	
	for key in savedNormalUnitKey:
		savedNormalUnit[key] = 0
	
	normalUnitList.add_unit(savedNormalUnit)
	
	for unit in savedHeroUnit:
		savedHeroUnit[unit]["SavedId"] = unit
		heroUnitList.add_unit_node(savedHeroUnit[unit])
	
func _expand_unit_shop() -> void:
	if not shopExpanded:
		unitShop.size_flags_vertical = SIZE_EXPAND_FILL
	else:
		unitShop.size_flags_vertical = SIZE_FILL
		
	shopExpanded = not shopExpanded
	unitShop.visible = shopExpanded

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
