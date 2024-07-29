extends HBoxContainer

@onready var playerMoney = %Money
@onready var playerExp = %Exp

var money = 0
var exp = 0

func _ready():
	_set_display()
	
func _set_display() -> void:
	playerMoney.text = str("[right]", money, "[/right]")
	playerExp.text = str("[right]", exp, "[/right]")

func update_money(pMoneyDelta : int) -> bool:
	if money >= -pMoneyDelta:
		money += pMoneyDelta
		_set_display()
		return true
	else:
		return false
		
func update_exp(pExpDelta : int) -> bool:
	if exp >= -pExpDelta:
		exp += pExpDelta
		_set_display()
		return true
	else:
		return false
