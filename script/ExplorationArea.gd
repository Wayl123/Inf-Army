extends PanelContainer

@onready var resource = get_tree().get_first_node_in_group("Resource")
@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var unitInventory = get_tree().get_first_node_in_group("UnitInventory")

@onready var areaName = %AreaName
@onready var activeToggle = %ActiveToggle
@onready var moneyRate = %MoneyRate
@onready var expRate = %ExpRate
@onready var lootList = %PossibleLoot
@onready var explorationProgress = %ExplorationProgress
@onready var payoutProgress = %PayoutProgress
@onready var payoutTimer = %PayoutTimer

var exploring = false
var data = {}
var claimAmount = [0, 0]

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	activeToggle.connect("pressed", Callable(self, "_start_exploring"))
	payoutTimer.connect("timeout", Callable(self, "_update_resource"))
	
	_set_display()
	
func _process(delta : float) -> void:
	payoutProgress.value = 0 if payoutTimer.is_stopped() else abs((payoutTimer.time_left / payoutTimer.wait_time) - 1.0)

func _start_exploring() -> void:
	if not exploring:
		activeToggle.text = "Stop"
		payoutTimer.paused = false
	else:
		activeToggle.text = "Start"
		payoutTimer.paused = true

	exploring = not exploring
	
func _update_resource() -> void:
	resource.update_money(claimAmount[0])
	resource.update_exp(claimAmount[1])
	explorationProgress.value += claimAmount[1]
	
	_update_loot()
	
	unitInventory.update_hero_display()
	unitInventory.update_shop_cost()
	
func _update_loot() -> void:
	for loot in data["Loot"]:
		var roll = rng.randf()
		if roll < data["Loot"][loot] * (claimAmount[1] / float(data["MaxExpAmount"])):
			inventory.add_item(loot, 1)

func _set_display() -> void:
	areaName.text = str("[b]", data["Name"], "[/b]")
	explorationProgress.max_value = data["ExploreCompletion"]
	payoutTimer.wait_time = data["ExploreTimer"]
	payoutTimer.paused = true
	
func update_claim_amount(pExplorationPower : int) -> void:
	if claimAmount[0] < data["MaxMoneyAmount"]:
		claimAmount[0] = clampf(pExplorationPower * float(data["MoneyBase"]), 0.0, data["MaxMoneyAmount"])
	if claimAmount[1] < data["MaxExpAmount"]:
		claimAmount[1] = clampf(pExplorationPower * float(data["ExpBase"]), 0.0, data["MaxExpAmount"])
		
	moneyRate.text = str("[right]", String.num_scientific(claimAmount[0] / float(data["ExploreTimer"])), "/sec[/right]")
	expRate.text = str("[right]", String.num_scientific(claimAmount[1] / float(data["ExploreTimer"])), "/sec[/right]")
	

