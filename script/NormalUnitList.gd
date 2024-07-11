extends VBoxContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var NORMALUNIT = preload("res://scene/normal_unit.tscn")

var unitsData = {}

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		if unitsData.has(unit):
			unitsData[unit].add_amount(pUnits[unit])
		else:
			var normalUnit = NORMALUNIT.instantiate()
			var index = 1
			var spotFound = false
			var splitUnitName = unit.split("S")
			
			while (index < get_child_count() and not spotFound):
				#All hero unit should not be sent here so those don't need to be considered
				var splitNodeName = get_child(index).name.split("S")
				
				#Move index if the node at current position is of higher rarity or same rarity but higher id
				if int(splitUnitName[0]) > int(splitNodeName[0]) or (int(splitUnitName[0]) == int(splitNodeName[0]) and int(splitUnitName[1]) > int(splitNodeName[1])):
					spotFound = true
				else:
					index += 1
			
			add_child(normalUnit)
			move_child(normalUnit, index)
			
			normalUnit.set_data(globalData.get_unit_stat_data_copy(unit))
			normalUnit.add_amount(pUnits[unit])
	
			normalUnit.name = unit
			
			unitsData[unit] = normalUnit
