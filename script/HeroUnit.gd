extends PanelContainer

@onready var resource = get_tree().get_first_node_in_group("Resource")
@onready var exploration = get_tree().get_first_node_in_group("Exploration")

@onready var levelPromotion = %LevelPromotion
@onready var unitName = %Name
@onready var unitLevel = %Level
@onready var unitExp = %Exp
@onready var unitLevelPower = %LevelPower
@onready var unitPower = %Power
@onready var promotionDetail = %PromotionDetail

var HIDDENSTYLE = preload("res://stylebox/hidden.tres")
var AVAILABLESTYLE = preload("res://stylebox/available.tres")
var SEMIAVAILABLESTYLE = preload("res://stylebox/semi_available.tres")
var NOTAVAILABLESTYLE = preload("res://stylebox/not_available.tres")
var HIDDENCOLOR = Color.hex(0xffffff00)
var VISIBLECOLOR = Color.hex(0xffffff3f)

var data = {}
var level = 1
var expReq : int

var levelButtonHovering = false
var detailExpanded = false

func _ready() -> void:
	levelPromotion.connect("mouse_entered", Callable(self, "_level_available"))
	levelPromotion.connect("mouse_exited", Callable(self, "_hide_hover"))
	levelPromotion.connect("pressed", Callable(self, "_level_or_promote"))

func _update_display() -> void:
	unitName.text = str("[center][b]", data["Name"], "[/b][/center]")
	unitLevelPower.text = str("[right]", String.num_scientific(data["LevelPower"]), "[/right]")
	
	update_level_display()
	
func _level_available() -> void:
	levelButtonHovering = true
	
	levelPromotion.text = "Level up" if level < data["MaxLevel"] else "Promote"
	levelPromotion["theme_override_colors/font_normal_color"] = VISIBLECOLOR
	levelPromotion["theme_override_colors/font_disabled_color"] = VISIBLECOLOR
	
	if resource.exp >= expReq:
		levelPromotion["theme_override_styles/hover"] = AVAILABLESTYLE
		levelPromotion.disabled = false
	elif level >= data["MaxLevel"]:
		levelPromotion["theme_override_styles/hover"] = SEMIAVAILABLESTYLE
		levelPromotion.disabled = false
	else:
		levelPromotion["theme_override_styles/disabled"] = NOTAVAILABLESTYLE
		levelPromotion.disabled = true
	
func _hide_hover() -> void:
	levelButtonHovering = false
	
	levelPromotion["theme_override_styles/disabled"] = HIDDENSTYLE
	levelPromotion["theme_override_colors/font_normal_color"] = HIDDENCOLOR
	levelPromotion["theme_override_colors/font_disabled_color"] = HIDDENCOLOR
	
func _level_or_promote() -> void:
	if level < data["MaxLevel"]:
		if resource.update_exp(-expReq):
			level += 1
			if level < data["MaxLevel"]:
				expReq = _get_exp_req()
			else:
				expReq = NAN
				
			var index = 0
			var spotFound = false
			
			while (index < get_index() and not spotFound):
				var nodePower = get_parent().get_child(index).get_power()
				
				if (get_power() >= nodePower):
					spotFound = true
				else:
					index += 1
					
			get_parent().move_child(self, index)
				
			exploration.update_exploration_power()
			get_parent().update_display()
	else:
		_expand_promotion_detail()
	
func _expand_promotion_detail() -> void:
	if not detailExpanded:
		promotionDetail.custom_minimum_size = Vector2(0, 128)
	else:
		promotionDetail.custom_minimum_size = Vector2.ZERO
		
	detailExpanded = not detailExpanded
	promotionDetail.visible = detailExpanded
	
func _get_exp_req() -> int:
	return int(float(data["ExpBase"]) * (float(data["ExpScale"]) ** (float(level) - 1)))
	
func set_data(pUnit : Dictionary) -> void:
	data = pUnit
	expReq = _get_exp_req()
	
	_update_display()
	
func update_level_display() -> void:
	var expText = ""
	
	unitLevel.text = str("[right]", String.num_scientific(level), " (Max)" if level >= data["MaxLevel"] else "", "[/right]")
	unitPower.text = str("[right]", String.num_scientific(get_power()), "[/right]")
	
	expText += str("[right]", expReq, " ")
	if resource.exp >= expReq:
		expText += "[color=#00ff00]"
	else:
		expText += "[color=#ff0000]"
	expText += str("(", resource.exp, ")[/color][/right]")
	
	unitExp.text = expText
	
	if levelButtonHovering:
		_level_available()
	
func get_power() -> int:
	return int(float(data["LevelPower"]) * float(level))
	
