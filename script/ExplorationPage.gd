extends PanelContainer

@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var explorationStat = %ExplorationStat

var teamSize = [0, 0]

func _ready() -> void:
	update_exploration_stat([1, 10])
	
func update_exploration_stat(pTeamSize : Array) -> void:
	if pTeamSize[0] != teamSize[0]:
		teamSize[0] = pTeamSize[0]
		explorationStat.update_hero_cap(teamSize[0])
	if pTeamSize[1] != teamSize[1]:
		teamSize[1] = pTeamSize[1]
		explorationStat.update_normal_unit_cap(teamSize[1])
	update_exploration_power()
	
func update_exploration_power() -> void:
	explorationStat.update_exploration_power(unitInventory.get_power_by_amount(teamSize))
