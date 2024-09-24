extends PanelContainer

@onready var unitName : Node = %Name
@onready var unitAmount : Node = %Amount
@onready var unitPower : Node = %Power
@onready var unitTotal : Node = %Total

var id : String
var gameData : Dictionary = GlobalData.ref.gameData.normalUnit
var data : Dictionary

func _update_display() -> void:
	unitName.text = str("[center]", data["Name"], "[/center]")
	unitPower.text = str("[right]", String.num_scientific(data["Power"]), "[/right]")
	
	update_amount_display()
	
func update_amount_display() -> void:
	unitAmount.text = str("[right]", String.num_scientific(gameData[id]), "[/right]")
	unitTotal.text = str("[right]", String.num_scientific(gameData[id] * data["Power"]), "[/right]")
	
	visible = gameData[id] > 0

func set_data(pUnit : Dictionary) -> void:
	data = pUnit
	
	_update_display()
	
func get_power() -> float:
	return data["Power"]
	
func get_power_by_amount(pAmount : int) -> Array:
	if pAmount > gameData[id]:
		return [gameData[id] * data["Power"], pAmount - gameData[id]]
	else:
		return [pAmount * data["Power"], 0]
