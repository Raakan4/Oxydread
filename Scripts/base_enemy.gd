@tool
extends CharacterBody2D

@export var Enemy : Base_Enemy:
	set(value):
		Enemy = value
		if Engine.is_editor_hint():
			LoadEnemy()

@export var EnemyName : String
@export var EnemyHealth : int
@export var EnemyAI : String
@export var MovementSpeed : int 
@export var EnemyAttackType : String
@onready var hit_flash_anim_player = $HitFlashAnimation
var idle = true	
var is_staggered = false

func LoadEnemy(): 
	EnemyName = Enemy.Name
	EnemyHealth = Enemy.Health
	EnemyAI = Enemy.AI_Package
	MovementSpeed = Enemy.MovementSpeed
	EnemyAttackType = Enemy.Attack_Type
	$EnemySprite.texture = Enemy.EnemySprite
	
func _ready() -> void:
	if Enemy == null:
		pass
	else:
		LoadEnemy()

func TakeDamage(Amount):
	EnemyHealth -= Amount

func _process(delta: float) -> void:
	if EnemyHealth == 0:
		queue_free()
	if EnemyHealth <=5 and EnemyHealth < 0:
		pass

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.x > 0:
		$EnemySprite.flip_h = false
	else:
		$EnemySprite.flip_h = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		var a = area.damage
		TakeDamage(a)
		hit_flash_anim_player.play("hit_flash")
		print(EnemyHealth)
