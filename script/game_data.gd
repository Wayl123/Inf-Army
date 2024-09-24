class_name GameData
extends Object

#PlayerResource
@export var money : float
@export var exp : float

#LootboxInventory
@export var lootboxGenerator : Dictionary

#Inventory
@export var inventoryItem : Dictionary

#UnitInventory
@export var heroUnit : Dictionary
@export var normalUnit : Dictionary

#Exploration
@export var explorationArea : Dictionary
@export var teamSize : Array[int]

func _init() -> void:
	money = 0
	exp = 20000
	
	lootboxGenerator = {
		"L1T1": {
			1: {"Amount": 10}
		}
	}
	
	inventoryItem = {
		"P1": 10
	}
	
	#heroUnit = {
		#1: {
			#"Id": "H3S1",
			#"Level": 10
		#},
		#2: {
			#"Id": "H4S1",
			#"Level": 1,
			#"BasePower": 168
		#}
	#}
	
	normalUnit = {
		"U4S1": 2
	}
	
	explorationArea = {
		"C1A1": {}
	}
	teamSize = [1, 10]

func update_money(pMoney : float) -> bool:
	if money >= -pMoney:
		money += pMoney
		
		PlayerResource.ref.update_display()
		
		return true
	else:
		return false
		
func update_exp(pExp : float) -> bool:
	if exp >= -pExp:
		exp += pExp
		
		PlayerResource.ref.update_display()
		
		return true
	else:
		return false
		
func update_lootbox_generator(pGens : Dictionary) -> void:
	for gen in pGens:
		var splitId : PackedStringArray = gen.split("_")
		var genNum : int
		
		if not lootboxGenerator.has(splitId[0]):
			lootboxGenerator[splitId[0]] = {}
			
		if splitId.size() < 2 or not lootboxGenerator[splitId[0]].has(int(splitId[1])):
			genNum = lootboxGenerator[splitId[0]].size() + 1
			
			LootboxInventory.ref.add_generator(str(splitId[0], "_", genNum), pGens[gen])
		else:
			genNum = int(splitId[1])
			
		lootboxGenerator[splitId[0]][genNum] = pGens[gen]
		
func update_inventory_item(pItems : Dictionary) -> void:
	for item in pItems:
		if not inventoryItem.has(item):
			inventoryItem[item] = 0
		Inventory.ref.add_item(item, pItems[item])
		
func update_inventory_item_amount(pId : String, pAmount : int = 0) -> bool:
	if (Inventory.ref.get_item_node_ref(pId) and inventoryItem.has(pId) and 
		inventoryItem[pId] >= -pAmount):
		inventoryItem[pId] += pAmount
		
		Inventory.ref.get_item_node_ref(pId).update_amount_display()
		
		return true
	else:
		return false
		
func update_unit(pUnits : Dictionary) -> void:
	var heroUnits : Dictionary
	var normalUnits : Dictionary
	
	for unit in pUnits:
		if unit.begins_with("H"):
			heroUnits[unit] = pUnits[unit]
		else:
			if not normalUnit.has(unit):
				normalUnit[unit] = 0
			normalUnits[unit] = pUnits[unit]
			
	print_debug(pUnits)
				
	UnitInventory.ref.heroUnitList.add_unit(heroUnits)
	UnitInventory.ref.normalUnitList.add_unit(normalUnits)
	
	Exploration.ref.update_exploration_power()
	UnitInventory.ref.update_hero_display()
	UnitInventory.ref.unitShop.update_shop_unlocks()
	
func update_new_hero_unit(heroId : String, pId : String) -> void:
	heroUnit[heroId] = {
		"Id" = pId,
		"Level" = 1,
		"BasePower" = 0,
		"BaseMulti" = {}
	}
		
func update_normal_unit_amount(pId : String, pAmount : int = 0) -> bool:
	if (UnitInventory.ref.get_unit_node_ref(pId) and normalUnit.has(pId) and 
		normalUnit[pId] >= -pAmount):
		normalUnit[pId] += pAmount
		
		UnitInventory.ref.get_unit_node_ref(pId).update_amount_display()
		
		return true
	else:
		return false
		
func update_exploration_area(pAreas : Dictionary) -> void:
	for area in pAreas:
		if not explorationArea.has(area):
			Exploration.ref.add_area(area, pAreas[area])
		explorationArea[area] = pAreas[area]
		
func update_team_size(pTeamSize : Array[int]) -> void:
	teamSize[0] += pTeamSize[0]
	teamSize[1] += pTeamSize[1]
	
	Exploration.ref.update_exploration_stat(teamSize)
