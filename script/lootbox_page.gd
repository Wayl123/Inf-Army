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
	var savedGen : Dictionary = GlobalData.ref.gameData.lootboxGenerator.duplicate(true)
	
	for gen in savedGen:
		savedGen[gen]["SavedId"] = gen
		_add_generator_node(savedGen[gen])
		
func _add_generator_node(pGen : Dictionary) -> void:
	var lootboxGen : Node = LOOTBOXGENERATOR.instantiate()
	
	lootboxGen.savedId = pGen["SavedId"]
	lootboxGen.data = GlobalData.ref.get_lootbox_gen_data_copy(pGen["Id"])
	lootboxList.add_child(lootboxGen)

func add_generator(pId : String) -> void:
	var genNode : Dictionary = {
		"Id": pId,
		"SavedId": str(ResourceUID.create_id())
	}
	
	GlobalData.ref.gameData.add_lootbox_generator(genNode)
	
	_add_generator_node(genNode)
		
func update_saved_data() -> void:
	for gen in lootboxList.get_children():
		gen.update_generator_saved_data()
