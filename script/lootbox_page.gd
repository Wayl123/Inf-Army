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
	var savedGen = GlobalData.ref.gameData.lootboxGenerator
	
	for gen in savedGen:
		for genNum in savedGen[gen]:
			add_generator(str(gen, "_", genNum), savedGen[gen][genNum])

func add_generator(pGen : String, pSavedData : Dictionary = {}) -> void:
	var lootboxGen : Node = LOOTBOXGENERATOR.instantiate()
	var splitId : PackedStringArray = pGen.split("_")
	
	lootboxGen.id = pGen
	lootboxGen.data = GlobalData.ref.get_lootbox_gen_data_copy(splitId[0])
	lootboxList.add_child(lootboxGen)
	if not pSavedData.is_empty():
		lootboxGen.load_saved_data(pSavedData)
		
func update_saved_data() -> void:
	for gen in lootboxList.get_children():
		gen.update_generator_saved_data()
