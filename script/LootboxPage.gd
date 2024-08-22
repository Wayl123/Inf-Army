extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@onready var lootboxList = %LootboxList

var LOOTBOXGENERATOR = preload("res://scene/lootbox_generator.tscn")

func _ready() -> void:
	_get_saved_generator()

func _get_saved_generator() -> void:
	# To be changed to get from save file
	_add_generator("L1T1")

func _add_generator(pGen : String) -> void:
	# Might need to change input type later on, still need to decide on how I want to store generator data
	var lootboxGen = LOOTBOXGENERATOR.instantiate()
	
	lootboxGen.boxId = pGen
	lootboxGen.data = globalData.get_lootbox_gen_data_copy(pGen)
	lootboxList.add_child(lootboxGen)
