extends Node2D

@export var Wave_Type : WaveManager:
	set(value):
		Wave_Type = value
		if Engine.is_editor_hint():
			LoadWave()
			
@export var SpawnNodes : Array[Node2D]
@export var ZombieTypes : Array[PackedScene]
@export var AssociatedBarrier : Node2D
var _WaveID : String
var _Waves : int
var CurrentWave : int
var activated = false 
var EnemiesKilled = 0
var FirstSpawned = false
var hasfinsihed = false
var objectivestring : String
@onready var WaveTimer = $NewWaveSpawnTimer

func _ready() -> void:
	if Wave_Type == null:
		pass
	else:
		LoadWave()
		objectivestring = str("- Kill ", CurrentWave, "/", SpawnNodes.size(), " To pass!")

func LoadWave():
	_WaveID = Wave_Type.WaveID
	_Waves = Wave_Type.Waves
	CurrentWave = 0

func FinishedWaves():
	AssociatedBarrier.DestroyBarrier()
	for i in SpawnNodes:
		i.queue_free()
	call_deferred("queue_free")
	
func RespawnNodes():
	for i in SpawnNodes:
		i.SpawnEnemy(CurrentWave)
	call_deferred("NextWave")
	return

func NextWave():
	CurrentWave += 1

func _process(delta: float) -> void:
	if CurrentWave == _Waves + 1:
		activated = false
		if hasfinsihed == false:
			FinishedWaves()
			hasfinsihed = true
	if activated == true:
		if FirstSpawned == false:
			WaveTimer.start()
			FirstSpawned = true
	if EnemiesKilled == SpawnNodes.size():
		EnemiesKilled = 0
		resetenemykill()
		RespawnNodes()

func addenemykill():
	EnemiesKilled += 1
	objectivestring = str("- Kill ", EnemiesKilled, "/", SpawnNodes.size(), " To pass!")
	AssociatedBarrier.changeobjective()

func resetenemykill():
	EnemiesKilled = 0
	objectivestring = str("- Kill ", EnemiesKilled, "/", SpawnNodes.size(), " To pass!")
	AssociatedBarrier.changeobjective()

func _on_new_wave_spawn_timer_timeout() -> void:
	RespawnNodes()
