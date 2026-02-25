extends States
class_name EnemyStaggered

@export var enemy: CharacterBody2D
@export var move_speed := 0.0
var player : CharacterBody2D
signal StaggerAmmo(Index,Amount)
var move_direction : Vector2
var StaggerTime : float = 3
@onready var Hitbox = $"../../HitBoxBase"
@onready var StaggerShakeAnim = $"../../StaggerShake"
@onready var StaggerSprite = $"../../StaggerSprite"
@onready var EnemySprite = $"../../EnemySprite"
@onready var Hitsound = $"../../Hitsound"
const DEFAULT_MODULATE = Color.WHITE

func FuckingDie():
	var random_Health = randi_range(10, 20)
	var random_Ammo = randi_range(10,20)
	var PickRandomWeaponIndex = randi_range(1,4)
	player.Startinghealth += random_Health


func enter():
	enemy.modulate = DEFAULT_MODULATE
	Hitbox.activated = false
	player = get_tree().get_first_node_in_group("Player")
	Hitsound.stream = preload("res://Sounds/SFX/trench-club-2-101554.mp3")
	Hitsound.play()
	EnemySprite.offset.x = 0
	enemy.is_staggered = true
	StaggerSprite.visible = true
	StaggerShakeAnim.play("StaggerShake")
	
func update(delta: float):
	if StaggerTime > 0:
		StaggerTime -= delta
	else:
		Transitioned.emit(self, "Idle")
		enemy.is_staggered = false
		StaggerSprite.visible = false
		Hitsound.stream = preload("res://Sounds/SFX/axe-hit-flesh-02-266299.mp3")
		
func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		var direction = player.global_position - enemy.global_position
#	
#	if direction.length() < 500:
#		Transitioned.emit(self, "Follow")
