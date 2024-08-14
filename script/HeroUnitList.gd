extends VBoxContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var HEROUNIT = preload("res://scene/hero_unit.tscn")

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		for i in range(pUnits[unit]):
			var heroUnit = HEROUNIT.instantiate()
			var index = 0
			var spotFound = false
			var unitData = globalData.get_unit_stat_data_copy(unit)
			
			while (index < get_child_count() and not spotFound):
				var nodePower = get_child(index).get_power()
				
				if (int(unitData["LevelPower"]) >= nodePower):
					spotFound = true
				else:
					index += 1
			
			add_child(heroUnit)
			move_child(heroUnit, index)
			
			heroUnit.set_data(unitData)
			
func update_display() -> void:
	for item in get_children():
		item.update_level_display()

func get_power_by_amount(pAmount : int) -> int:
	var heroUnits = get_children()
	
	if pAmount >= heroUnits.size():
		return heroUnits.reduce(func(a, b) : return a + b.get_power(), 0)
	else:
		# List by default sorted by power
		# heroUnits.sort_custom(func(a, b) : return a.get_power() > b.get_power())
		heroUnits.resize(pAmount)
		return heroUnits.reduce(func(a, b) : return a + b.get_power(), 0)
