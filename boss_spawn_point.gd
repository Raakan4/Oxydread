extends Node2D
@export var TypeofEnemy = []

func SpawnEnemy():
	var Spawn = TypeofEnemy[0].instantiate()
	Spawn.Enemy = TypeofEnemy[1]
	Spawn.global_position = self.global_position
	get_tree().get_root().add_child(Spawn)
