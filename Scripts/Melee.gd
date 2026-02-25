extends Node2D

var CanMelee = true
var HitboxActive = false
var swung = true
var HitboxOffsetX = 0
@onready var timer = $Timer
@onready var CooldownTimer = $CooldownTimer
var hascheckedmouseposition = false
@onready var sprite= $Sprite2D
@export var HitboxShape : Shape2D
var sprite_rotation = 0
@onready var camera = get_tree().get_first_node_in_group("Camera")
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
			var hitbox = HitboxRewite.new(5, 0.5, HitboxShape, 0, 30)
			add_child(hitbox)
			HitboxActive = true
			if hascheckedmouseposition == true:
				var mouse_pos = get_global_mouse_position()
				#hitbox.look_at(mouse_pos)
				look_at(mouse_pos)
				hitbox.global_position = $Node2D.global_position
				sprite.look_at(mouse_pos)
				hascheckedmouseposition = false
				swung = false
			if swung == false:
				var tween = create_tween()
				tween.tween_property(sprite, "rotation", deg_to_rad(sprite.rotation_degrees + 90), 0.2)

 
func _on_timer_timeout() -> void:
	HitboxActive = false
	sprite.visible = false
	swung = true


func _on_cooldown_timer_timeout() -> void:
	CanMelee = true

func _on_hit_box_base_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		var EnemyParent = area.get_parent()
		EnemyParent.TakeDamage(1)

	#	var knockback_direction = ((area.global_position - global_position) * -1).normalized()
	#	EnemyParent.applyknockback(knockback_direction,700.0, 0.5)
