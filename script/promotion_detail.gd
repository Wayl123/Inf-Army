extends PanelContainer

@onready var globalData : Node = get_tree().get_first_node_in_group("GlobalData")
@onready var resource : Node = get_tree().get_first_node_in_group("Resource")
@onready var inventory : Node = get_tree().get_first_node_in_group("Inventory")
@onready var unitInventory : Node = get_tree().get_first_node_in_group("UnitInventory")

@onready var promotionName : Node = %PromotionName
@onready var promotionCost : Node = %PromotionCost
@onready var selectLeft : Node = %SelectLeft
@onready var selectRight : Node = %SelectRight
@onready var selectionDisplay : Node = %SelectionDisplay
@onready var optionalItemList : Node = %OptionalItemList
@onready var selectedAmount : Node = %SelectedAmount
@onready var selectedItem : Node = %SelectedItem
@onready var basePowerIncrease : Node = %BasePowerIncrease
@onready var promoteButton : Node = %PromoteButton

signal promote_unit(promoteData : Dictionary)

var data : Dictionary
var promoSelection : Array
var currentIndex : int = 0
var selectedData : Dictionary
var maxOptional : int
var totalCost : Dictionary
var promoPower : float
var promoMulti : Dictionary
var totalPower : float
var totalMulti : Dictionary

func _ready() -> void:
	selectLeft.connect("pressed", Callable(self, "_change_selection").bind(-1))
	selectRight.connect("pressed", Callable(self, "_change_selection").bind(1))
	optionalItemList.connect("item_activated", Callable(self, "_select_optional_item"))
	selectedItem.connect("item_activated", Callable(self, "_deselect_optional_item"))
	promoteButton.connect("pressed", Callable(self, "_promote_unit"))
	
func _change_selection(pDirection : int) -> void:
	if promoSelection and promoSelection.size() > 1:
		currentIndex += pDirection
		if currentIndex < 0:
			currentIndex = promoSelection.size() - 1
		elif currentIndex > promoSelection.size() - 1:
			currentIndex = 0
		
		_update_selection()
		selectedItem.clear()

func _promote_unit() -> void:
	var promoData : Dictionary
	var succeed : bool = true
	
	for cost in totalCost:
		var req : float
		
		req = totalCost[cost]["Req"]
		
		if cost == "Money":
			succeed = totalCost[cost]["Node"].update_money(-req)
		elif cost == "Exp":
			succeed = totalCost[cost]["Node"].update_exp(-req)
		else:
			succeed = totalCost[cost]["Node"].update_amount(-req)
			
		if not succeed:
			break
	
	if succeed:
		promoData["Data"] = globalData.get_unit_stat_data_copy(promoSelection[currentIndex])
		promoData["Power"] = totalPower
		promoData["Multi"] = totalMulti
		
		promoteButton.disabled = true
		promote_unit.emit(promoData)
	
