extends VBoxContainer

@onready var lootboxName : Node = %LootboxName
@onready var probStat : Node = %ProbStat
@onready var boxAmount : Node = %Amount

var holdCap : int
	
func update_display(pData : Dictionary, pAmount : int = 0) -> void:
	if not pData.is_empty():
		holdCap = pData["HoldCap"]
		
		lootboxName.text = str("[b]", pData["Name"], "[/b]")
		probStat.text = str("[b]Probability[/b]\n")
		for item in pData["Prob"]:
			probStat.text += str(GlobalData.ref.get_unit_stat_data_copy(item)["Name"], ": ", pData["Prob"][item] * 100, "%", "\n")
			
	update_amount_display(pAmount)
	
func update_amount_display(pAmount : int) -> void:
	pass
