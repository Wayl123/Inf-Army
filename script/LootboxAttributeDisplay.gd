extends VBoxContainer

@onready var lootboxName = %LootboxName
@onready var probStat = %ProbStat
@onready var boxAmount = %Amount

var holdCap = 0
	
func set_display(pData : Dictionary) -> void:
	if not pData.is_empty():
		holdCap = pData["HoldCap"]
		
		lootboxName.text = str("[b]", pData["Name"], "[/b]")
		probStat.text = str("[b]Probability[/b]\n")
		for item in pData["Prob"]:
			probStat.text += str(item, ": ", pData["Prob"][item] * 100, "%", "\n")
	
func update_stored_amount_display(pAmount : int) -> void:
	pass
