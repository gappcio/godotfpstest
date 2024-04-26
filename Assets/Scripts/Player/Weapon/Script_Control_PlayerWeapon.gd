extends Node
class_name PlayerWeaponControl

enum WEAPON {
	none,
	pistol,
	shotgun
}

var weapon_stack: Array = [WEAPON.none, WEAPON.pistol, WEAPON.shotgun];
var weapon_variation: int = 0;

var current_weapon: int = WEAPON.none;

var assets = [
	preload("res://Assets/Objects/Player/Viewmodels/SC_Viewmodel_None.tscn"),
	preload("res://Assets/Objects/Player/Viewmodels/SC_Viewmodel_Pistol.tscn"),
	preload("res://Assets/Objects/Player/Viewmodels/SC_Viewmodel_SShotgun.tscn")
];

func _ready():
	pass
	
func _process(delta):
	
	# Weapon Changing
	
	# Next weapon
	if Input.is_action_just_pressed("scroll_down"):
		if current_weapon < weapon_stack.size() - 1:
			change_weapon(current_weapon + 1);
			
	# Previous weapon
	if Input.is_action_just_pressed("scroll_up"):
		if current_weapon > WEAPON.none:
			change_weapon(current_weapon - 1);
			
func change_weapon(new_weapon):

	var node_name = [
		"VIEWMODEL_None",
		"VIEWMODEL_Pistol",
		"VIEWMODEL_SShotgun"
	];

	$"../Weapon".get_node(node_name[current_weapon]).queue_free();
	
	var viewmodel_scene = assets[new_weapon];
	var viewmodel = viewmodel_scene.instantiate();
	$"../Weapon".call_deferred("add_child", viewmodel);
	
	current_weapon = new_weapon;

func get_weapon():
	return current_weapon;
