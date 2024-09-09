class_name PlayerResource
extends HBoxContainer

static var ref : PlayerResource

@onready var playerMoney : Node = %Money
@onready var playerExp : Node = %Exp

var money : float = 0
var exp : float = 200

func _ready():
	if not ref: ref = self
	
	_update_display()
	
func _update_display() -> void:
	playerMoney.text = str("[right]", String.num_scientific(money), "[/right]")
	playerExp.text = str("[right]", String.num_scientific(exp), "[/right]")

func update_money(pMoneyDelta : float) -> bool:
	if money >= -pMoneyDelta:
		money += pMoneyDelta
		
		_update_display()
		
		return true
	else:
		return false
		
func update_exp(pExpDelta : float) -> bool:
	if exp >= -pExpDelta:
		exp += pExpDelta
		
		_update_display()
		
		return true
	else:
		return false
