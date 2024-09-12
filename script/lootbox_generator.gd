extends PanelContainer

@onready var claimButton : Node = %LootboxClaim
@onready var display : Node = %LootboxAttributeDisplay
@onready var genTimer : Node = %GeneratorTimer

var id : String
var data : Dictionary
var amount : int = 0

func _ready() -> void:
	genTimer.connect("timeout", Callable(self, "_update_amount").bind(1))
	claimButton.connect("pressed", Callable(self, "_claim_lootbox"))
	
	display.update_display(data)
		
func _update_amount(pAmount : int) -> void:
	amount += pAmount
	display.update_amount_display(amount)
	
func _get_and_empty_stored_amount() -> int:
	var retrievedAmount : int = amount
	
	_update_amount(-amount)
	
	return retrievedAmount
	
func _claim_lootbox() -> void:
	var splitId : PackedStringArray = id.split("_")
	
	GlobalData.ref.gameData.update_inventory_item({splitId[0]: _get_and_empty_stored_amount()})
	
func load_saved_data(pData : Dictionary) -> void:
	if pData.has("Amount"): amount = pData["Amount"]
	display.update_amount_display(amount)
	
func update_generator_saved_data() -> void:
	var genData : Dictionary
	
	genData["Amount"] = amount
	
	GlobalData.ref.gameData.update_lootbox_generator({id: genData})
