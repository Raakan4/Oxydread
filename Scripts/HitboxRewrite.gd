class_name HitboxRewite extends Area2D

var attacker_damage : int
var hitbox_lifetime : float
var shape : Shape2D
var offset : Vector2
var isownedbyenemy : int
var HasHitList = []
var hashit = false
var deleteonhit = false
var source

func _init(_attacker_damage : int, _hitbox_lifetime : float, _shape : Shape2D, _isownedbyenemy : int, _offset : int,) -> void:
	attacker_damage = _attacker_damage
	hitbox_lifetime = _hitbox_lifetime
	shape =  _shape	
	isownedbyenemy = _isownedbyenemy
#	offset = _offset

func _ready() -> void:
	monitorable = false
	area_entered.connect(_on_area_entered)
	if hitbox_lifetime > 0.0:
		var new_timer = Timer.new()
		add_child(new_timer)
		new_timer.timeout.connect(queue_free)
		new_timer.call_deferred("start", hitbox_lifetime)
	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
	
	
	set_collision_layer_value(1, false )
	set_collision_mask_value(1, false )
	match isownedbyenemy:
		1:
			set_collision_mask_value(5, true )
		0: 
			set_collision_mask_value(4, true )
		

func _on_area_entered(area: Area2D) -> void:
	if not area.has_method("receive_hit"):
		return
	area.receive_hit(attacker_damage,area)
	if deleteonhit == true:
		queue_free()
		source.queue_free()
