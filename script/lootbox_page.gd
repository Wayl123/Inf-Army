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
	var savedGen : Dictionary = GlobalData.ref.gameData.lootboxGenerator
	
	for gen in savedGen:
		add_generator(savedGen[gen])
		
func add_generator(pGen : Dictionary) -> void:
	var lootboxGen : Node = LOOTBOXGENERATOR.instantiate()
	
	lootboxGen.savedId = pGen["SavedId"]
	lootboxGen.data = GlobalData.ref.get_lootbox_gen_data_copy(pGen["Id"])
	lootboxList.add_child(lootboxGen)
