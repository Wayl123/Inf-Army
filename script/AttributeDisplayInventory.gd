extends "res://script/AttributeDisplay.gd"

@onready var amount = %Amount

func set_display(pData : Dictionary) -> void:
	super(pData)
	
	if not pData.is_empty():
		amount.text = str("[b]Amount: [/b]", "0")

func update_stored_amount(pAmount : int) -> void:
	amount.text = str("[b]Amount: [/b]", pAmount)
