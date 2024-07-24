extends PanelContainer

@onready var areaName = %AreaName
@onready var activeToggle = %ActiveToggle
@onready var moneyRate = %MoneyRate
@onready var expRate = %ExpRate
@onready var lootList = %PossibleLoot
@onready var explorationProgress = %ExplorationProgress
@onready var payoutProgress = %PayoutProgress
@onready var payoutTimer = %PayoutTimer

var data = {}
var explorationPower = 0
var claimAmount = [0, 0]

func _ready() -> void:
	payoutTimer.connect("timeout", Callable(self, "_update_resource"))
	activeToggle.connect("pressed", Callable(self, "_start_exploring"))
	
	_set_display()

func _set_display() -> void:
	areaName.text = str("[b]", data["Name"], "[/b]")
	explorationProgress.max_value = data["ExploreCompletion"]
	payoutTimer.wait_time = data["ExploreTimer"]
	
	update_claim_amount()
	
func update_claim_amount() -> void:
	if claimAmount[0] < data["MaxMoneyAmount"]:
		claimAmount[0] = clampf(explorationPower * float(data["MoneyBase"]), 0.0, data["MaxMoneyAmount"])
	if claimAmount[1] < data["MaxExpAmount"]:
		claimAmount[1] = clampf(explorationPower * float(data["ExpBase"]), 0.0, data["MaxExpAmount"])
		
	moneyRate.text = str("[right]", claimAmount[0] / float(data["ExploreTimer"]), "/sec[/right]")
	expRate.text = str("[right]", claimAmount[1] / float(data["ExploreTimer"]), "/sec[/right]")
