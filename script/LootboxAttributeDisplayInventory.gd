extends "res://script/LootboxAttributeDisplay.gd"

func update_display(pData : Dictionary) -> void:
	super(pData)
	
	if not pData.is_empty():
		boxAmount.text = str("[b]Amount: [/b]", "0")

func update_amount_display(pAmount : int) -> void:
	boxAmount.text = str("[b]Amount: [/b]", String.num_scientific(pAmount))
