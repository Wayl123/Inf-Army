extends "res://script/lootbox_attribute_display.gd"

func update_display(pData : Dictionary, pAmount : int = 0) -> void:
	super(pData, pAmount)

func update_amount_display(pAmount : int) -> void:
	boxAmount.text = str("[b]Amount: [/b]", String.num_scientific(pAmount))
