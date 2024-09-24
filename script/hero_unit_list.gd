extends VBoxContainer

var HEROUNIT : PackedScene = preload("res://scene/hero_unit.tscn")

var maxed : Dictionary

func _move_unit(pIndex : int, pNode : Node) -> void:
	move_child(pNode, pIndex)
	
func add_unit_node(pUnit : Dictionary) -> void:
	var heroUnit : Node = HEROUNIT.instantiate()
	var index : int = 0
	var spotFound : bool = false
	var savedId : String = pUnit["SavedId"]
	
	add_child(heroUnit)
	
	heroUnit.savedId = savedId
	heroUnit.set_data(GlobalData.ref.get_unit_stat_data_copy(pUnit["Id"]))
	heroUnit.connect("move_node", Callable(self, "_move_unit").bind(heroUnit))
	heroUnit.connect("unit_info_changed", Callable(self, "update_display"))
	
	while (index < get_child_count() - 1 and not spotFound):
		var nodePower : float = get_child(index).get_power()
		
		if (heroUnit.get_power() >= nodePower):
			spotFound = true
		else:
			index += 1
			
	move_child(heroUnit, index)

func add_unit(pUnits : Dictionary) -> void:
	for unit in pUnits:
		for i in range(pUnits[unit]):
			var unitNode : Dictionary = {
				"Id": unit,
				"SavedId": str(ResourceUID.create_id())
			}
			
			GlobalData.ref.gameData.add_hero_unit(unitNode)
			
			add_unit_node(unitNode)
			
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
