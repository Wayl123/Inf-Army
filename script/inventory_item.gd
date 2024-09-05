extends PanelContainer

var data : Dictionary
var amount : int = 0

func _update_amount_display() -> void:
	pass

func update_amount(pAmount : int = 0) -> bool:
	if amount >= -pAmount:
		amount += pAmount
		
		_update_amount_display()
		
		return true
	else:
		return false
