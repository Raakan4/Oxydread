@tool
extends Area2D
@export var Pickup : base_pickup:
	set(value):
		Pickup = value
		if Engine.is_editor_hint():
			LoadPickup()
			
@export var Name : String
@export var Item : String
@export var Sprite : Texture2D
@export var Type : String
@export var Quantity : int
@export var WeaponType : String
@export var StartingAmmoQuantity : int
@export var StartingClipAmmoQuantity : int
var Gun : Node2D

func LoadPickup():
#	Name = Pickup.Name
#	Item = Pickup.Item
	$PickupSprite.texture = Pickup.Sprite
	Type = Pickup.Type
	Quantity = Pickup.Quantity
	WeaponType = Pickup.WeaponType
	StartingAmmoQuantity = Pickup.StartingAmmoQuantity
	StartingClipAmmoQuantity = Pickup.StartingClipAmmoQuantity

signal GiveWeapon(WeaponName,StartingTotalAmmoAmount,StartingClipMoment)
signal GiveAmmo(WeaponType2,AmmoQuantity)
signal GiveHealth(Quantity)
signal demo_pickedup()

func _ready() -> void:
	LoadPickup()
	Gun = get_tree().get_first_node_in_group("Gun")
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Type == "Ammo":
			GiveAmmo.emit(WeaponType,Quantity)
			queue_free()
		if Type == "Weapon":
			#Gun.GiveWeapon.emit(WeaponType,StartingAmmoQuantity,StartingClipAmmoQuantity)
			Gun.on_pickup(WeaponType)
			queue_free()
		if Type == "Health":
			GiveHealth.emit(Quantity)
			queue_free()
		if Type == "Demo":
			demo_pickedup.emit()
			queue_free()
		else:
			pass
