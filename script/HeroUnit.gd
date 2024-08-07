extends HBoxContainer

@onready var unitName = %Name
@onready var unitLevel = %Level
@onready var unitExp = %Exp
@onready var unitLevelPower = %LevelPower
@onready var unitPower = %Power

var unitData = {}

func _display_data() -> void:
	unitName.text = str("[center][b]", unitData["Name"], "[/b][/center]")
	unitLevel.text = str("[right]", unitData["Level"], "[/right]")
	unitExp.text = str("[right]", unitData["ExpReq"], "[/right]")
	unitLevelPower.text = str("[right]", unitData["LevelPower"], "[/right]")
	unitPower.text = str("[right]", int(unitData["LevelPower"]) * int(unitData["Level"]), "[/right]")
	
func set_data(pUnit : Dictionary) -> void:
	unitData = pUnit
	unitData["Level"] = 1
	unitData["ExpReq"] = int(unitData["ExpBase"]) * (int(unitData["ExpScale"]) ** (int(unitData["Level"]) - 1))
	
	_display_data()
	
func get_power() -> int:
	return int(unitData["LevelPower"]) * int(unitData["Level"])
	
