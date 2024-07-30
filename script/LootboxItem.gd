extends PanelContainer

@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")
@onready var exploration = get_tree().get_first_node_in_group("Exploration")

@onready var display = %AttributeDisplay
@onready var open1Button = %Open1
@onready var open10Button = %Open10
@onready var openAllButton = %OpenAll

var lootboxData = {}
var storedAmount = 0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	open1Button.connect("pressed", Callable(self, "update_stored_amount").bind(-1))
	open10Button.connect("pressed", Callable(self, "update_stored_amount").bind(-10))
	openAllButton.connect("pressed", Callable(self, "update_stored_amount"))
	
	display.set_display(lootboxData)

func _open_box(pAmount : int) -> void:
	var output = {}
	for i in range(pAmount):
		var roll = rng.randf()
		for itemKey in lootboxData["Prob"]:
			roll -= lootboxData["Prob"][itemKey]
			if roll < 0:
				if not output.has(itemKey):
					output[itemKey] = 0
				output[itemKey] += 1
				break
	
	_display_unit_get(output)
	
func _display_unit_get(pUnits : Dictionary) -> void:
	unitInventory.add_unit(pUnits)
	exploration.update_exploration_power()
	
func update_stored_amount(pAmount : int = -storedAmount) -> void:
	storedAmount += pAmount
	display.update_stored_amount(storedAmount)
	
	if pAmount < 0:
		_open_box(abs(pAmount))
			
	if storedAmount < 10:
		open10Button.disabled = true
	else:
		open10Button.disabled = false
