extends Node2D
@onready var Dialogue = get_tree().get_first_node_in_group("Dialogue")
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var battleui = get_tree().get_first_node_in_group("BattleUI")
@export var subject : CharacterBody2D
@export var walkpoint : Node2D
var hasdone = false
@export var NewDialogueArray : Array[String]
@export var NewNameArray : Array[String]
var finaldialoguetriggered = false

func _process(delta: float) -> void:
	if subject == null:
		if hasdone == false:
			finalcutscene()
			hasdone = true

func finalcutscene():
	camera.target = walkpoint
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", walkpoint.global_position, 1)
	await tween.finished
	Dialogue.TextArray = NewDialogueArray
	Dialogue.NameArray = NewNameArray
	finaldialoguetriggered = true
	Dialogue.Show()
	Dialogue.firstcall()
	



func _on_dialogue_dialogue_finished() -> void:
	if finaldialoguetriggered == true:
		battleui.fadeout()
		battleui.hideUI()
		battleui.pause()
		get_tree().change_scene_to_file("res://endingbutnotreally2.tscn")
	else:
		return
