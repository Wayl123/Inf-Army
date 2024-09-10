class_name GameData
extends Resource

#PlayerResource
@export var money : float
@export var exp : float

#Exploration
@export var explorationArea : Dictionary
@export var teamSize : Array[int]

func _init() -> void:
	money = 0
	exp = 200
	
	explorationArea = {
		"C1A1": {}
	}
	teamSize = [1, 10]

func update_money(pMoneyDelta : float) -> bool:
	if money >= -pMoneyDelta:
		money += pMoneyDelta
		
		PlayerResource.ref.update_display()
		
		return true
	else:
		return false
		
func update_exp(pExpDelta : float) -> bool:
	if exp >= -pExpDelta:
		exp += pExpDelta
		
		PlayerResource.ref.update_display()
		
		return true
	else:
		return false
		
func update_exploration_area(pAreaDelta : Dictionary) -> void:
	for area in pAreaDelta:
		if not explorationArea.has(area):
			Exploration.ref.add_area(area)
		explorationArea[area] = pAreaDelta[area]
		
func update_team_size(pTeamSizeDelta : Array[int]) -> void:
	teamSize[0] += pTeamSizeDelta[0]
	teamSize[1] += pTeamSizeDelta[1]
	
	Exploration.ref.update_exploration_stat(teamSize)
