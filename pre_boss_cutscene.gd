extends Area2D

@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var battleui = get_tree().get_first_node_in_group("BattleUI")
@onready var Dialogue = get_tree().get_first_node_in_group("Dialogue")
@onready var objective = get_tree().get_first_node_in_group("Objective")
@export var CameraPoint1 : Node2D
@export var playermovepoint1 : Node2D
@export var BossSpawnPoint :Node2D
@export var hasvisited = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		if hasvisited == false:
			battleui.hideUI()
			camera.target = CameraPoint1
			Dialogue.Show()
			Dialogue.firstcall()
			hasvisited = true
			objective.ChangeObjective("- Kill The Boss")
		
func _on_dialogue_dialogue_finished() -> void:
	battleui.unhideUI()
	$"../CanvasLayer/BossHealthbar".visible = true
	camera.target = player
