extends VBoxContainer

@onready var globalData : Node = get_tree().get_first_node_in_group("GlobalData")

var HEROUNIT : PackedScene = preload("res://scene/hero_unit.tscn")

var maxed : Dictionary

func _move_unit(pIndex : int, pNode : Node) -> void:
	move_child(pNode, pIndex)

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		for i in range(pUnits[unit]):
			var heroUnit : Node = HEROUNIT.instantiate()
			var index : int = 0
			var spotFound : bool = false
			var unitData : Dictionary = globalData.get_unit_stat_data_copy(unit)
			
			while (index < get_child_count() and not spotFound):
				var nodePower : float = get_child(index).get_power()
				
				if (unitData["LevelPower"] >= nodePower):
					spotFound = true
				else:
					index += 1
			
			add_child(heroUnit)
			move_child(heroUnit, index)
			
			heroUnit.set_data(unitData)
			heroUnit.connect("move_node", Callable(self, "_move_unit").bind(heroUnit))
			heroUnit.connect("unit_info_changed", Callable(self, "update_display"))
			
func update_display() -> void:
	for item in get_children():
		item.update_level_display()

func get_power_by_amount(pAmount : int) -> float:
	var heroUnits : Array[Node] = get_children()
	
	if pAmount >= heroUnits.size():
		return heroUnits.reduce(func(a, b) : return a + b.get_power(), 0)
	else:
		# List by default sorted by power
		# heroUnits.sort_custom(func(a, b) : return a.get_power() > b.get_power())
		heroUnits.resize(pAmount)
		return heroUnits.reduce(func(a, b) : return a + b.get_power(), 0)
