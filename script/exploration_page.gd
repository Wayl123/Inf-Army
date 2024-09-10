class_name Exploration
extends PanelContainer

static var ref : Exploration

@onready var explorationStat : Node = %ExplorationStat
@onready var explorationAreaList : Node = %ExplorationAreaList

var EXPLORATIONAREA : PackedScene = preload("res://scene/exploration_area.tscn")

var explorationPower : float

func _enter_tree() -> void:
	if not ref: ref = self

func _ready() -> void:
	# To be changed to get from save file
	_get_saved_area()
	update_exploration_stat(GlobalData.ref.gameData.teamSize)
	
func _get_saved_area() -> void:
	var savedArea = GlobalData.ref.gameData.explorationArea
	
	for area in savedArea:
		add_area(area, savedArea[area])
	
func add_area(pArea : String, pSavedData : Dictionary = {}) -> void:
	var explorationArea : Node = EXPLORATIONAREA.instantiate()
	
	explorationArea.id = pArea
	explorationArea.data = GlobalData.ref.get_exploration_area_data_copy(pArea)
	explorationAreaList.add_child(explorationArea)
	explorationArea.update_claim_amount(explorationPower)
	if not pSavedData.is_empty():
		explorationArea.update_saved_data(pSavedData)
	
func update_exploration_stat(pTeamSize : Array[int]) -> void:
	explorationStat.update_unit_cap(pTeamSize)
	update_exploration_power()
	
func update_exploration_power() -> void:
	explorationPower = UnitInventory.ref.get_power_by_amount(GlobalData.ref.gameData.teamSize)
	explorationStat.update_exploration_power(explorationPower)
	
	for area in explorationAreaList.get_children():
		area.update_claim_amount(explorationPower)
