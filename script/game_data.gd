class_name GameData
extends Object

#PlayerResource
@export var money : float
@export var exp : float

#LootboxInventory
@export var lootboxGenerator : Dictionary

#Inventory
@export var inventoryItem : Dictionary

#Exploration
@export var explorationArea : Dictionary
@export var teamSize : Array[int]

func _init() -> void:
	money = 0
	exp = 200
	
	lootboxGenerator = {
		"L1T1": {
			1: {"Amount": 10}
		}
	}
	
	inventoryItem = {
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
		
func update_lootbox_generator(pGen : Dictionary) -> void:
	for gen in pGen:
		var splitId : PackedStringArray = gen.split("_")
		var genNum : int
		
		if not lootboxGenerator.has(splitId[0]):
			lootboxGenerator[splitId[0]] = {}
			
		if splitId.size() < 2 or not lootboxGenerator[splitId[0]].has(int(splitId[1])):
			genNum = lootboxGenerator[splitId[0]].size() + 1
			
			LootboxInventory.ref.add_generator(str(splitId[0], "_", genNum), pGen[gen])
		else:
			genNum = int(splitId[1])
			
		lootboxGenerator[splitId[0]][genNum] = pGen[gen]
		
func update_inventory_item(pItem : Dictionary) -> void:
	for item in pItem:
		if not inventoryItem.has(item):
			inventoryItem[item] = 0
		Inventory.ref.add_item(item, pItem[item])
		
func update_inventory_item_amount(pItemId : String, pAmount : int = -inventoryItem[pItemId] if inventoryItem.has(pItemId) else 0) -> bool:
	if not inventoryItem.has(pItemId):
		inventoryItem[pItemId] = 0
	
	if inventoryItem[pItemId] >= -pAmount:
		var nodeRef : Node = Inventory.ref.get_item_node_ref(pItemId)
		
		inventoryItem[pItemId] += pAmount
		
		if nodeRef:
			nodeRef.update_amount_display(pAmount)
		
		return true
	else:
		return false
		
func update_exploration_area(pArea : Dictionary) -> void:
	for area in pArea:
		if not explorationArea.has(area):
			Exploration.ref.add_area(area, pArea[area])
		explorationArea[area] = pArea[area]
		
func update_team_size(pTeamSize : Array[int]) -> void:
	teamSize[0] += pTeamSize[0]
	teamSize[1] += pTeamSize[1]
	
	Exploration.ref.update_exploration_stat(teamSize)
