extends Node2D

@onready var interaction_area : InteractionArea = $Interaction
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var Sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var battleui = get_tree().get_first_node_in_group("BattleUI")
@onready var objective = get_tree().get_first_node_in_group("Objective")
@export var interactable = true
@export var tppoint : Node2D
func _ready() -> void:
	if interactable == true:
		interaction_area.interact = Callable(self, "_on_interact")
	else:
		return

func _on_interact() -> void:
	camera.target = self
	battleui.counting = false
	objective.ChangeObjective("- Get Inside the facility")
	battleui.hideUI()
	battleui.pause()
	battleui.resetcount()
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", self.global_position + Vector2(0,-20), 1)
	await tween.finished
	player.visible = false
	var tween2 = get_tree().create_tween()
	tween2.tween_property(Sprite, "position:y", 100, 4)
	$MoveBoatTimer.start()
	await  tween2.finished
	camera.target = player
	player.global_position = tppoint.global_position
	player.visible = true
	battleui.fadeout()
	battleui.counting = true
	$Unfade.start()

func _on_move_boat_timer_timeout() -> void:
	battleui.fadein()


func _on_unfade_timeout() -> void:
	battleui.unhideUI()
