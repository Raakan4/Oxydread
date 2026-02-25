extends Node2D
@onready var animplayer = $AnimationPlayer
@export var TextArray2 : Array[String]
@export var NameArray2 : Array[String]
@onready var dialogue = $CanvasLayer/Dialogue
@export var endingdestination : PackedScene
func fadein():
	animplayer.play("FadeToBlack")
	
func fadeout():
	animplayer.play("FadeToNormal")

	
func _ready() -> void:
	fadeout()
	
func _on_dialogue_dialogue_finished() -> void:
	get_tree().change_scene_to_packed(endingdestination)
