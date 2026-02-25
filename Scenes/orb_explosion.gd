extends Node2D

var originalowner : CharacterBody2D
@onready var audioplayer = $AudioStreamPlayer2D
var deathsound = load("res://Sounds/SFX/explosion-312361.mp3")
@onready var Despawn = $DespawnTimer
var explodeondeath = false
@export var ExplosionHitboxShape : Shape2D
@onready var emmiter1 = $CPUParticles2D
@onready var emitter2 = $CPUParticles2D2

func _ready() -> void:
	audioplayer.stream = deathsound
	audioplayer.play()
	emmiter1.emitting = true
	emitter2.emitting = true
	call_deferred("checkexplosion")
	
func checkexplosion():
	var HurtPlayerhitbox = HitboxRewite.new(15, 0.7, ExplosionHitboxShape, 1, 30)
	add_child(HurtPlayerhitbox)
	


func _on_timer_timeout() -> void:
	queue_free()
