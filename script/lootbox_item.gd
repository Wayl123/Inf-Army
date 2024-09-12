extends "res://script/inventory_item.gd"

@onready var display : Node = %LootboxAttributeDisplay
@onready var open1Button : Node = %Open1
@onready var open10Button : Node = %Open10
@onready var openAllButton : Node = %OpenAll

var rng : Object = RandomNumberGenerator.new()

func _ready() -> void:
	open1Button.connect("pressed", Callable(self, "_open_box").bind(1))
	open10Button.connect("pressed", Callable(self, "_open_box").bind(10))
	openAllButton.connect("pressed", Callable(self, "_open_box"))
	
	display.update_display(data)

func _open_box(pAmount : int = GlobalData.ref.gameData.inventoryItem[id] if GlobalData.ref.gameData.inventoryItem.has(id) else 0) -> void:
	var output : Dictionary
	
	if GlobalData.ref.gameData.update_inventory_item_amount(id, -pAmount):
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
	GlobalData.ref.gameData.update_unit(pUnits)
	
func update_amount_display() -> void:
	display.update_amount_display(GlobalData.ref.gameData.inventoryItem[id])
	
	if GlobalData.ref.gameData.inventoryItem[id] < 10:
		open10Button.disabled = true
	else:
		open10Button.disabled = false
