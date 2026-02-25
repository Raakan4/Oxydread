extends Node2D

@export var Associated_Wave : Node2D
@export var Wave1 = []
@export var Wave2 = []
@export var Wave3 = []
@export var Wave4 = []
@export var Wave5 = []
@export var Wave6 = []
var SpawnArray = [Wave1,Wave2,Wave3,Wave4,Wave5,Wave6]

func SpawnEnemy(CurrentWave):
	SpawnArray = [Wave1,Wave2,Wave3,Wave4,Wave5,Wave6]
	if SpawnArray[CurrentWave] == null:
		return
	else:
		if CurrentWave != Associated_Wave._Waves:
			var Spawn = SpawnArray[CurrentWave][0].instantiate()
			Spawn.Enemy = SpawnArray[CurrentWave][1]
			Spawn.iswaveenemy = true
			Spawn.global_position = self.global_position
			Spawn.AssignedWave = Associated_Wave
			owner.add_child(Spawn)
			return
		if Associated_Wave._Waves == null:
			print("niggaaaa")
		else:
			return
