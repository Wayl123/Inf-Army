extends "res://script/AttributeDisplay.gd"

@onready var amount = %Amount
@onready var open1Button = %Open1
@onready var open10Button = %Open10
@onready var openAllButton = %OpenAll

func set_display(pData : Dictionary) -> void:
	super(pData)
	
	if not pData.is_empty():
		amount.text = str("[b]Amount: [/b]", "0")

func update_stored_amount(pAmount : int) -> void:
	amount.text = str("[b]Amount: [/b]", pAmount)
		
func open_box(pAmount : int, pStack : bool) -> void:
	pass
