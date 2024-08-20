extends PanelContainer

var data = {}
var amount = 0

func _update_stored_amount_display() -> void:
	pass

func update_stored_amount(pAmount : int = 0) -> void:
	amount += pAmount
	_update_stored_amount_display()
