extends VBoxContainer

var NORMALUNIT : PackedScene = preload("res://scene/normal_unit.tscn")

var data : Dictionary

func add_unit(pId : String) -> void:
	if not data.has(pId):
		var normalUnit : Node = NORMALUNIT.instantiate()
		var index : int = 1
		var spotFound : bool = false
		var splitUnitName : PackedStringArray = pId.right(-1).split("S")
		var unitData : Dictionary = GlobalData.ref.get_unit_stat_data_copy(pId)
		
		while (index < get_child_count() and not spotFound):
			var nodePower : float = get_child(index).get_power()
			var splitNodeName : PackedStringArray = get_child(index).id.right(-1).split("S")
			
			# Sort by power first then sort by rarity and id
			# Move index if the node at current position is of higher rarity or same rarity but higher id
			if (unitData["Power"] > nodePower or 
				(abs(unitData["Power"] - nodePower) < 0.00001 and 
				(int(splitUnitName[0]) > int(splitNodeName[0]) or 
				(int(splitUnitName[0]) == int(splitNodeName[0]) and 
				int(splitUnitName[1]) > int(splitNodeName[1]))))):
				spotFound = true
			else:
				index += 1
		
		normalUnit.id = pId
		add_child(normalUnit)
		move_child(normalUnit, index)
		normalUnit.set_data(unitData)
		
		data[pId] = normalUnit
			
func get_power_by_amount(pAmount : int) -> float:
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
