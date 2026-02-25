extends Node2D

var CanMelee = true
var HitboxActive = false
var swung = true
var HitboxOffsetX = 0
@onready var timer = $Timer
@onready var Hitbox = $HitBoxBase
@onready var CooldownTimer = $CooldownTimer
@onready var InitialhitboxResource = "res://Resource/Hitboxes/EmptyHitbox.tres"
@onready var AfterHitboxResource = "res://Resource/Hitboxes/PlayerMeleeHitbox.tres"
var hascheckedmouseposition = false
@onready var sprite= $Sprite2D
@export var HitboxShape = 3
var sprite_rotation = 0
signal Damage

func _ready() -> void:
#	Hitbox.hitbox = load(InitialhitboxResource)
#	Hitbox.loadhitbox()
	sprite.visible = false

func _process(delta: float) -> void:
	if CanMelee == true:
		if Input.is_action_just_pressed("Melee"):
			timer.start()
			sprite.visible = true
			CooldownTimer.start()
			CanMelee = false
			hascheckedmouseposition = true
		#	Hitbox.hitbox = load(AfterHitboxResource)
		#	Hitbox.loadhitbox()
			var hitbox = HitboxRewite.new(10, 0.5, h)
			add_child(hitbox)
			Hitbox.activated = true
			HitboxActive = true
			if hascheckedmouseposition == true:
				var mouse_pos = get_global_mouse_position()
				Hitbox.look_at(mouse_pos)
				sprite.look_at(mouse_pos)
				hascheckedmouseposition = false
				swung = false
			if swung == false:
				var tween = create_tween()
				tween.tween_property(sprite, "rotation", deg_to_rad(sprite.rotation_degrees + 90), 0.2)


func _on_timer_timeout() -> void:
	HitboxActive = false
	Hitbox.hitbox = load(InitialhitboxResource)
	Hitbox.loadhitbox()
	sprite.visible = false
	swung = true
	Hitbox.activated = false


func _on_cooldown_timer_timeout() -> void:
	CanMelee = true

func _on_hit_box_base_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		var EnemyParent = area.get_parent()
		EnemyParent.TakeDamage(5)
