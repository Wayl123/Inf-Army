extends Node2D

var PAGETAB = preload("res://scene/page_tab.tscn")

var lootboxGenListPath = "res://script/LootboxGeneratorTemplate.json"
var unitStatListPath = "res://script/UnitStat.json"
var explorationAreaListPath = "res://script/ExplorationAreaTemplate.json"
var lootboxGenData = {}
var unitStatData = {}
var explorationAreaData = {}

func _ready() -> void:
	_load_all_data()
	
	add_child(PAGETAB.instantiate())

func _load_json_file(filePath : String) -> Dictionary:
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")
		
	return {}
	
func _load_all_data() -> void:
	lootboxGenData = _load_json_file(lootboxGenListPath)
	unitStatData = _load_json_file(unitStatListPath)
	explorationAreaData = _load_json_file(explorationAreaListPath)
	
func get_lootbox_gen_data_copy(pId : String) -> Dictionary:
	return lootboxGenData[pId].duplicate(true)

func get_unit_stat_data_copy(pId : String) -> Dictionary:
	return unitStatData[pId].duplicate(true)

func get_exploration_area_data_copy(pId : String) -> Dictionary:
	return explorationAreaData[pId].duplicate(true)
