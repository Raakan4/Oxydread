extends Node2D
@onready var interaction_area = $Interaction
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
@onready var battleui = get_tree().get_first_node_in_group("BattleUI")
@onready var timer = $Timer

func _on_interact():
	battleui.fadein()
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")
