extends States
class_name SpitChargeUp

@export var enemy : CharacterBody2D
@export var target : Node2D = null
@export var speed = 0
@export var Intentions = []
var player : CharacterBody2D
@onready var Hitbox = $"../../HitBoxBase"
@onready var DownRayCast = $"../../RayCast2D"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
var playerpos : Vector2
@export var Navigation_Agent : NavigationAgent2D
@onready var pathfindingtimer = $"../../PathfindingTimer"
var ChargeTime = 120
var intentions : Array[Node2D]
@onready var ChargeShake = $"../../ChargeShake"

func SpitChargeup(time):
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "modulate", Color.GREEN , time)
	await tween.finished
	Transitioned.emit(self, "Spit")
	
func enter():
	SpitChargeup(2)
	#ChargeTime = 120

#func update(delta: float):
	#ChargeTime -= 1
	#if ChargeTime <= 0 : 
	#	Transitioned.emit(self, "Spit")
		
func Physics_Update(delta: float):
	enemy.velocity = Vector2.ZERO
