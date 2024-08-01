extends PanelContainer

@onready var itemName = %ItemName
@onready var itemCost = %ItemCost
@onready var quantity = %Quantity
@onready var setMax = %SetMax
@onready var buyButton = %BuyButton

var data = {}

func _ready() -> void:
	quantity.connect("value_changed", Callable(self, "set_cost_display"))
	setMax.connect("pressed", Callable(self, "_set_max_possible"))
	buyButton.connect("pressed", Callable(self, "_buy_amount"))
	
func set_display():
	itemName.text = data["Name"]
	
	set_cost_display()
	
func set_cost_display(reqAmount : int = quantity.value) -> void:
	var costText = ""
	var affordable = true
	
	for cost in data["Cost"]:
		var amount : int
		var req : int
		var totalReq : int
		
		if cost == "Money":
			amount = data["Cost"][cost]["Node"].money
		else:
			amount = data["Cost"][cost]["Node"].get_amount()
		req = data["Cost"][cost]["Req"]
		
		totalReq = req * reqAmount
		
		if amount >= totalReq:
			costText += "[color=#00ff00]"
		else:
			costText += "[color=#ff0000]"
			affordable = false
		costText += str("[b]", cost, ":[/b] ", amount, "/", totalReq, "[/color]\n")
		
	itemCost.text = costText
	
	buyButton.disabled = not affordable
