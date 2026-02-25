extends States
class_name EnemyKnockback

@export var enemy: CharacterBody2D
@export var move_speed := 50.0
var player : CharacterBody2D

var move_direction : Vector2
var wander_time : float
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
@onready var HitsoundPlayer = $"../../Hitsound"
var Hitsound = preload("res://Sounds/SFX/DSGNImpt_MELEE-Hollow Punch_HY_PC-004.wav")
@onready var sprite = $"../../EnemySprite"
const DEFAULT_MODULATE = Color.WHITE

func applyknockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func enter():
	player = get_tree().get_first_node_in_group("Player")
	var knockback_direction = ((player.global_position - enemy.global_position) * -1).normalized()
	applyknockback(knockback_direction,250.0, 0.25)
	HitsoundPlayer.stream = Hitsound
	HitsoundPlayer.play()
	sprite.flip_h = false
	enemy.set_collision_layer_value(1, true)
	enemy.set_collision_mask_value(1, true)
	enemy.modulate = DEFAULT_MODULATE
	
func update(delta: float):
	pass
		
func Physics_Update(delta: float):
	if knockback_timer > 0.0:
		enemy.velocity = knockback
		knockback_timer -= delta
	if knockback_timer <= 0.0:
		enemy.set_collision_layer_value(1, false)
		enemy.set_collision_mask_value(1, false)
		Transitioned.emit(self,"Idle")
		knockback = Vector2.ZERO
		sprite.flip_h = true
#	var knockback_direction = ((global_position - global_position) * -1).normalized()
#	applyknockback(knockback_direction,700.0, 0.30)
