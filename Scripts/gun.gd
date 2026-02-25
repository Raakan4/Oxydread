#@tool
extends Node2D

@export var Weapon_Type : Weapons:
	set(value):
		Weapon_Type = value
		if Engine.is_editor_hint():
			LoadWeapon()


@export var Name : String
@export var Damage : float
@export var Bullet  = preload("res://Scenes/Bullet.tscn")
#@onready var Weapon_Texture = %SpriteGun.texture
@export var Fire_Rate : float
@export var InitialRotation : float = rotation
@export var WeaponScale : float
@export var WeaponInventory = ["res://Resource/Weapons/Pistol.tres" ]
@export var Canshoot : bool
@export var Clipsize : int
@onready var Fireratetimer := $FireRateTimer
@onready var ReloadTimer := $ReloadTimer
@onready var ShootAudioPlayer = $GunSoundPlayer
@onready var ReloadAudioPlayer = $ReloadSoundPlayer
@onready var FireSound : AudioStream = ShootAudioPlayer.stream
@onready var ReloadSound : AudioStream = ReloadAudioPlayer.stream
@export var CurrentWeapon : String
@export var DesiredWeapon : String
@onready var Camera = $Camera2D
var newlength : int
#@onready var StartingWeapon = load(WeaponInventory[1])
var FirstLoad : bool
@onready var player = get_tree().get_first_node_in_group("Player")
var TotalAmmoTempArray = [200,0,0,0]
var ClipAmmoTempArray = [0,0,0,0]
var HasReloaded : bool = false
var isreloading = false
@export var TotalAmmo : int
@export var AmmoInClip : int
var CurrentWeaponIndex : int
var explosive : bool
signal AmmoChange(NewClipSize, NewCurrentAmmo, NewTotalAmmo)
signal ReloadBarSignal(ReloadTimerTime)

func _ready() -> void:
	visible = false
	if Weapon_Type == null:
		pass
	else:
		LoadWeapon()
		SwitchWeapon(0)
		visible = true


func LoadWeapon():
	Name = Weapon_Type.name
	$%SpriteGun.texture = Weapon_Type.Weapontexture
	Damage = Weapon_Type.damage
	Clipsize = Weapon_Type.ClipSize
	#TotalAmmo = Weapon_Type.duplicate().TotalAmmo
	#AmmoInClip = Weapon_Type.duplicate().ClipAmmo
	Canshoot = Weapon_Type.Canshoot
	Fireratetimer.wait_time = Weapon_Type.FireRate
	FireSound = Weapon_Type.FireSound
	ReloadTimer.wait_time = Weapon_Type.ReloadTime
	ReloadSound = Weapon_Type.ReloadSound
	explosive = Weapon_Type.explosive
	
func loadAmmo(x):
	var a = WeaponInventory.find(x)
	TotalAmmo = TotalAmmoTempArray[a]
	AmmoInClip = ClipAmmoTempArray[a]
	AmmoChange.emit(Clipsize, AmmoInClip, TotalAmmo)

func UpdateAmmoUI():
	var a = WeaponInventory.find(CurrentWeapon)
	AmmoChange.emit(Clipsize, ClipAmmoTempArray[a])

func Reload(x):
	var b = WeaponInventory.find(x)
	HasReloaded = false
	isreloading = true
	ReloadTimer.start()
	ReloadAudioPlayer.stream = ReloadSound
	ReloadAudioPlayer.play()
	ReloadBarSignal.emit(ReloadTimer)
	var a = Clipsize - ClipAmmoTempArray[b]
	if ClipAmmoTempArray[b] > -1 and HasReloaded == false and TotalAmmoTempArray[b] > 0:
		if ClipAmmoTempArray[b] > Clipsize:
			TotalAmmoTempArray[b] -= a
			ClipAmmoTempArray[b] += a
		if ClipAmmoTempArray[b] <= Clipsize:
			if Clipsize <= TotalAmmoTempArray[b]:
				TotalAmmoTempArray[b] -= a
				ClipAmmoTempArray[b] += a
			else:	
				ClipAmmoTempArray[b] +=  TotalAmmoTempArray[b]
				TotalAmmoTempArray[b] -= TotalAmmoTempArray[b]
		if TotalAmmoTempArray[b] < 0:
			TotalAmmoTempArray[b] = 0
		AmmoChange.emit(Clipsize, ClipAmmoTempArray[b], TotalAmmoTempArray[b])
	HasReloaded = true

