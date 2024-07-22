extends PanelContainer

@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var test = %Test

func _ready() -> void:
	test.connect("pressed", Callable(self, "_test"))

func _test():
	var power = unitInventory.get_power_by_amount([0, 5])
	test.text = str(power)
