extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var resource = get_tree().get_first_node_in_group("Resource")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var promotionName = %PromotionName
@onready var promotionCost = %PromotionCost
@onready var selectLeft = %SelectLeft
@onready var selectRight = %SelectRight
@onready var selectionDisplay = %SelectionDisplay
@onready var optionalItemList = %OptionalItemList
@onready var basePowerIncrease = %BasePowerIncrease
@onready var promoteButton = %PromoteButton

signal promoteUnit(promotePower : int, promoteSpecial : Dictionary)

var data = {}
var selection : Array
var currentIndex = 0

func _ready() -> void:
	selectLeft.connect("pressed", Callable(self, "_change_selection").bind(-1))
	selectRight.connect("pressed", Callable(self, "_change_selection").bind(1))
	promoteButton.connect("pressed", Callable(self, "_promote_unit"))
	
func _change_selection(direction : int) -> void:
	if selection and selection.size() > 1:
		currentIndex += direction
		if currentIndex < 0:
			currentIndex = selection.size() - 1
		elif currentIndex > selection.size() - 1:
			currentIndex = 0
		
		_set_selected_display(data[selection[currentIndex]])

func _promote_unit() -> void:
	pass
	
func _transform_data() -> void:
	var unitRegex = RegEx.new()
	var itemRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	itemRegex.compile("^[PB]\\d+")
	
	for promo in data:
		var newCost = {}
		var newSelection = {}
		data[promo]["Name"] = globalData.get_unit_stat_data_copy(promo)["Name"]
		
		for cost in data[promo]["Cost"]:
			if unitRegex.search(cost) != null:
				var unitNode = unitInventory.get_unit_node_ref(cost)
				var unitName = globalData.get_unit_stat_data_copy(cost)["Name"]
				newCost[unitName] = {}
				newCost[unitName]["Id"] = cost
				newCost[unitName]["Node"] = unitNode
				newCost[unitName]["Req"] = data[promo]["Cost"][cost]
			elif itemRegex.search(cost) != null:
				var itemNode = inventory.get_item_node_ref(cost)
				var itemName = globalData.get_item_stat_data_copy(cost)["Name"]
				newCost[itemName] = {}
				newCost[itemName]["Id"] = cost
				newCost[itemName]["Node"] = itemNode
				newCost[itemName]["Req"] = data[promo]["Cost"][cost]
			else:
				newCost[cost] = {}
				newCost[cost]["Node"] = resource
				newCost[cost]["Req"] = data[promo]["Cost"][cost]
				
		data[promo]["Cost"] = newCost
				
		for selection in data[promo]["Optional"]["Selection"]:
			if unitRegex.search(selection) != null:
				var unitNode = unitInventory.get_unit_node_ref(selection)
				var unitName = globalData.get_unit_stat_data_copy(selection)["Name"]
				newSelection[unitName] = {}
				newSelection[unitName]["Node"] = unitNode
			elif itemRegex.search(selection) != null:
				var itemNode = inventory.get_item_node_ref(selection)
				var itemName = globalData.get_item_stat_data_copy(selection)["Name"]
				newSelection[itemName] = {}
				newSelection[itemName]["Node"] = itemNode
				
		data[promo]["Optional"]["Selection"] = newSelection
		
func _fill_empty_data(pData : Dictionary) -> void:
	var unitRegex = RegEx.new()
	var itemRegex = RegEx.new()
	unitRegex.compile("\\d+S\\d+")
	itemRegex.compile("^[PB]\\d+")
	
	if unitRegex.search(pData["Id"]) != null:
		var unitNode = unitInventory.get_unit_node_ref(pData["Id"])
		pData["Node"] = unitNode
	elif itemRegex.search(pData["Id"]) != null:
		var itemNode = inventory.get_item_node_ref(pData["Id"])
		pData["Node"] = itemNode
	
func _set_selected_display(pSelected : Dictionary) -> void:
	var costText = ""
	var affordable = true
	
	promotionName.text = pSelected["Name"]
	
	for cost in pSelected["Cost"]:
		var amount : int
		var req : int
		
		if pSelected["Cost"][cost]["Node"] == null:
			_fill_empty_data(pSelected["Cost"][cost])
		
		if pSelected["Cost"][cost]["Node"] != null:
			if cost == "Money":
				amount = pSelected["Cost"][cost]["Node"].money
			elif cost == "Exp":
				amount = pSelected["Cost"][cost]["Node"].exp
			else:
				amount = pSelected["Cost"][cost]["Node"].amount
			req = pSelected["Cost"][cost]["Req"]
		
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
	
func set_display() -> void:
	if not data.is_empty():
		selection = data.keys()
		if selection.size() > 1:
			selectLeft.disabled = false
			selectRight.disabled = false
		
		_transform_data()
		_set_selected_display(data[selection[currentIndex]])
	else:
		promotionCost.text = "No promotion available"
		
func update_display() -> void:
	_set_selected_display(data[selection[currentIndex]])
