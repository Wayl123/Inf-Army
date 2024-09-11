extends "res://script/inventory_item.gd"

@onready var display : Node = %LootboxAttributeDisplay
@onready var open1Button : Node = %Open1
@onready var open10Button : Node = %Open10
@onready var openAllButton : Node = %OpenAll

var rng : Object = RandomNumberGenerator.new()

func _ready() -> void:
	open1Button.connect("pressed", Callable(GlobalData.ref.gameData, "update_inventory_item_amount").bind(id, -1))
	open10Button.connect("pressed", Callable(GlobalData.ref.gameData, "update_inventory_item_amount").bind(id, -10))
	openAllButton.connect("pressed", Callable(GlobalData.ref.gameData, "update_inventory_item_amount").bind(id))
	
	display.update_display(data)

func _open_box(pAmount : int) -> void:
	var output : Dictionary
	
	for i in range(pAmount):
		var roll : float = rng.randf()
		for itemKey in data["Prob"]:
			roll -= data["Prob"][itemKey]
			if roll < 0:
				if not output.has(itemKey):
					output[itemKey] = 0
				output[itemKey] += 1
				break
	
	_update_unit_get(output)
	
func _update_unit_get(pUnits : Dictionary) -> void:
	UnitInventory.ref.add_unit(pUnits)
	
func update_amount_display(pAmount : int = 0) -> void:
	display.update_amount_display(GlobalData.ref.gameData.inventoryItem[id])
	
	if pAmount < 0:
		_open_box(abs(pAmount))
			
	if GlobalData.ref.gameData.inventoryItem[id] < 10:
		open10Button.disabled = true
	else:
		open10Button.disabled = false
