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
@export var retreatpoints : Array[Node2D]
@export var explodeondeathyn : bool
@export var _ProjectileSpeed : float
@export var ExplosionHitboxShape : Shape2D
var revolverpickupdrop = preload("res://Resource/Pickups/RevolverPickup.tres")
var idle = true	
var is_staggered = false
@onready var downcast = $RayCast2D
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var has_staggered = false
@onready var StaggerSprite = $StaggerSprite
#@onready var DeathsoundPlayer = $Hitsound
#var Deathsound = preload("res://Sounds/SFX/splattt-6295.mp3")
var deathscene = preload("res://Scenes/Enemies/EnemyDeath.tscn")
@onready var retreatnode = $retreat
signal staggeredkill
var currentside : int
var doubledspeed : int
var AssignedWave : Node2D
@onready var StateMachine = $StateMachine
var iswaveenemy = false
var staggerkilled = false
@export var IsBoss = false
@onready var explosionanimatedsprite = $ExplosionAnimatedSprite
@onready var explosionaudio = $AudioStreamPlayer2D
func applyknockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	
func LoadEnemy(): 
	EnemyName = Enemy.Name
	EnemyHealth = Enemy.Health
	EnemyAI = Enemy.AI_Package
	MovementSpeed = Enemy.MovementSpeed
	EnemyAttackType = Enemy.Attack_Type
	explodeondeathyn = Enemy.explodeondeath
	$EnemySprite.texture = Enemy.EnemySprite
	$EnemySprite.offset.x = 10.575
	doubledspeed = Enemy.doubledspeed
	_ProjectileSpeed = Enemy.ProjectileSpeed
	explosionanimatedsprite.visible = false
	
func _ready() -> void:
	if Enemy == null:
		pass
	else:
		LoadEnemy()
	if iswaveenemy == true:
		StateMachine.on_child_transition(StateMachine.current_state,"NewFollow")

func die():
	var Deathscene = deathscene.instantiate()
	var camera = get_tree().get_first_node_in_group("Camera")
	Deathscene.global_position = global_position
	if explodeondeathyn == true:
		Deathscene.explodeondeath = true
	else:
		pass
	get_parent().add_child(Deathscene)
	if staggerkilled == true:
		camera.ZoomIn(Deathscene)
	call_deferred("queue_free")
	if AssignedWave == null:
		return
	else:
		AssignedWave.addenemykill()

func TakeDamage(Amount):
	EnemyHealth -= Amount
	hit_flash_anim_player.active = true
	hit_flash_anim_player.play("Hit_Flashhh")

func Staggerkill():
	var player = get_tree().get_first_node_in_group("Player")
	staggerkilled = true
	if player == null:
		return
	else:
		player.StaggerAmmoRefill()

func _process(delta: float) -> void:
	if EnemyHealth <= 0:
		die()
	if EnemyHealth <=10 and EnemyHealth > 0:
		if self.has_node("StateMachine") and has_staggered == false:
			StateMachine.on_child_transition(StateMachine.current_state,"Staggered")
			has_staggered = true
		else:
			return
		
func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.x > 0:
		$EnemySprite.flip_h = false
	else:
		$EnemySprite.flip_h = true

func createexplosive():
	var camera = get_tree().get_first_node_in_group("Camera")
	explosionanimatedsprite.visible = true
	explosionanimatedsprite.play()
	camera.ScreenShake(35,0.2)
	explosionaudio.play()
	var HurtEnemyhitbox = HitboxRewite.new(15, 0.5, ExplosionHitboxShape, 0, 30)
	add_child(HurtEnemyhitbox)
	HurtEnemyhitbox.global_position = global_position
	await explosionanimatedsprite.animation_finished

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		if area.explosive == true:
			createexplosive()
			area.queue_free()
		else:
			var a = area.damage
			TakeDamage(a)
			area.queue_free()
