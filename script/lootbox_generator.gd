extends PanelContainer

@onready var claimButton : Node = %LootboxClaim
@onready var display : Node = %LootboxAttributeDisplay
@onready var genTimer : Node = %GeneratorTimer

var savedId : String
var gameData : Dictionary = GlobalData.ref.gameData.lootboxGenerator
var data : Dictionary

func _ready() -> void:
	genTimer.connect("timeout", Callable(self, "_update_amount").bind(1))
	claimButton.connect("pressed", Callable(self, "_claim_lootbox"))
	
	display.update_display(data)
	display.update_amount_display(gameData[savedId]["Amount"])
		
func _update_amount(pAmount : int) -> void:
	gameData[savedId]["Amount"] += pAmount
	display.update_amount_display(gameData[savedId]["Amount"])
	
func _get_and_empty_stored_amount() -> int:
	var retrievedAmount : int = gameData[savedId]["Amount"]
	
	_update_amount(-gameData[savedId]["Amount"])
	
	return retrievedAmount
	
func _claim_lootbox() -> void:
	GlobalData.ref.gameData.update_inventory_item({gameData[savedId]["Id"]: _get_and_empty_stored_amount()})
