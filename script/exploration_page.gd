class_name Exploration
extends PanelContainer

static var ref : Exploration

@onready var explorationStat : Node = %ExplorationStat
@onready var explorationAreaList : Node = %ExplorationAreaList

var EXPLORATIONAREA : PackedScene = preload("res://scene/exploration_area.tscn")

var explorationPower : float
var exploringCount : int = 0
var data : Dictionary

func _enter_tree() -> void:
	if not ref: ref = self

func _ready() -> void:
	_get_saved_area()
	update_exploration_stat()
	
func _get_saved_area() -> void:
	var savedArea : Array = GlobalData.ref.gameData.explorationArea.keys()
	
	for area in savedArea:
		add_area(area)
	
func add_area(pId : String) -> void:
	if not data.has(pId):
		var explorationArea : Node = EXPLORATIONAREA.instantiate()
		explorationArea.id = pId
		explorationArea.data = GlobalData.ref.get_exploration_area_data_copy(pId)
		explorationAreaList.add_child(explorationArea)
		explorationArea.update_claim_amount(explorationPower)
		
		data[pId] = explorationArea
	
func update_exploration_stat() -> void:
	explorationStat.update_unit_cap()
	update_max_explore()
	update_exploration_power()
	
func update_max_explore() -> void:
	explorationStat.update_max_explore(exploringCount)
	
func update_exploration_power() -> void:
	explorationPower = UnitInventory.ref.get_power_by_amount(GlobalData.ref.gameData.teamSize)
	explorationStat.update_exploration_power(explorationPower)
	
	for area in explorationAreaList.get_children():
		area.update_claim_amount(explorationPower)
