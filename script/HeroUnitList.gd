extends VBoxContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var HEROUNIT = preload("res://scene/hero_unit.tscn")

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		for i in range(pUnits[unit]):
			var heroUnit = HEROUNIT.instantiate()
			var unitData = globalData.get_unit_stat_data_copy(unit)
			
			add_child(heroUnit)
			move_child(heroUnit, 0)
			
			heroUnit.set_data(unitData)

func get_power_by_amount(pAmount : int) -> int:
	var heroUnits = get_children()
	
	if pAmount >= heroUnits.size():
		return heroUnits.reduce(func(a, b) : return a + b.get_power(), 0)
	else:
		heroUnits.sort_custom(func(a, b) : return a.get_power() > b.get_power())
		heroUnits.resize(pAmount)
		return heroUnits.reduce(func(a, b) : return a + b.get_power(), 0)
