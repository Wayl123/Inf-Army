extends PanelContainer

@onready var heroCap : Node = %HeroCap
@onready var normalUnitCap : Node = %NormalUnitCap
@onready var explorationPower : Node = %ExplorationPower

func update_unit_cap(pTeamSize : Array[int]) -> void:
	heroCap.text = str("[right][font_size={12}]", pTeamSize[0], "[/font_size][/right]")
	normalUnitCap.text = str("[right][font_size={12}]", pTeamSize[1], "[/font_size][/right]")

func update_exploration_power(pPower : float) -> void:
	explorationPower.text = str("[right][font_size={12}]", String.num_scientific(pPower), "[/font_size][/right]")
