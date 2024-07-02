extends "res://script/AttributeDisplay.gd"

@onready var amount = %ClaimableAmount
@onready var genProgress = %GeneratorProgress
@onready var genTimer = %GeneratorTimer

func _process(delta : float) -> void:
	genProgress.value = 0 if genTimer.is_stopped() else abs((genTimer.time_left / genTimer.wait_time) - 1.0)
	
func set_display(pData : Dictionary) -> void:
	super(pData)
	
	if not pData.is_empty():
		amount.text = str("[b]Amount: [/b]", "0", "/", holdCap)
		genTimer.wait_time = pData["GenTime"]
		genTimer.start()

func update_stored_amount(pAmount : int) -> void:
	if pAmount < holdCap and genTimer.is_stopped():
		genTimer.start()
	amount.text = str("[b]Amount: [/b]", pAmount, "/", holdCap)
