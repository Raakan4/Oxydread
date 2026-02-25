extends Area2D

@export var hitbox : HitboxBase:
	set(value):
		hitbox = value
		if Engine.is_editor_hint():
			loadhitbox()
@export var Positionx : float
@export var Positiony : float
@export var ScaleX : float
@export var ScaleY : float
@export var Rotation : float
@export var IsOwnedByEnemy : bool
@export var damage : int
@onready var shape = $CollisionShape2D
@export var knockback : float
@export var attack_position : Vector2
var activated = false
signal Takedamage(Amount)

func loadhitbox() :
	ScaleX = hitbox.ScaleX
	ScaleY = hitbox.ScaleY
	IsOwnedByEnemy = hitbox.OwnedByEnemy
	damage = hitbox.damage
	scale.x = ScaleX
	scale.y = ScaleY
	shape.position = Vector2(hitbox.offsetX)

#func _on_area_entered(area: Area2D) -> void:
#	if area.has_method("TakeDamage"):
#		var attack = Attack.new()
#		attack.attack_damage = damage
#		attack.attack_knockback = knockback
#		attack.attack_position =  global_position
#		area.TakeDamage(attack)
#		print("damgaed")


#func _on_lunge_attack_reloadhitbox() -> void:
#	loadhitbox()
