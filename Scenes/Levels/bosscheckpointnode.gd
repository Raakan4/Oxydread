extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if GlobalVariables.BossCheckpoint == true:
		player.global_position = self.global_position
