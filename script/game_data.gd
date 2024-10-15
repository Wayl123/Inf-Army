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

@export var unitShopUnlock : Array[String]

#Exploration
@export var explorationArea : Dictionary
@export var teamSize : Array[int]
@export var maxExplore : int

func _init() -> void:
	money = 0
	exp = 20000
	
	lootboxGenerator = {
		"1": {
			"Id": "L1T1",
			"SavedId": "1",
			"Amount": 10
		}
	}
	
	inventoryItem = {
		"P1": 10
	}
	
	heroUnit = {
		"1": {
			"Id": "H3S1",
			"SavedId": "1",
			"Level": 10,
			"BasePower": 0,
			"BaseMulti": {}
		},
		"2": {
			"Id": "H4S1",
			"SavedId": "2",
			"Level": 1,
			"BasePower": 168,
			"BaseMulti": {}
		}
	}
	
	normalUnit = {
		"U4S1": 2
	}
	
	unitShopUnlock = []
	
	explorationArea = {
		"E1A1": {
			"Unlocked": true,
			"Progress": 1000,
			"Exploring": true
		}
	}
	teamSize = [1, 10]
	maxExplore = 1

#PlayerResource
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
		
#LootboxInventory
#Currently extra information send through the parameter does nothing but might make it do something later
func update_lootbox_generator(pGens : Dictionary) -> void:
	for gen in pGens:
		var savedId : String = str(ResourceUID.create_id())
		lootboxGenerator[savedId] = {
			"Id": gen,
			"SavedId": savedId,
			"Amount": 0
		}
		LootboxInventory.ref.add_generator(gen)
		
#Inventory
func update_inventory_item(pItems : Dictionary) -> void:
	for item in pItems:
		if not inventoryItem.has(item):
			inventoryItem[item] = 0
			Inventory.ref.add_item(item)
		update_inventory_item_amount(item, pItems[item])
		
	UnitInventory.ref.unitShop.update_shop_unlocks()
		
func update_inventory_item_amount(pId : String, pAmount : int = 0) -> bool:
	if (Inventory.ref.get_item_node_ref(pId) and inventoryItem.has(pId) and 
		inventoryItem[pId] >= -pAmount):
		inventoryItem[pId] += pAmount
		
		Inventory.ref.get_item_node_ref(pId).update_amount_display()
		
		return true
	else:
		return false
		
#UnitInventory
func update_unit(pUnits : Dictionary) -> void:	
	for unit in pUnits:
		if unit.begins_with("H"):
			for i in range(pUnits[unit]):
				var savedId : String = str(ResourceUID.create_id())
				heroUnit[savedId] = {
					"Id": unit,
					"SavedId": savedId,
					"Level": 1,
					"BasePower": 0,
					"BaseMulti": {}
				}
				UnitInventory.ref.heroUnitList.add_unit(heroUnit[savedId])
		else:
			if not normalUnit.has(unit):
				normalUnit[unit] = 0
				UnitInventory.ref.normalUnitList.add_unit(unit)
			update_normal_unit_amount(unit, pUnits[unit])
			
	print_debug(pUnits)
	
	Exploration.ref.update_exploration_power()
	UnitInventory.ref.update_hero_display()
		
func update_normal_unit_amount(pId : String, pAmount : int = 0) -> bool:
	if (UnitInventory.ref.get_unit_node_ref(pId) and normalUnit.has(pId) and 
		normalUnit[pId] >= -pAmount):
		normalUnit[pId] += pAmount
		
		UnitInventory.ref.get_unit_node_ref(pId).update_amount_display()
		
		return true
	else:
		return false
		
#Exploration
func update_exploration_area(pAreas : Dictionary) -> void:
	for area in pAreas:
		if not explorationArea.has(area):
			explorationArea[area] = {
				"Unlocked": false,
				"Progress": 0,
				"Exploring": false
			}
			Exploration.ref.add_area(area)
		if pAreas[area].has("Unlocked"): explorationArea[area]["Unlocked"] = pAreas[area]["Unlocked"]
		if pAreas[area].has("Progress"): explorationArea[area]["Progress"] = pAreas[area]["Progress"]
		if pAreas[area].has("Exploring"): explorationArea[area]["Exploring"] = pAreas[area]["Exploring"]
		
func update_team_size(pTeamSize : Array[int]) -> void:
	teamSize[0] += pTeamSize[0]
	teamSize[1] += pTeamSize[1]
	
	Exploration.ref.update_exploration_stat()
