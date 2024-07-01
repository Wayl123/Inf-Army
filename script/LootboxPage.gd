extends PanelContainer

@onready var lootboxList = %LootboxList

var LOOTBOXGENERATOR = preload("res://scene/lootbox_generator.tscn")

func _ready() -> void:	
	_get_saved_generator()

func _get_saved_generator() -> void:
	# to be changed to get from saved file
	_add_generator("A1")

func _add_generator(pGenType : String) -> void:
	# might need to change input type later on, still need to decide on how I want to store generator data
	var lootboxGen = LOOTBOXGENERATOR.instantiate()
	
	lootboxGen.boxType = pGenType
	lootboxList.add_child(lootboxGen)
