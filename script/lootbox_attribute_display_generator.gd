extends "res://script/lootbox_attribute_display.gd"

@onready var genProgress : Node = %GeneratorProgress
@onready var genTimer : Node = %GeneratorTimer

func _process(delta : float) -> void:
	genProgress.value = 0 if genTimer.is_stopped() else abs((genTimer.time_left / genTimer.wait_time) - 1.0)
	
func update_display(pData : Dictionary, pAmount : int = 0) -> void:
	if not pData.is_empty():
		genTimer.wait_time = pData["GenTime"]
		genTimer.start()
	
	super(pData, pAmount)

func update_amount_display(pAmount : int) -> void:
	if pAmount < holdCap and genTimer.is_stopped():
		genTimer.start()
	elif pAmount >= holdCap:
		genTimer.stop()
	boxAmount.text = str("[b]Amount: [/b]", String.num_scientific(pAmount), "/", String.num_scientific(holdCap))
