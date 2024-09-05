extends Node2D

var PAGETAB : PackedScene = preload("res://scene/page_tab.tscn")

var lootboxGenListPath : String = "res://script/lootbox_generator_template.json"
var unitStatListPath : String = "res://script/unit_stat.json"
var unitCombinationListPath : String = "res://script/unit_combination.json"
var explorationAreaListPath : String = "res://script/exploration_area_template.json"
var itemStatListPath : String = "res://script/item_stat.json"
var lootboxGenData : Dictionary
var unitStatData : Dictionary
var unitCombinationData : Dictionary
var explorationAreaData : Dictionary
var itemStatData : Dictionary

var cachePromoData : Dictionary

func _ready() -> void:
	_load_all_data()
	
	add_child(PAGETAB.instantiate())

func _load_json_file(filePath : String) -> Dictionary:
	if FileAccess.file_exists(filePath):
		var dataFile : Object = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult : Variant = JSON.parse_string(dataFile.get_as_text())
		
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
	unitCombinationData = _load_json_file(unitCombinationListPath)
	explorationAreaData = _load_json_file(explorationAreaListPath)
	itemStatData = _load_json_file(itemStatListPath)
	
func get_cache_promo_data(pId : String) -> Dictionary:
	if not cachePromoData.has(pId):
		cachePromoData[pId] = {}
	return cachePromoData[pId]
	
func get_lootbox_gen_data_copy(pId : String) -> Dictionary:
	return lootboxGenData[pId].duplicate(true)

func get_unit_stat_data_copy(pId : String) -> Dictionary:
	return unitStatData[pId].duplicate(true)
	
func get_unit_combination_data_copy() -> Dictionary:
	return unitCombinationData.duplicate(true)

func get_exploration_area_data_copy(pId : String) -> Dictionary:
	return explorationAreaData[pId].duplicate(true)
	
func get_item_stat_data_copy(pId : String) -> Dictionary:
	return itemStatData[pId].duplicate(true)
