extends Node2D

@onready var label = $TutorialLabel
@onready var label2 = $ControlsLabel
@onready var Startenemy = $"../Enemy_Base"
@onready var DemoEndScreen = $"../CanvasLayer/DemoEndScreen"
@onready var BattleUI = $"../CanvasLayer/BattleUI"
@onready var EnemiesAlive = 2
signal BeatenDemo

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

#func _process(delta: float) -> void:
	#if EnemiesAlive == 0:
	#	BattleUI.visible = false
	#	BeatenDemo.emit()


func _on_enemy_base_demo_killed() -> void:
	EnemiesAlive -= 1


func _on_enemy_base_2_demo_killed() -> void:
	EnemiesAlive -= 1


func _on_pickup_base_node_give_ammo(WeaponType2: Variant, AmmoQuantity: Variant) -> void:
	label.text = "Press R to reload"
