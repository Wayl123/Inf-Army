extends HBoxContainer

@onready var unitName = %Name
@onready var unitAmount = %Amount
@onready var unitPower = %Power
@onready var unitTotal = %Total

var unitData = {}

func _display_data() -> void:
	unitName.text = str("[center]", unitData["Name"], "[/center]")
	unitAmount.text = str("[right]", unitData["Amount"], "[/right]")
	unitPower.text = str("[right]", unitData["Power"], "[/right]")
	unitTotal.text = str("[right]", unitData["Amount"] * unitData["Power"], "[/right]")

func set_data(pUnit : Dictionary) -> void:
	unitData = pUnit
	unitData["Amount"] = 0
	
	_display_data()
	
func add_amount(pAmount : int) -> void:
	unitData["Amount"] += pAmount
	
	_display_data()
	
