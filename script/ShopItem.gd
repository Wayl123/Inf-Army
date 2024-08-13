extends PanelContainer

@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

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
	
func _set_max_possible() -> void:
	var maxPossible : int
	
	for cost in data["Cost"]:
		var req : int
		
		req = data["Cost"][cost]["Req"]
		
		if cost == "Money":
			maxPossible = clampi(floori(data["Cost"][cost]["Node"].money / req), 1, maxPossible) if maxPossible else maxi(floori(data["Cost"][cost]["Node"].money / req), 1)
		else:
			maxPossible = clampi(floori(data["Cost"][cost]["Node"].get_amount() / req), 1, maxPossible) if maxPossible else maxi(floori(data["Cost"][cost]["Node"].get_amount() / req), 1)
		
	quantity.value = maxPossible
	
func _buy_amount() -> void:
	for cost in data["Cost"]:
		var req : int
		var totalReq : int
		
		req = data["Cost"][cost]["Req"]
		
		totalReq = req * quantity.value
		
		if cost == "Money":
			data["Cost"][cost]["Node"].update_money(-totalReq)
		else:
			data["Cost"][cost]["Node"].update_amount(-totalReq)
			
	unitInventory.add_unit({data["Id"] : quantity.value})
