extends "res://script/AttributeDisplay.gd"

@onready var amount = %Amount
@onready var open1Button = %Open1
@onready var open10Button = %Open10
@onready var openAllButton = %OpenAll

func _ready():
	open1Button.connect("pressed", Callable(self, "_update_stored_amount").bind(-1))
	open10Button.connect("pressed", Callable(self, "_update_stored_amount").bind(-10))
	openAllButton.connect("pressed", Callable(self, "_update_stored_amount").bind(-storedAmount))

func set_display(pData : Dictionary) -> void:
	super(pData)
	
	if not pData.is_empty():
		amount.text = str("[b]Amount: [/b]", storedAmount)

func _update_stored_amount(pAmount : int) -> void:
	storedAmount += pAmount
	
	if pAmount < 0:
		_open_box(pAmount, pAmount < -10)
		
	if storedAmount < 10:
		open10Button.disabled = true
	else:
		open10Button.disabled = false
		
func _open_box(pAmount : int, pStack : bool) -> void:
	pass
