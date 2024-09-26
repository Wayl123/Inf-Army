extends "res://script/inventory_item.gd"

@onready var itemName : Node = %ItemName
@onready var itemImage : Node = %ItemImage
@onready var itemStat : Node = %ItemStat
@onready var itemAmount : Node = %Amount

func _ready() -> void:
	_update_display()
	
func _update_display():
	itemName.text = str("[b]", data["Name"], "[/b]")
	#itemImage
	itemStat.text = str("[b]Power: [/b]", data["Power"], "\n")
	if data.has("SpecialEffect"):
		itemStat.text += str("[b]Special Effect[/b]\n")
		for effect in data["SpecialEffect"]:
			itemStat.text += str(effect, "\n")
			
	update_amount_display()

func update_amount_display() -> void:
	itemAmount.text = str("[b]Amount: [/b]", String.num_scientific(gameData[id]))
