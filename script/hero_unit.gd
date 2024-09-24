extends PanelContainer

@onready var levelPromotion : Node = %LevelPromotion
@onready var unitName : Node = %Name
@onready var unitLevel : Node = %Level
@onready var unitExp : Node = %Exp
@onready var unitLevelPower : Node = %LevelPower
@onready var unitPower : Node = %Power
@onready var promotionDetail : Node = %PromotionDetail

var AVAILABLESTYLE : StyleBox = preload("res://stylebox/available.tres")
var SEMIAVAILABLESTYLE : StyleBox = preload("res://stylebox/semi_available.tres")
var NOTAVAILABLESTYLE : StyleBox = preload("res://stylebox/not_available.tres")
var VISIBLECOLOR : Color = Color.hex(0xffffff3f)

signal move_node(index : int)
signal unit_info_changed

var savedId : String:
	set(pId):
		savedId = pId
		gameData = GlobalData.ref.gameData.heroUnit
var gameData : Dictionary
var data : Dictionary
var expReq : float

var levelButtonHovering : bool = false
var detailExpanded : bool = false

func _ready() -> void:
	levelPromotion.connect("mouse_entered", Callable(self, "_level_available"))
	levelPromotion.connect("mouse_exited", Callable(self, "_hide_hover"))
	levelPromotion.connect("pressed", Callable(self, "_level_or_promote"))
	promotionDetail.connect("promote_unit", Callable(self, "_promote_unit"))

func _update_display() -> void:
	unitName.text = str("[center][b]", data["Name"], "[/b][/center]")
	unitLevelPower.text = str("[right]", String.num_scientific(data["LevelPower"]), "[/right]")
	
	update_level_display()
	
func _level_available() -> void:
	levelButtonHovering = true
	
	levelPromotion.text = "Level up" if gameData[savedId]["Level"] < data["MaxLevel"] else "Promote"
	levelPromotion.add_theme_color_override("font_color", VISIBLECOLOR)
	levelPromotion.add_theme_color_override("font_disabled_color", VISIBLECOLOR)
	
	if gameData[savedId]["Level"] >= data["MaxLevel"]:
		levelPromotion.add_theme_stylebox_override("hover", SEMIAVAILABLESTYLE)
		levelPromotion.add_theme_stylebox_override("pressed", SEMIAVAILABLESTYLE)
		levelPromotion.disabled = false
	elif GlobalData.ref.gameData.exp >= expReq:
		levelPromotion.add_theme_stylebox_override("hover", AVAILABLESTYLE)
		levelPromotion.add_theme_stylebox_override("pressed", AVAILABLESTYLE)
		levelPromotion.disabled = false
	else:
		levelPromotion.add_theme_stylebox_override("disabled", NOTAVAILABLESTYLE)
		levelPromotion.disabled = true
	
func _hide_hover() -> void:
	levelButtonHovering = false
	
	levelPromotion.remove_theme_stylebox_override("hover")
	levelPromotion.remove_theme_stylebox_override("pressed")
	levelPromotion.remove_theme_stylebox_override("disabled")
	levelPromotion.remove_theme_color_override("font_color")
	levelPromotion.remove_theme_color_override("font_disabled_color")
	
func _move_self() -> void:
	# Go from bottom up for leveling since it likely won't move much from current position
	var index : int = get_index()
	var spotFound : bool = false
	
	while (index > 0 and not spotFound):
		var nodePower : float = get_parent().get_child(index-1).get_power()
		
		if (get_power() <= nodePower):
			spotFound = true
		else:
			index -= 1
			
	move_node.emit(index)
	
func _level_or_promote() -> void:
	if gameData[savedId]["Level"] < data["MaxLevel"]:
		if GlobalData.ref.gameData.update_exp(-expReq):
			gameData[savedId]["Level"] += 1
			expReq = _get_exp_req()
			
			_move_self()
				
			Exploration.ref.update_exploration_power()
			unit_info_changed.emit()
	else:
		_expand_promotion_detail()
	
func _expand_promotion_detail() -> void:
	if not detailExpanded:
		promotionDetail.custom_minimum_size = Vector2(0, 256)
	else:
		promotionDetail.custom_minimum_size = Vector2.ZERO
		
	detailExpanded = not detailExpanded
	promotionDetail.visible = detailExpanded
	
func _get_exp_req() -> float:
	return floorf(float(data["ExpBase"]) * (float(data["ExpScale"]) ** (float(gameData[savedId]["Level"]) - 1))) if gameData[savedId]["Level"] < data["MaxLevel"] else NAN
	
func _promote_unit(pData : Dictionary) -> void:
	gameData[savedId]["BasePower"] += float(data["LevelPower"]) * float(gameData[savedId]["Level"]) + pData["Power"]
	for item in pData["Multi"]:
		if not gameData[savedId]["BaseMulti"].has(item):
			gameData[savedId]["BaseMulti"][item] = 1
		gameData[savedId]["BaseMulti"][item] += pData["Multi"][item]
	
	gameData[savedId]["Level"] = 1
	
	_expand_promotion_detail()
	set_data(pData["Data"])
	
	_move_self()
	unit_info_changed.emit()
	
func set_data(pUnit : Dictionary) -> void:
	data = pUnit
	expReq = _get_exp_req()
	promotionDetail.set_data(pUnit["Promotion"] if pUnit.has("Promotion") else {})
	
	_update_display()
	
func update_level_display() -> void:
	var expText : String = ""
	
	unitLevel.text = str("[right]", String.num_scientific(gameData[savedId]["Level"]), " (Max)" if gameData[savedId]["Level"] >= data["MaxLevel"] else "", "[/right]")
	unitPower.text = String.num_scientific(get_power())
	
	expText += str("[right]", expReq, " ")
	if GlobalData.ref.gameData.exp >= expReq:
		expText += "[color=#00ff00]"
	else:
		expText += "[color=#ff0000]"
	expText += str("(", GlobalData.ref.gameData.exp, ")[/color][/right]")
	
	unitExp.text = expText
	
	if levelButtonHovering:
		_level_available()
		
	if gameData[savedId]["Level"] >= data["MaxLevel"]:
		promotionDetail.update_display()
	
func get_power() -> float:
	return float(data["LevelPower"]) * float(gameData[savedId]["Level"]) + gameData[savedId]["BasePower"]
