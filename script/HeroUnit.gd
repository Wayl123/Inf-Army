extends PanelContainer

@onready var unitName = %Name
@onready var unitLevel = %Level
@onready var unitExp = %Exp
@onready var unitLevelPower = %LevelPower
@onready var unitPower = %Power

var data = {}

func _update_display() -> void:
	unitName.text = str("[center][b]", data["Name"], "[/b][/center]")
	unitLevelPower.text = str("[right]", data["LevelPower"], "[/right]")
	
	_update_level_display()
	
func _update_level_display() -> void:
	unitLevel.text = str("[right]", data["Level"], "[/right]")
	unitExp.text = str("[right]", data["ExpReq"], "[/right]")
	unitPower.text = str("[right]", int(data["LevelPower"]) * int(data["Level"]), "[/right]")
	
func set_data(pUnit : Dictionary) -> void:
	data = pUnit
	data["Level"] = 1
	data["ExpReq"] = int(data["ExpBase"]) * (int(data["ExpScale"]) ** (int(data["Level"]) - 1))
	
	_update_display()
	
func get_power() -> int:
	return int(data["LevelPower"]) * int(data["Level"])
	
