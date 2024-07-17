extends VBoxContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var HEROUNIT = preload("res://scene/hero_unit.tscn")

var unitsData = {}

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		for i in range(pUnits[unit]):
			var heroUnit = HEROUNIT.instantiate()
			var unitData = globalData.get_unit_stat_data_copy(unit)
			
			add_child(heroUnit)
			move_child(heroUnit, 0)
			
			heroUnit.set_data(unitData)
			
			unitsData[unit] = heroUnit
