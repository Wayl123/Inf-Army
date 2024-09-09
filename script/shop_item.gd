extends PanelContainer

@onready var itemName : Node = %ItemName
@onready var itemCost : Node = %ItemCost
@onready var quantity : Node = %Quantity
@onready var setMax : Node = %SetMax
@onready var buyButton : Node = %BuyButton

signal item_purchased

var data : Dictionary

func _ready() -> void:
	quantity.connect("value_changed", Callable(self, "update_cost_display"))
	setMax.connect("pressed", Callable(self, "_max_possible"))
	buyButton.connect("pressed", Callable(self, "_buy_amount"))
	
func _max_possible() -> void:
	var maxPossible : int
	
	for cost in data["Cost"]:
		var req : float
		
		req = data["Cost"][cost]["Req"]
		
		if cost == "Money":
			maxPossible = clampi(floori(data["Cost"][cost]["Node"].money / req), 1, maxPossible) if maxPossible else maxi(floori(data["Cost"][cost]["Node"].money / req), 1)
		else:
			maxPossible = clampi(floori(data["Cost"][cost]["Node"].amount / req), 1, maxPossible) if maxPossible else maxi(floori(data["Cost"][cost]["Node"].amount / req), 1)
		
	quantity.value = maxPossible
	
func _buy_amount() -> void:
	var succeed : bool = true
	
	for cost in data["Cost"]:
		var req : float
		var totalReq : float
		
		req = data["Cost"][cost]["Req"]
		
		totalReq = req * quantity.value
		
		if cost == "Money":
			succeed = data["Cost"][cost]["Node"].update_money(-totalReq)
		else:
			succeed = data["Cost"][cost]["Node"].update_amount(-totalReq)
			
		if not succeed:
			break
	
	if succeed:
		UnitInventory.ref.add_unit({data["Id"]: quantity.value})
		item_purchased.emit()
		
func _transform_data() -> void:
	var newCost : Dictionary
	var unitRegex : Object = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	for cost in data["Cost"]:
		if unitRegex.search(cost) != null:
			var unitNode : Node = UnitInventory.ref.get_unit_node_ref(cost)
			var unitName : String = GlobalData.ref.get_unit_stat_data_copy(cost)["Name"]
			newCost[unitName] = {}
			newCost[unitName]["Id"] = cost
			newCost[unitName]["Node"] = unitNode
			newCost[unitName]["Req"] = data["Cost"][cost]
		else:
			newCost[cost] = {}
			newCost[cost]["Node"] = PlayerResource.ref
			newCost[cost]["Req"] = data["Cost"][cost]
			
	data["Cost"] = newCost
			
func _fill_empty_data(pData : Dictionary) -> void:
	var unitRegex : Object = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	if unitRegex.search(pData["Id"]) != null:
		var unitNode : Node = UnitInventory.ref.get_unit_node_ref(pData["Id"])
		pData["Node"] = unitNode
	
func update_display() -> void:
	itemName.text = str("[b]", data["Name"], "[/b]")
	
	_transform_data()
	update_cost_display()
	
func update_cost_display(reqAmount : int = quantity.value) -> void:
	var costText : String
	var affordable : bool = true
	
	for cost in data["Cost"]:
		var amount : float
		var req : float
		var totalReq : float
		
		if data["Cost"][cost]["Node"] == null:
			_fill_empty_data(data["Cost"][cost])
		
		if data["Cost"][cost]["Node"] != null:
			if cost == "Money":
				amount = data["Cost"][cost]["Node"].money
			else:
				amount = data["Cost"][cost]["Node"].amount
			req = data["Cost"][cost]["Req"]
			
			totalReq = req * reqAmount
			
			if amount >= totalReq:
				costText += "[color=#00ff00]"
			else:
				costText += "[color=#ff0000]"
				affordable = false
			costText += str("[b]", cost, ":[/b] ", String.num_scientific(amount), "/", String.num_scientific(totalReq), "[/color]\n")
		else:
			costText += "[color=#ff0000]????????[/color]\n"
			affordable = false
		
	itemCost.text = costText
	
	buyButton.disabled = not affordable
	
