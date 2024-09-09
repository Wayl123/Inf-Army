class_name LootboxInventory
extends PanelContainer

static var ref : LootboxInventory

@onready var lootboxList : Node = %LootboxList

var LOOTBOXGENERATOR : PackedScene = preload("res://scene/lootbox_generator.tscn")

func _enter_tree() -> void:
	if not ref: ref = self

func _ready() -> void:
	_get_saved_generator()

func _get_saved_generator() -> void:
	# To be changed to get from save file
	_add_generator("L1T1")

func _add_generator(pGen : String) -> void:
	# Might need to change input type later on, still need to decide on how I want to store generator data
	var lootboxGen : Node = LOOTBOXGENERATOR.instantiate()
	
	lootboxGen.boxId = pGen
	lootboxGen.data = GlobalData.ref.get_lootbox_gen_data_copy(pGen)
	lootboxList.add_child(lootboxGen)
