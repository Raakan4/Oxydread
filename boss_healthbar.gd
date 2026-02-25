extends Control
@export var subject : CharacterBody2D
@onready var Progress_Bar = $ProgressBar

func _process(delta: float) -> void:
	if subject == null:
		visible = false
	else:
		Progress_Bar.value = subject.EnemyHealth
