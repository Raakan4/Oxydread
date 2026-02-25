extends States
class_name EnemyUnstuck

@export var enemy : CharacterBody2D
@export var speed := 140
var player : CharacterBody2D
var playerlastpos :Vector2
@onready var Hitbox = $"../../HitBoxBase"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"

func lunge():
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "position", playerlastpos * -1 , 0.45)
	Hitbox.loadhitbox()
	Hitbox.look_at(playerlastpos)
	
	await tween.finished
	Transitioned.emit(self, "Follow")
	Hitbox.activated = false	

func enter():
	player = get_tree().get_first_node_in_group("Player")
	playerlastpos = player.global_position
	print(playerlastpos)
	Hitbox.activated = true
	Hitbox.hitbox = load(hitboxresource)
	
func Physics_Update(delta: float):
	lunge()
