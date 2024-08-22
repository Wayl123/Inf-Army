extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var resource = get_tree().get_first_node_in_group("Resource")
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
	
func _set_max_possible() -> void:
	var maxPossible : int
	
	for cost in data["Cost"]:
		var req : int
		
		req = data["Cost"][cost]["Req"]
		
		if cost == "Money":
			maxPossible = clampi(floori(data["Cost"][cost]["Node"].money / req), 1, maxPossible) if maxPossible else maxi(floori(data["Cost"][cost]["Node"].money / req), 1)
		else:
			maxPossible = clampi(floori(data["Cost"][cost]["Node"].amount / req), 1, maxPossible) if maxPossible else maxi(floori(data["Cost"][cost]["Node"].amount / req), 1)
		
	quantity.value = maxPossible
	
func _buy_amount() -> void:
	var succeed = true
	
	for cost in data["Cost"]:
		var req : int
		var totalReq : int
		
		req = data["Cost"][cost]["Req"]
		
		totalReq = req * quantity.value
		
		if cost == "Money":
			succeed = data["Cost"][cost]["Node"].update_money(-totalReq)
		else:
			succeed = data["Cost"][cost]["Node"].update_amount(-totalReq)
			
		if not succeed:
			break
	
	if succeed:
		unitInventory.add_unit({data["Id"]: quantity.value})
		
func _transform_data() -> void:
	var newCost = {}
	var unitRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	for cost in data["Cost"]:
		if unitRegex.search(cost) != null:
			var unitNode = unitInventory.get_unit_node_ref(cost)
			var unitName = globalData.get_unit_stat_data_copy(cost)["Name"]
			newCost[unitName] = {}
			newCost[unitName]["Id"] = cost
			newCost[unitName]["Node"] = unitNode
			newCost[unitName]["Req"] = data["Cost"][cost]
		else:
			newCost[cost] = {}
			newCost[cost]["Node"] = resource
			newCost[cost]["Req"] = data["Cost"][cost]
			
	data["Cost"] = newCost
			
func _fill_empty_data(pData : Dictionary) -> void:
	var unitRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
	if unitRegex.search(pData["Id"]) != null:
		var unitNode = unitInventory.get_unit_node_ref(pData["Id"])
		pData["Node"] = unitNode
	
func set_display() -> void:
	itemName.text = data["Name"]
	
	_transform_data()
	set_cost_display()
	
func set_cost_display(reqAmount : int = quantity.value) -> void:
	var costText = ""
	var affordable = true
	
	for cost in data["Cost"]:
		var amount : int
		var req : int
		var totalReq : int
		
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
	