func _transform_data() -> void:
	var unitRegex : Object = RegEx.new()
	var itemRegex : Object = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	itemRegex.compile("^[PB]\\d+")
	
	for promo in data:
		var cacheData : Dictionary = globalData.get_cache_promo_data(promo)
		
		if cacheData.is_empty():
			var newCost : Dictionary
			var newSelection : Dictionary
			cacheData["Name"] = globalData.get_unit_stat_data_copy(promo)["Name"]
			
			for cost in data[promo]["Cost"]:
				if unitRegex.search(cost) != null:
					var unitNode : Node = unitInventory.get_unit_node_ref(cost)
					var unitData : Dictionary = globalData.get_unit_stat_data_copy(cost)
					var unitName : String = unitData["Name"]
					newCost[unitName] = {}
					newCost[unitName]["Id"] = cost
					newCost[unitName]["Node"] = unitNode
					newCost[unitName]["Power"] = unitData["Power"]
					newCost[unitName]["Req"] = data[promo]["Cost"][cost]
				elif itemRegex.search(cost) != null:
					var itemNode : Node = inventory.get_item_node_ref(cost)
					var itemData : Dictionary = globalData.get_item_stat_data_copy(cost)
					var itemName : String = itemData["Name"]
					newCost[itemName] = {}
					newCost[itemName]["Id"] = cost
					newCost[itemName]["Node"] = itemNode
					newCost[itemName]["Power"] = itemData["Power"]
					newCost[itemName]["Req"] = data[promo]["Cost"][cost]
					if itemData.has("Multi"):
						newCost[itemName]["Multi"] = itemData["Multi"]
				else:
					newCost[cost] = {}
					newCost[cost]["Node"] = resource
					newCost[cost]["Req"] = data[promo]["Cost"][cost]
					
			cacheData["Cost"] = newCost
			cacheData["BaseMulti"] = data[promo]["BaseMulti"]
					
			for selection in data[promo]["Optional"]["Selection"]:
				if unitRegex.search(selection) != null:
					var unitNode : Node = unitInventory.get_unit_node_ref(selection)
					var unitData : Dictionary = globalData.get_unit_stat_data_copy(selection)
					var unitName : String = unitData["Name"]
					newSelection[unitName] = {}
					newSelection[unitName]["Id"] = selection
					newSelection[unitName]["Node"] = unitNode
					newSelection[unitName]["Power"] = unitData["Power"]
				elif itemRegex.search(selection) != null:
					var itemNode : Node = inventory.get_item_node_ref(selection)
					var itemData : Dictionary = globalData.get_item_stat_data_copy(selection)
					var itemName : String = itemData["Name"]
					newSelection[itemName] = {}
					newSelection[itemName]["Id"] = selection
					newSelection[itemName]["Node"] = itemNode
					newSelection[itemName]["Power"] = itemData["Power"]
					if itemData.has("Multi"):
						newSelection[itemName]["Multi"] = itemData["Multi"]
					
			cacheData["Optional"] = {}
			cacheData["Optional"]["Selection"] = newSelection
			cacheData["Optional"]["MaxAmount"] = data[promo]["Optional"]["MaxAmount"]
			cacheData["OptionalMulti"] = data[promo]["OptionalMulti"]
			
		data[promo] = cacheData
		
func _fill_empty_data(pData : Dictionary) -> void:
	var unitRegex : Object = RegEx.new()
	var itemRegex : Object = RegEx.new()
	var dataNode : Node
	unitRegex.compile("\\d+S\\d+")
	itemRegex.compile("^[PB]\\d+")
	
	if unitRegex.search(pData["Id"]) != null:
		dataNode = unitInventory.get_unit_node_ref(pData["Id"])
	elif itemRegex.search(pData["Id"]) != null:
		dataNode = inventory.get_item_node_ref(pData["Id"])
		
	pData["Node"] = dataNode
	
func _update_selected_display() -> void:
	var costText : String
	var affordable : bool = true
	
	promotionName.text = str("[b]", selectedData["Name"], "[/b]")
	
	for cost in totalCost:
		var amount : float
		var req : float
		
		if selectedData["Cost"].has(cost) and selectedData["Cost"][cost]["Node"] == null:
			_fill_empty_data(selectedData["Cost"][cost])
			
		if totalCost[cost]["Node"] == null and selectedData["Cost"][cost]["Node"] != null:
			totalCost[cost]["Node"] = selectedData["Cost"][cost]["Node"]
		
		if totalCost[cost]["Node"] != null:
			if cost == "Money":
				amount = totalCost[cost]["Node"].money
			elif cost == "Exp":
				amount = totalCost[cost]["Node"].exp
			else:
				amount = totalCost[cost]["Node"].amount
			req = totalCost[cost]["Req"]
		
			if amount >= req:
				costText += "[color=#00ff00]"
			else:
				costText += "[color=#ff0000]"
				affordable = false
			costText += str("[b]", cost, ":[/b] ", String.num_scientific(amount), "/", String.num_scientific(req), "[/color]\n")
		else:
			costText += "[color=#ff0000]????????[/color]\n"
			affordable = false
			
	promotionCost.text = costText
	
	promoteButton.disabled = not affordable
	
