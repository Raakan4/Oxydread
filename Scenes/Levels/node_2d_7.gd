extends Node2D
@onready var battleui = get_tree().get_first_node_in_group("BattleUI")

func _ready() -> void:
	battleui.fadeout()
	battleui.unhideUI()
