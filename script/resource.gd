class_name PlayerResource
extends HBoxContainer

static var ref : PlayerResource

@onready var playerMoney : Node = %Money
@onready var playerExp : Node = %Exp

func _enter_tree() -> void:
	if not ref: ref = self

func _ready():
	update_display()
	
func update_display() -> void:
	playerMoney.text = str("[right]", String.num_scientific(GlobalData.ref.gameData.money), "[/right]")
	playerExp.text = str("[right]", String.num_scientific(GlobalData.ref.gameData.exp), "[/right]")
