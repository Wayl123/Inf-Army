extends PanelContainer

@onready var heroUnitList = %HeroUnitList
@onready var normalUnitList = %NormalUnitList

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

func get_power_by_amount(pAmounts : Array) -> int:
	var power = 0
	
	power += normalUnitList.get_power_by_amount(pAmounts[1])
	
	return power
