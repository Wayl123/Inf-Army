extends PanelContainer

@onready var itemName : Node = %ItemName
@onready var itemCost : Node = %ItemCost
@onready var quantity : Node = %Quantity
@onready var setMax : Node = %SetMax
@onready var buyButton : Node = %BuyButton

signal item_purchased

var data : Dictionary

var unitRegex : Object

func _enter_tree() -> void:
	_set_regex()

func _ready() -> void:
	quantity.connect("value_changed", Callable(self, "update_cost_display"))
	setMax.connect("pressed", Callable(self, "_max_possible"))
	buyButton.connect("pressed", Callable(self, "_buy_amount"))
	
func _set_regex() -> void:
	unitRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	
func _max_possible() -> void:
	var maxPossible : int
	
	for cost in data["Cost"]:
		var req : float
		
		req = data["Cost"][cost]["Req"]
		
		if cost == "Money":
			maxPossible = clampi(floori(GlobalData.ref.gameData.money / req), 1, maxPossible) if maxPossible else maxi(floori(GlobalData.ref.gameData.money / req), 1)
		elif unitRegex.search(data["Cost"][cost]["Id"]) != null:
			maxPossible = clampi(floori(GlobalData.ref.gameData.normalUnit[data["Cost"][cost]["Id"]] / req), 1, maxPossible) if maxPossible else maxi(floori(GlobalData.ref.gameData.normalUnit[data["Cost"][cost]["Id"]] / req), 1)
		else:
			maxPossible = 1
		
	quantity.value = maxPossible
	
func _buy_amount() -> void:
	var succeed : bool
	
	for cost in data["Cost"]:
		var req : float
		var totalReq : float
		
		req = data["Cost"][cost]["Req"]
		
		totalReq = req * quantity.value
		
		if cost == "Money":
			succeed = GlobalData.ref.gameData.update_money(-totalReq)
		elif unitRegex.search(data["Cost"][cost]["Id"]) != null:
			succeed = GlobalData.ref.gameData.update_normal_unit_amount(data["Cost"][cost]["Id"], -totalReq)
		else:
			succeed = false
			
		if not succeed:
			break
	
	if succeed:
		GlobalData.ref.gameData.update_unit({data["Id"]: quantity.value})
		item_purchased.emit()
		
func _transform_data() -> void:
	var newCost : Dictionary
	
	for cost in data["Cost"]:
		if unitRegex.search(cost) != null:
			var unitName : String = GlobalData.ref.get_unit_stat_data_copy(cost)["Name"]
			newCost[unitName] = {}
			newCost[unitName]["Id"] = cost
			newCost[unitName]["Req"] = data["Cost"][cost]
		else:
			newCost[cost] = {}
			newCost[cost]["Req"] = data["Cost"][cost]
			
	data["Cost"] = newCost
	
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
		var unlocked : bool = true
		
		if cost == "Money":
			amount = GlobalData.ref.gameData.money
		elif unitRegex.search(data["Cost"][cost]["Id"]) != null:
			if GlobalData.ref.gameData.normalUnit.has(data["Cost"][cost]["Id"]):
				amount = GlobalData.ref.gameData.normalUnit[data["Cost"][cost]["Id"]]
			else:
				unlocked = false
		else:
			unlocked = false
		
		if unlocked:
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
	
