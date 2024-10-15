extends PanelContainer

@onready var heroCap : Node = %HeroCap
@onready var normalUnitCap : Node = %NormalUnitCap
@onready var maxExplore : Node = %MaxExplore
@onready var explorationPower : Node = %ExplorationPower

func update_unit_cap() -> void:
	heroCap.text = str("[right][font_size={12}]", GlobalData.ref.gameData.teamSize[0], "[/font_size][/right]")
	normalUnitCap.text = str("[right][font_size={12}]", GlobalData.ref.gameData.teamSize[1], "[/font_size][/right]")
	
func update_max_explore(pCount : int) -> void:
	maxExplore.text = str("[right][font_size={12}]", pCount, "/", GlobalData.ref.gameData.maxExplore, "[/font_size][/right]")

func update_exploration_power(pPower : float) -> void:
	explorationPower.text = str("[right][font_size={12}]", String.num_scientific(pPower), "[/font_size][/right]")
