extends "res://script/InventoryItem.gd"

@onready var itemName = %ItemName
@onready var itemImage = %ItemImage
@onready var itemStat = %ItemStat
@onready var itemAmount = %Amount

func _ready() -> void:
	_set_display()
	
func _set_display():
	itemName.text = str("[b]", data["Name"], "[/b]")
	#itemImage
	itemStat.text = str("[b]Power: [/b]", data["Power"], "\n")
	if data.has("SpecialEffect"):
		itemStat.text += str("[b]Special Effect[/b]\n")
		for effect in data["SpecialEffect"]:
			itemStat.text += str(effect, "\n")

func _update_amount_display() -> void:
	itemAmount.text = str("[b]Amount: [/b]", String.num_scientific(amount))
