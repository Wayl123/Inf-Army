extends PanelContainer

@onready var unitName = %Name
@onready var unitAmount = %Amount
@onready var unitPower = %Power
@onready var unitTotal = %Total

var data = {}

func _update_display() -> void:
	unitName.text = str("[center]", data["Name"], "[/center]")
	unitPower.text = str("[right]", String.num_scientific(data["Power"]), "[/right]")
	
	_update_amount_display()
	
func _update_amount_display() -> void:
	unitAmount.text = str("[right]", String.num_scientific(data["Amount"]), "[/right]")
	unitTotal.text = str("[right]", String.num_scientific(int(data["Amount"]) * int(data["Power"])), "[/right]")

func set_data(pUnit : Dictionary) -> void:
	data = pUnit
	data["Amount"] = 0
	
	_update_display()
	
func update_amount(pAmount : int) -> bool:
	if data["Amount"] >= -pAmount:
		data["Amount"] += pAmount
		
		_update_amount_display()
		
		return true
	else:
		return false
	
func get_power() -> int:
	return data["Power"]
	
func get_power_by_amount(pAmount : int) -> Array:
	if pAmount > int(data["Amount"]):
		return [int(data["Amount"]) * int(data["Power"]), pAmount - int(data["Amount"])]
	else:
		return [pAmount * int(data["Power"]), 0]
		
func get_amount() -> int:
	return data["Amount"]
