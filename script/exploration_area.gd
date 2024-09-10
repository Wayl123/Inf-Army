extends PanelContainer

@onready var areaName : Node = %AreaName
@onready var activeToggle : Node = %ActiveToggle
@onready var moneyRate : Node = %MoneyRate
@onready var expRate : Node = %ExpRate
@onready var lootList : Node = %PossibleLoot
@onready var explorationProgress : Node = %ExplorationProgress
@onready var payoutProgress : Node = %PayoutProgress
@onready var payoutTimer : Node = %PayoutTimer

var id : String
var exploring : bool = false
var data : Dictionary
var claimAmount : Array[float] = [0, 0]

var rng : Object = RandomNumberGenerator.new()

func _ready() -> void:
	activeToggle.connect("pressed", Callable(self, "_start_exploring"))
	payoutTimer.connect("timeout", Callable(self, "_update_resource"))
	
	_update_display()
	
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
	explorationProgress.value += claimAmount[1]
	
	GlobalData.ref.gameData.update_money(claimAmount[0])
	GlobalData.ref.gameData.update_exp(claimAmount[1])
	_update_area_saved_data()
	
	_update_loot()
	
	UnitInventory.ref.update_hero_display()
	UnitInventory.ref.update_shop_cost()
	
func _update_loot() -> void:
	for loot in data["Loot"]:
		var roll : float = rng.randf()
		if roll < data["Loot"][loot] * (claimAmount[1] / float(data["MaxExpAmount"])):
			Inventory.ref.add_item(loot, 1)

func _update_display() -> void:
	areaName.text = str("[b]", data["Name"], "[/b]")
	explorationProgress.max_value = data["ExploreCompletion"]
	payoutTimer.wait_time = data["ExploreTimer"]
	payoutTimer.paused = true
	
func _update_area_saved_data() -> void:
	var areaProgress : Dictionary
	
	areaProgress["Progress"] = explorationProgress.value
	areaProgress["Exploring"] = exploring
	
	GlobalData.ref.gameData.update_exploration_area({id: areaProgress})
	
func update_claim_amount(pExplorationPower : float) -> void:
	if claimAmount[0] < data["MaxMoneyAmount"]:
		claimAmount[0] = clampf(pExplorationPower * float(data["MoneyBase"]), 0.0, data["MaxMoneyAmount"])
	if claimAmount[1] < data["MaxExpAmount"]:
		claimAmount[1] = clampf(pExplorationPower * float(data["ExpBase"]), 0.0, data["MaxExpAmount"])
		
	moneyRate.text = str("[right]", String.num_scientific(claimAmount[0] / float(data["ExploreTimer"])), "/sec[/right]")
	expRate.text = str("[right]", String.num_scientific(claimAmount[1] / float(data["ExploreTimer"])), "/sec[/right]")
	
func update_saved_data(pData : Dictionary) -> void:
	if pData.has("Progress"): explorationProgress.value = pData["Progress"]
	if pData.has("Exploring") and pData["Exploring"]: _start_exploring()
