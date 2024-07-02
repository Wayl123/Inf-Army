extends VBoxContainer

@onready var genName = %GeneratorName
@onready var probStat = %ProbStat

var storedAmount = 0
var holdCap = 0
	
func set_display(pData : Dictionary) -> void:
	if not pData.is_empty():
		holdCap = pData["HoldCap"]
		
		genName.text = str("[b]", pData["Name"], "[/b]")
		probStat.text = str("[b]Probability[/b]\n")
		for item in pData["Prob"]:
			probStat.text += str(item, ": ", pData["Prob"][item] * 100, "%", "\n")
	

