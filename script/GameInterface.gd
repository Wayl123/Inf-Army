extends Node2D

var lootboxGenListPath = "res://script/LootboxGeneratorTemplate.json"
var lootboxGenData = {}

func _ready() -> void:
	_load_all_data()

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
	
func get_lootbox_gen_data_copy(pId : String) -> Dictionary:
	return lootboxGenData[pId].duplicate(true)
