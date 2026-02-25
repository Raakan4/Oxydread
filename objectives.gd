extends Control

@onready var label = $Label
@export var ObjectiveArray : Array[String]
@export var InitialText : String

func _ready() -> void:
	label.text = InitialText

func ChangeObjective(thing):
	label.text = thing
