extends VBoxContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var NORMALUNIT = preload("res://scene/normal_unit.tscn")

var data = {}

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		if data.has(unit):
			data[unit].update_amount(pUnits[unit])
		else:
			var normalUnit = NORMALUNIT.instantiate()
			var index = 1
			var spotFound = false
			var splitUnitName = unit.split("S")
			var unitData = globalData.get_unit_stat_data_copy(unit)
			
			while (index < get_child_count() and not spotFound):
				var nodePower = get_child(index).get_power()
				var splitNodeName = get_child(index).name.split("S")
				
				# Sort by power first then sort by rarity and id
				# Move index if the node at current position is of higher rarity or same rarity but higher id
				if (int(unitData["Power"]) > nodePower or 
					(int(unitData["Power"]) == nodePower and 
					(int(splitUnitName[0]) > int(splitNodeName[0]) or 
					(int(splitUnitName[0]) == int(splitNodeName[0]) and 
					int(splitUnitName[1]) > int(splitNodeName[1]))))):
					spotFound = true
				else:
					index += 1
			
			add_child(normalUnit)
			move_child(normalUnit, index)
			
			normalUnit.set_data(unitData)
			normalUnit.update_amount(pUnits[unit])
	
			normalUnit.name = unit
			
			data[unit] = normalUnit
			
func get_power_by_amount(pAmount : int) -> int:
	var power = 0
	var index = 1
	var childCount = get_child_count()
	
	while pAmount > 0 and index < childCount:
		var returnPower = get_child(index).get_power_by_amount(pAmount)
		
		power += returnPower[0]
		pAmount = returnPower[1]
		index += 1
		
	return power
	
func get_unit_node_ref(pId : String) -> Node:
	if data.has(pId):
		return data[pId]
	return null
