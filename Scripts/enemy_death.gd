extends Node2D

var originalowner : CharacterBody2D
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var audioplayer = $AudioStreamPlayer2D
var deathsound = load("res://Sounds/SFX/splattt-6295.mp3")
var explodesound = load("res://Sounds/SFX/DSGNImpt_EXPLOSION-Cruncher_HY_PC-002.wav")
@onready var Despawn = $DespawnTimer
var explodeondeath = false
@export var ExplosionHitboxShape : Shape2D

func _ready() -> void:
	audioplayer.stream = deathsound
	audioplayer.play()
	$CPUParticles2D.emitting = true
	checkexplosion()
	
func _on_despawn_timer_timeout() -> void:
	queue_free()

func checkexplosion():
	if explodeondeath == true:
		$PointLight2D.enabled = true
		$AnimatedSprite2D.play()
		camera.ScreenShake(35,0.2)
		audioplayer.stream = explodesound
		audioplayer.play()
		var HurtPlayerhitbox = HitboxRewite.new(15, 0.5, ExplosionHitboxShape, 1, 30)
		add_child(HurtPlayerhitbox)
		var HurtEnemyhitbox = HitboxRewite.new(15, 0.5, ExplosionHitboxShape, 0, 30)
		add_child(HurtEnemyhitbox)
		HurtPlayerhitbox.global_position = global_position
		HurtEnemyhitbox.global_position = global_position
		await $AnimatedSprite2D.animation_finished
		$PointLight2D.enabled = false
	else:
		return
