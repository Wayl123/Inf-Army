extends PanelContainer

@onready var inventory = get_tree().get_first_node_in_group("Inventory")

@onready var claimButton = %LootboxClaim
@onready var display = %LootboxAttributeDisplay
@onready var genTimer = %GeneratorTimer

var boxId : String
var data = {}
var amount = 0

func _ready() -> void:
	genTimer.connect("timeout", Callable(self, "_update_amount").bind(1))
	claimButton.connect("pressed", Callable(self, "_claim_lootbox"))
	
	display.set_display(data)
		
func _update_amount(pAmount : int) -> void:
	amount += pAmount
	display.update_amount_display(amount)
	
func _get_and_empty_stored_amount() -> int:
	var retrievedAmount = amount
	
	_update_amount(-amount)
	
	return retrievedAmount
	
func _claim_lootbox() -> void:
	inventory.add_item(boxId, _get_and_empty_stored_amount())
