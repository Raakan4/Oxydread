class_name PlayerController
extends CharacterBody2D

@export var speed = 500
var Startinghealth = 100
var maxhealth = 100
var canhit = true
@export var ghost_node : PackedScene
@export var RetreatNodes : Array[Node2D]
@onready var ghost_timer = $GhostTimer
@onready var dashparticle = $GPUParticles2D
@onready var dash_timer = $DashTimer
@onready var sprite = $AnimatedSprite2D
@onready var getcamera = get_tree().get_first_node_in_group("Camera")
@onready var Hurtsound = $HurtSound
const dodge_speed : float = 750.0
const dodge_duration : float = 0.3
var dodge_roll_dir : Vector2 = Vector2.ZERO
var dodge_roll_timer : float = 0.0
var taking_damage = false
var dead = false
var mouse_pos = get_global_mouse_position()
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var canbehit = true
var can_move = true
@onready var hitstopinvis = $HitstopInvisTimer
@onready var player = $AnimatedSprite2D
signal StartedDashing 
signal StoppedDashing
signal HealthChange(NewHealth)
signal died
signal StaggeredKill
signal StaggeredHealthBonus


func hit_stop(timeScale, duration):
	Engine.time_scale = timeScale
	var timer = get_tree().create_timer(timeScale * duration)
	await timer.timeout
	Engine.time_scale = 1
	
func _physics_process(delta):
	#var input_direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	#if input_direction.length() > 0:
	#	input_direction = input_direction.normalized()
	#velocity = input_direction * speed
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	if dodge_roll_timer > 0.0:
		_dodge_logic(delta)
	else:
		_movement(delta)
	move_and_slide()

func Heal(Amount):
	Startinghealth += Amount
	if Startinghealth > maxhealth:
		Startinghealth = maxhealth
	HealthChange.emit(Startinghealth)
	return


func StaggerAmmoRefill():
	StaggeredKill.emit()
	Heal(randi_range(10,15))
	return	

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Shift"):
	#	dash()
	#pass
func _process(_delta: float) -> void:
	if Startinghealth > maxhealth:
		Startinghealth = maxhealth
	if Startinghealth <= 0:
		died.emit()
		dead = true
		self.visible = false
		$DeathParticle.emitting = true
		$DeathParticleTimer.start()
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, false)
	mouse_pos = wrap(rotation_degrees,0,360)
	
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, sprite.scale)
	get_tree().current_scene.add_child(ghost)

func _movement(delta: float) -> void:
	if can_move == true:
		var input_vector = Vector2	(
			Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"),
			Input.get_action_strength("DOWN") - Input.get_action_strength("UP")
		).normalized()
		speed = 500
		velocity = lerp(velocity, input_vector * speed, 22.0 * delta)
		if Input.is_action_just_pressed("Shift"):
			if input_vector != Vector2.ZERO:
				dash(input_vector)
			elif velocity.length() > 0.1:
				dash(velocity.normalized())
	else:
		velocity = Vector2(0,0)
	

#func TakeDamage(attack: Attack):
#	Startinghealth -= attack.attack_damage
#	velocity = (global_position - attack.attack_position).normalized() * attack.attack_knockback
#	taking_damage = true
#	HealthChange.emit(Startinghealth)

func applyknockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func TakeDamage(damage): #Temporary
	if canbehit == true:
		Startinghealth -= damage
		taking_damage = true
		HealthChange.emit(Startinghealth)
		canbehit = false
		hit_stop(0.05,0.7)
		hitstopinvis.start()
		getcamera.ScreenShake(45,0.3)
		Hurtsound.play()
	else:
		return

func dash(direction: Vector2) -> void:
	dodge_roll_dir = direction
	dodge_roll_timer = dodge_duration
	canhit = false
	StartedDashing.emit()
	
	ghost_timer.start()
	#dash_timer.start()
	dashparticle.emitting = true
#	var tween = get_tree().create_tween()
#	tween.tween_property(self, "position", position + velocity * 0.6, 0.45)
	
#	await tween.finished
#	ghost_timer.stop()
#	dashparticle.emitting = false

func _dodge_logic(delta: float) -> void:
	var elapsed_percent = 1.0 - (dodge_roll_timer / dodge_duration)
	var current_speed = lerp(dodge_speed, dodge_speed , elapsed_percent)
	
	velocity = dodge_roll_dir * current_speed
	dodge_roll_timer -= delta
	
	if dodge_roll_timer <= 0.0:
		dodge_roll_dir = Vector2.ZERO
		ghost_timer.stop()
		dashparticle.emitting = false
		canhit = true
		StoppedDashing.emit()

func _on_ghost_timer_timeout() -> void:
	add_ghost() # Replace with function body.

func _on_player_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		if area.activated == true:
			if area.IsOwnedByEnemy == true:
				TakeDamage(10)
				var knockback_direction = ((area.global_position - global_position) * -1).normalized()
				applyknockback(knockback_direction,700.0, 0.30)
#			area.applyknockback(knockback_direction,150.0, 0.12)


func _on_death_particle_finished() -> void:
	$DeathParticle.emitting = false


func _on_hitstop_invis_timer_timeout() -> void:
	canbehit = true
