class_name GameData
extends Resource

@export var money : float
@export var exp : float

func _init() -> void:
	money = 0
	exp = 200

func update_money(pMoneyDelta : float) -> bool:
	if money >= -pMoneyDelta:
		money += pMoneyDelta
		
		PlayerResource.ref.update_display()
		
		return true
	else:
		return false
		
func update_exp(pExpDelta : float) -> bool:
	if exp >= -pExpDelta:
		exp += pExpDelta
		
		PlayerResource.ref.update_display()
		
		return true
	else:
		return false
