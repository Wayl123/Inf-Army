extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var explorationStat = %ExplorationStat
@onready var explorationAreaList = %ExplorationAreaList

var EXPLORATIONAREA = preload("res://scene/exploration_area.tscn")

var teamSize = [0, 0]
var explorationPower = 0

func _ready() -> void:
	# To be changed to get from save file
	_get_saved_area()
	_update_exploration_stat([1, 10])
	
func _get_saved_area() -> void:
	# To be changed to get from save file
	_add_area("C1A1")
	
func _add_area(pArea : String) -> void:
	var explorationArea = EXPLORATIONAREA.instantiate()
	
	explorationArea.data = globalData.get_exploration_area_data_copy(pArea)
	explorationAreaList.add_child(explorationArea)
	explorationArea.update_claim_amount(explorationPower)
	
func _update_exploration_stat(pTeamSize : Array) -> void:
	if pTeamSize[0] != teamSize[0]:
		teamSize[0] = pTeamSize[0]
		explorationStat.update_hero_cap(teamSize[0])
	if pTeamSize[1] != teamSize[1]:
		teamSize[1] = pTeamSize[1]
		explorationStat.update_normal_unit_cap(teamSize[1])
	update_exploration_power()
	
func update_exploration_power() -> void:
	explorationPower = unitInventory.get_power_by_amount(teamSize)
	explorationStat.update_exploration_power(explorationPower)
	
	for area in explorationAreaList.get_children():
		area.update_claim_amount(explorationPower)
