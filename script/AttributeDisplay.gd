extends VBoxContainer

@onready var genName = %GeneratorName
@onready var probStat = %ProbStat
@onready var amount = %ClaimableAmount
@onready var genTimer = %GeneratorTimer

var storedAmount = 0
var holdCap = 0

func _ready() -> void:
	genTimer.connect("timeout", Callable(self, "_update_stored_amount").bind(1))
	
func set_display(pData : Dictionary) -> void:
	if pData.is_empty():
		genName.text = "Error getting data"
	else:
		holdCap = pData["HoldCap"]
		
		genName.text = str("[b]", pData["Name"], "[/b]")
		probStat.text = str("[b]Probability[/b]\n")
		for item in pData["Prob"]:
			probStat.text += str(item, ": ", pData["Prob"][item] * 100, "%", "\n")
		amount.text = str("[b]Amount: [/b]", storedAmount, "/", pData["HoldCap"])
		genTimer.wait_time = pData["GenTime"]
		genTimer.start()
	
func _update_stored_amount(pAmount : float) -> void:
	storedAmount += pAmount
	if storedAmount < holdCap:
		genTimer.start()
	print_debug(storedAmount)
	
func get_and_empty_stored_amount() -> int:
	var retrievedAmount = storedAmount
	
	_update_stored_amount(-storedAmount)
	
	return retrievedAmount
