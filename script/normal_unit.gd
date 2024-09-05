extends PanelContainer

@onready var unitName : Node = %Name
@onready var unitAmount : Node = %Amount
@onready var unitPower : Node = %Power
@onready var unitTotal : Node = %Total

var data : Dictionary
var amount : int = 0

func _update_display() -> void:
	unitName.text = str("[center]", data["Name"], "[/center]")
	unitPower.text = str("[right]", String.num_scientific(data["Power"]), "[/right]")
	
	_update_amount_display()
	
func _update_amount_display() -> void:
	unitAmount.text = str("[right]", String.num_scientific(amount), "[/right]")
	unitTotal.text = str("[right]", String.num_scientific(amount * data["Power"]), "[/right]")
	
	visible = amount > 0

func set_data(pUnit : Dictionary) -> void:
	data = pUnit
	
	_update_display()
	
func update_amount(pAmount : int) -> bool:
	if amount >= -pAmount:
		amount += pAmount
		
		_update_amount_display()
		
		return true
	else:
		return false
	
func get_power() -> float:
	return data["Power"]
	
func get_power_by_amount(pAmount : int) -> Array:
	if pAmount > amount:
		return [amount * data["Power"], pAmount - amount]
	else:
		return [pAmount * data["Power"], 0]