func Shoot(x):
	var a = WeaponInventory.find(x)
	var b = Bullet.instantiate()
	b.pos = $ShootPoint.global_position
	b.dir = global_rotation
	b.rota = global_rotation
	b.damage = Damage
	if explosive == true:
		b.explosive = true
	ClipAmmoTempArray[a] -= 1
	AmmoChange.emit(Clipsize, ClipAmmoTempArray[a], TotalAmmoTempArray[a])
	Fireratetimer.start()
	owner.add_child(b)
	ShootAudioPlayer.stream = FireSound
	ShootAudioPlayer.play()

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	$".".look_at(mouse_pos)
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 250:
		scale.y = -1
		player.sprite.flip_h = true
	else:
		scale.y = 1
		player.sprite.flip_h = false

	if ClipAmmoTempArray[CurrentWeaponIndex] > 0 and Input.is_action_pressed("LeftClick") and Canshoot == true and isreloading == false:
		Shoot(CurrentWeapon)
		Canshoot = false
		Fireratetimer.start()
	if Input.is_action_pressed("Reload"):
		if isreloading == true:
			pass
		else:
			Reload(CurrentWeapon)

	#print(Canshoot)
	#print("Total Ammo array is ", TotalAmmoTempArray)
	#print("Clip Ammo array is ", ClipAmmoTempArray)

func _on_reload_timer_timeout() -> void:
	isreloading = false

func _on_fire_rate_timer_timeout() -> void:
	Canshoot = true

func SwitchWeapon(Number) -> void:
	if Number <= WeaponInventory.size()-1:
		Weapon_Type = load(WeaponInventory[Number])
		CurrentWeapon = WeaponInventory[Number]
		CurrentWeaponIndex = WeaponInventory.find(CurrentWeapon)
		LoadWeapon()
		print(CurrentWeaponIndex)
		loadAmmo(CurrentWeapon)
	else: 
		print("Nigga")


func _input(event: InputEvent) -> void:
	if isreloading == false:   # UNCOMMENT EVERYTHING AFTER PROTOTYPE #LOLOLOLO 
		if event.is_action_pressed("1"): #slot 1
				SwitchWeapon(0)
				visible = true
		if event.is_action_pressed("2"): # slot 2
				SwitchWeapon(1)
				visible = true
		if event.is_action_pressed("3"): # slot 3
				SwitchWeapon(2)
				visible = true
		if event.is_action_pressed("4"): #slot4
				SwitchWeapon(3)
				visible = true
	#	if event.is_action_pressed("6"):
	#			TotalAmmoTempArray[1] += 30
	else:
		pass


func _on_pickup_base_node_give_ammo(WeaponType: Variant, AmmoQuantity: Variant) -> void:
	#var a = WeaponInventory.find(WeaponType)
	var a = WeaponInventory.find("res://Resource/Weapons/Revolver.tres")
	TotalAmmoTempArray[a] += AmmoQuantity
	AmmoChange.emit(Clipsize, ClipAmmoTempArray[a], TotalAmmoTempArray[a])

func _on_player_controller_started_dashing() -> void:
	Canshoot = false # Replace with function body.

func _on_player_controller_stopped_dashing() -> void:
	Canshoot = true # Replace with function body.

func _on_demo_pickup_demo_pickedup() -> void:
	TotalAmmoTempArray[0] += 30
	Weapon_Type = load(WeaponInventory[0])
	CurrentWeapon = WeaponInventory[0]
	CurrentWeaponIndex = WeaponInventory.find(CurrentWeapon)
	LoadWeapon()
	print(CurrentWeaponIndex)
	loadAmmo(CurrentWeapon)
	AmmoChange.emit(Clipsize, ClipAmmoTempArray[0], TotalAmmoTempArray[0])


func _on_player_controller_died() -> void:
	Canshoot = false


func _on_player_controller_staggered_kill() -> void:
	var AmmoAmount = randi_range(30,40)
	var MaxWeaponIndex = WeaponInventory.size() -1
	var NewIndex = randi_range(0,MaxWeaponIndex)
	TotalAmmoTempArray[NewIndex] += AmmoAmount
	print(NewIndex)
	loadAmmo(CurrentWeapon)
	return

func GetNewIndex():
	newlength = WeaponInventory.size() - 1

func GiveWeapon():
	TotalAmmoTempArray[newlength] += 100
	SwitchWeapon(newlength)
	print(WeaponInventory[newlength])

func on_pickup(WeaponName):
	WeaponInventory.append(WeaponName)
	call_deferred("GetNewIndex")
	call_deferred("GiveWeapon")

func _on_pickup_base_node_give_weapon(WeaponName: Variant, StartingTotalAmmoAmount: Variant, StartingClipMoment: Variant) -> void:
	WeaponInventory.append(WeaponName)
	call_deferred("GetNewIndex")
	call_deferred("GiveWeapon")
