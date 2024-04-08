extends Node3D
class_name PlayerWeaponPistol

@onready var player = $"../../../..";

@onready var AnimMesh = $pistol_viewmodel/AnimationPlayer;
@onready var AnimTree = $AnimationTree;
@onready var Anim = $Anim;

enum WEAPON_STATE {
	ref,
	idle,
	shoot,
	walk,
	jump,
	fall
}

var state: int = WEAPON_STATE.idle;

func _ready():
	pass
	


func _process(delta):
	
	var threshold = 1;
	
	if player.velocity.y < 0.0:
		state = WEAPON_STATE.fall;
	elif player.velocity.y > 0.0:
		state = WEAPON_STATE.jump;
	else:
		if int(player.velocity.x) in range(-threshold, threshold) && int(player.velocity.z) in range(-threshold, threshold):
			state = WEAPON_STATE.idle;
		else:
			state = WEAPON_STATE.walk;
			
	animate();

func animate():
	
	match(state):
		WEAPON_STATE.ref:
			pass
		WEAPON_STATE.idle:
			Anim.play("idle");
			Anim.speed_scale = 0.5;
		WEAPON_STATE.walk:
			Anim.play("walk");
			Anim.speed_scale = float(Vector2(player.velocity.x, player.velocity.z).length() / player.BASE_SPEED);
		WEAPON_STATE.jump:
			Anim.play("idle");
			Anim.speed_scale = 1.5;
		WEAPON_STATE.fall:
			Anim.play("idle");
			Anim.speed_scale = 0.1;
