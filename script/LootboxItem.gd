extends "res://script/InventoryItem.gd"

@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var display = %LootboxAttributeDisplay
@onready var open1Button = %Open1
@onready var open10Button = %Open10
@onready var openAllButton = %OpenAll

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	open1Button.connect("pressed", Callable(self, "update_stored_amount").bind(-1))
	open10Button.connect("pressed", Callable(self, "update_stored_amount").bind(-10))
	openAllButton.connect("pressed", Callable(self, "update_stored_amount"))
	
	display.set_display(data)

func _open_box(pAmount : int) -> void:
	var output = {}
	for i in range(pAmount):
		var roll = rng.randf()
		for itemKey in data["Prob"]:
			roll -= data["Prob"][itemKey]
			if roll < 0:
				if not output.has(itemKey):
					output[itemKey] = 0
				output[itemKey] += 1
				break
	
	_update_unit_get(output)
	
func _update_unit_get(pUnits : Dictionary) -> void:
	unitInventory.add_unit(pUnits)
	
func _update_stored_amount_display() -> void:
	display.update_stored_amount_display(amount)
	
func update_stored_amount(pAmount : int = -amount) -> void:
	super(pAmount)
	
	if pAmount < 0:
		_open_box(abs(pAmount))
			
	if amount < 10:
		open10Button.disabled = true
	else:
		open10Button.disabled = false
