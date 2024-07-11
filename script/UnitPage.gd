extends PanelContainer

@onready var heroList = %HeroList
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
			
	heroList.add_unit(heroUnits)
	normalUnitList.add_unit(normalUnits)
