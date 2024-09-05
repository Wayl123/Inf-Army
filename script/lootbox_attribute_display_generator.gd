extends "res://script/lootbox_attribute_display.gd"

@onready var genProgress : Node = %GeneratorProgress
@onready var genTimer : Node = %GeneratorTimer

func _process(delta : float) -> void:
	genProgress.value = 0 if genTimer.is_stopped() else abs((genTimer.time_left / genTimer.wait_time) - 1.0)
	
func update_display(pData : Dictionary) -> void:
	super(pData)
	
	if not pData.is_empty():
		boxAmount.text = str("[b]Amount: [/b]", "0", "/", String.num_scientific(holdCap))
		genTimer.wait_time = pData["GenTime"]
		genTimer.start()

func update_amount_display(pAmount : int) -> void:
	if pAmount < holdCap and genTimer.is_stopped():
		genTimer.start()
	boxAmount.text = str("[b]Amount: [/b]", String.num_scientific(pAmount), "/", String.num_scientific(holdCap))