func _update_optional_list() -> void:
	optionalItemList.clear()
	
	for item in selectedData["Optional"]["Selection"]:
		if selectedData["Optional"]["Selection"][item]["Node"] == null:
			_fill_empty_data(selectedData["Optional"]["Selection"][item])
		
		if selectedData["Optional"]["Selection"][item]["Node"] != null:
			optionalItemList.add_item(item)
		else:
			var index : int = optionalItemList.add_item("????????")
			optionalItemList.set_item_disabled(index, true)
			
func _update_selected_amount() -> void:
	selectedAmount.text = str("[right]", selectedItem.item_count, "/", maxOptional, "[/right]")
	
	_update_selected_display()
	_update_power_increase()
			
func _select_optional_item(pIndex : int) -> void:
	if selectedItem.item_count < maxOptional:
		var item : String = optionalItemList.get_item_text(pIndex)
		
		selectedItem.add_item(item)
		
		if not totalCost.has(item):
			totalCost[item] = selectedData["Optional"]["Selection"][item].duplicate(true)
			totalCost[item]["Req"] = 1
		else:
			totalCost[item]["Req"] += 1
		
		_update_selected_amount()
		
func _deselect_optional_item(pIndex : int) -> void:
	var item : String = selectedItem.get_item_text(pIndex)
	
	selectedItem.remove_item(pIndex)
	
	totalCost[item]["Req"] -= 1
	if totalCost[item]["Req"] <= 0:
		totalCost.erase(item)
		
	_update_selected_amount()
	
func _update_promotion_power() -> void:
	var power : float = 0
	var multi : Dictionary
	
	for cost in selectedData["Cost"]:
		if selectedData["Cost"][cost].has("Power"):
			power += float(selectedData["Cost"][cost]["Power"]) * float(selectedData["Cost"][cost]["Req"])
		if selectedData["Cost"][cost].has("Multi"):
			for itemMulti in selectedData["Cost"][cost]["Multi"]:
				if not multi.has(itemMulti):
					multi[itemMulti] = 0.0
				multi[itemMulti] += float(selectedData["Cost"][cost]["Multi"][itemMulti]) * float(selectedData["Cost"][cost]["Req"])
			
	promoPower = floorf(float(power) * float(selectedData["BaseMulti"]))
	promoMulti = multi
	
	_update_power_increase()
	
func _update_power_increase() -> void:
	var power : float = 0
	var multi : Dictionary
	var optionalPower : float = 0
	
	power += promoPower
	multi = promoMulti.duplicate(true)
	
	for index in selectedItem.item_count:
		var item : String = selectedItem.get_item_text(index)
		
		if selectedData["Optional"]["Selection"][item].has("Power"):
			optionalPower += selectedData["Optional"]["Selection"][item]["Power"]
		if selectedData["Optional"]["Selection"][item].has("Multi"):
			for itemMulti in selectedData["Optional"]["Selection"][item]["Multi"]:
				if not multi.has(itemMulti):
					multi[itemMulti] = 0.0
				multi[itemMulti] += float(selectedData["Optional"]["Selection"][item]["Multi"][itemMulti])
		
	power += floorf(float(optionalPower) * float(selectedData["OptionalMulti"]))
	
	totalPower = power
	totalMulti = multi
	basePowerIncrease.text = str("[right]+", power, "[/right]")
	
func _update_selection() -> void:
	selectedData = data[promoSelection[currentIndex]]
	
	totalCost = selectedData["Cost"].duplicate(true)
	update_display()
	selectionDisplay.text = str("[center]", currentIndex + 1, "/", promoSelection.size(), "[/center]")
	_update_promotion_power()
	maxOptional = selectedData["Optional"]["MaxAmount"]
	_update_selected_amount()
	
func set_data(pData : Dictionary) -> void:
	data = pData
	
	if not data.is_empty():
		promoSelection = data.keys()
		if promoSelection.size() > 1:
			selectLeft.disabled = false
			selectRight.disabled = false
		else:
			selectLeft.disabled = true
			selectRight.disabled = true
		
		_transform_data()
		_update_selection()
	else:
		promotionCost.text = "No promotion available"
		
func update_display() -> void:
	if not data.is_empty():
		_update_selected_display()
		_update_optional_list()
