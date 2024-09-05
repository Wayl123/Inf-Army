extends PanelContainer

@onready var heroCap : Node = %HeroCap
@onready var normalUnitCap : Node = %NormalUnitCap
@onready var explorationPower : Node = %ExplorationPower

func update_hero_cap(pCap : int) -> void:
	heroCap.text = str("[right][font_size={12}]", pCap, "[/font_size][/right]")
	
func update_normal_unit_cap(pCap : int) -> void:
	normalUnitCap.text = str("[right][font_size={12}]", pCap, "[/font_size][/right]")

func update_exploration_power(pPower : float) -> void:
	explorationPower.text = str("[right][font_size={12}]", String.num_scientific(pPower), "[/font_size][/right]")
