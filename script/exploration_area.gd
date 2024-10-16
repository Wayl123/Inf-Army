extends PanelContainer

@onready var areaName : Node = %AreaName
@onready var activeToggle : Node = %ActiveToggle
@onready var moneyRate : Node = %MoneyRate
@onready var expRate : Node = %ExpRate
@onready var lootList : Node = %PossibleLoot
@onready var explorationProgress : Node = %ExplorationProgress
@onready var payoutProgress : Node = %PayoutProgress
@onready var payoutTimer : Node = %PayoutTimer
@onready var powerLock : Node = %PowerLock
@onready var unlockReq : Node = %UnlockReq

var id : String
var gameData : Dictionary = GlobalData.ref.gameData.explorationArea
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
	if not gameData[id]["Exploring"]:
		if Exploration.ref.exploringCount < GlobalData.ref.gameData.maxExplore:
			activeToggle.text = "Stop"
			payoutTimer.paused = false
			Exploration.ref.exploringCount += 1
			gameData[id]["Exploring"] = not gameData[id]["Exploring"]
	else:
		activeToggle.text = "Start"
		payoutTimer.paused = true
		Exploration.ref.exploringCount -= 1
		gameData[id]["Exploring"] = not gameData[id]["Exploring"]
		
	Exploration.ref.update_max_explore()
	
func _update_resource() -> void:
	gameData[id]["Progress"] = minf(gameData[id]["Progress"] + (claimAmount.reduce(func(sum, number): return sum + number) / claimAmount.size()), explorationProgress.max_value)
	explorationProgress.value = gameData[id]["Progress"]
	
	if abs(explorationProgress.max_value - gameData[id]["Progress"]) < 0.00001:
		_unlock_area()
	
	GlobalData.ref.gameData.update_money(claimAmount[0])
	GlobalData.ref.gameData.update_exp(claimAmount[1])
	
	_update_loot()
	
	UnitInventory.ref.update_hero_display()
	UnitInventory.ref.update_shop_cost()
	
func _update_loot() -> void:
	for loot in data["Loot"]:
		var roll : float = rng.randf()
		if roll < data["Loot"][loot] * (claimAmount[1] / float(data["MaxExpAmount"])):
			GlobalData.ref.gameData.update_inventory_item({loot: 1})
			
func _unlock_area() -> void:
	for area in data["Unlocks"]:
		if not gameData.has(area):
			GlobalData.ref.gameData.update_exploration_area({area : {}})

func _update_display() -> void:
	areaName.text = str("[b]", data["Name"], "[/b]")
	explorationProgress.max_value = data["ExploreCompletion"]
	payoutTimer.wait_time = data["ExploreTimer"]
	payoutTimer.start()
	payoutTimer.paused = true
	if gameData[id].has("Unlocked") and gameData[id]["Unlocked"]: _unlock_power_lock() 
	else: gameData[id]["Unlocked"] = false
	if gameData[id].has("Progress"): explorationProgress.value = gameData[id]["Progress"]
	if gameData[id].has("Exploring") and gameData[id]["Exploring"]: 
		activeToggle.text = "Stop"
		payoutTimer.paused = false
		Exploration.ref.exploringCount += 1
		
func _unlock_power_lock() -> void:
	powerLock.visible = false
	powerLock.size_flags_horizontal = SIZE_SHRINK_BEGIN
	
func update_claim_amount(pExplorationPower : float) -> void:
	if claimAmount[0] < data["MaxMoneyAmount"]:
		claimAmount[0] = clampf(pExplorationPower * float(data["MoneyBase"]), 0.0, data["MaxMoneyAmount"])
	if claimAmount[1] < data["MaxExpAmount"]:
		claimAmount[1] = clampf(pExplorationPower * float(data["ExpBase"]), 0.0, data["MaxExpAmount"])
		
	if not gameData[id]["Unlocked"] and pExplorationPower >= data["UnlockReq"]:
		_unlock_power_lock()
		gameData[id]["Unlocked"] = true
	else:
		unlockReq.text = str("[center]Required Exploration Power: ", pExplorationPower, "/" , data["UnlockReq"])
		
	moneyRate.text = str("[right]", String.num_scientific(claimAmount[0] / float(data["ExploreTimer"])), "/sec[/right]")
	expRate.text = str("[right]", String.num_scientific(claimAmount[1] / float(data["ExploreTimer"])), "/sec[/right]")
