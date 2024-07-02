extends PanelContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@onready var display = %AttributeDisplay
@onready var open1Button = %Open1
@onready var open10Button = %Open10
@onready var openAllButton = %OpenAll

var data = {}
var storedAmount = 0

func _ready() -> void:
	open1Button.connect("pressed", Callable(self, "update_stored_amount").bind(-1))
	open10Button.connect("pressed", Callable(self, "update_stored_amount").bind(-10))
	openAllButton.connect("pressed", Callable(self, "update_stored_amount"))
	
	display.set_display(data)

func update_stored_amount(pAmount : int = -storedAmount) -> void:
	storedAmount += pAmount
	display.update_stored_amount(storedAmount)
	
	if pAmount < 0:
		display.open_box(pAmount, pAmount < -10)
			
	if storedAmount < 10:
		open10Button.disabled = true
	else:
		open10Button.disabled = false
