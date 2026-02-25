extends Control
@onready var NamePanel = $Panel2
@onready var MainPanel = $Panel
@export var TextArray : Array[String]
@export var NameArray : Array[String]
var charactersize : int
var current_characters : int
var DialogueIndex = -1
@onready var MainLabel = $MainLabel
@onready var NameLabel = $Label
var FinalArraySize = TextArray.size()
signal DialogueFinished
signal FinalDialogueFinished
@onready var root = $".."
@export var active = false
var finaldialogue = false
var selfactivate = true	
func loaddialogue(number):
		MainLabel.text = TextArray[number]
		NameLabel.text = NameArray[number]

func Show():
	visible = true
	active = true	

func firstcall():
	DialogueIndex = 0
	loaddialogue(0)

func _ready() -> void:
	if selfactivate == true:
		firstcall()

func _input(event: InputEvent) -> void:
	if active == true:
		if event.is_action_pressed("Interact"):
			FinalArraySize = TextArray.size()
			print(DialogueIndex)
			DialogueIndex += 1
			if DialogueIndex == FinalArraySize :
				DialogueFinished.emit()
				active = false
				visible = false
				DialogueIndex = -1
			else:
				loaddialogue(DialogueIndex)
