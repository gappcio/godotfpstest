extends Node3D
class_name PlayerWeaponPistol

@onready var player = $"../../../..";

@onready var AnimTreeActionPistol = $AnimTreeActionPistol;
@onready var AnimTreeActionArm = $AnimTreeActionArm;
@onready var Anim = $Anim;
@onready var AnimTreeMove = $AnimTreeMove;

enum WEAPON_ANIM_STATE {
	ref,
	idle,
	shoot,
	walk,
	jump,
	fall
}

enum WEAPON_ACTION_STATE {
	ref,
	idle,
	shoot
}

var state: int = WEAPON_ANIM_STATE.idle;
var state_action: int = WEAPON_ACTION_STATE.idle;

func _ready():
	AnimTreeMove.active = true;
	AnimTreeActionArm.active = true;
	AnimTreeActionPistol.active = true;

func _process(delta):
	
	if Input.is_action_just_pressed("mouse_left")\
	&& $ShootingTimer.is_stopped():
		state_action = WEAPON_ACTION_STATE.shoot;
		$ShootingTimer.start();
	
	if state_action == WEAPON_ACTION_STATE.ref\
	|| state_action == WEAPON_ACTION_STATE.idle:
		var threshold = 1;
		
		if player.velocity.y < 0.0:
			state = WEAPON_ANIM_STATE.fall;
		elif player.velocity.y > 0.0:
			state = WEAPON_ANIM_STATE.jump;
		else:
			if int(player.velocity.x) in range(-threshold, threshold) && int(player.velocity.z) in range(-threshold, threshold):
				state = WEAPON_ANIM_STATE.idle;
			else:
				state = WEAPON_ANIM_STATE.walk;
				
	else:
		state = WEAPON_ANIM_STATE.shoot;
		
			
	animate();

func animate():
	
	match(state):
		WEAPON_ANIM_STATE.ref:
			pass
		WEAPON_ANIM_STATE.idle:
			AnimTreeMove["parameters/conditions/idle"] = true;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeActionArm["parameters/conditions/ref"] = true;
			AnimTreeActionPistol["parameters/conditions/ref"] = true;
			
			AnimTreeMove["parameters/idle/TimeScale/scale"] = 0.5;
		WEAPON_ANIM_STATE.walk:
			AnimTreeMove["parameters/conditions/idle"] = false;
			AnimTreeMove["parameters/conditions/walk"] = true;
			
			AnimTreeActionArm["parameters/conditions/ref"] = true;
			AnimTreeActionPistol["parameters/conditions/ref"] = true;
			
			AnimTreeMove["parameters/walk/TimeScale/scale"] = float(Vector2(player.velocity.x, player.velocity.z).length() / player.BASE_SPEED);
		WEAPON_ANIM_STATE.jump:
			AnimTreeMove["parameters/conditions/idle"] = true;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeActionArm["parameters/conditions/ref"] = true;
			AnimTreeActionPistol["parameters/conditions/ref"] = true;
			
			AnimTreeMove["parameters/idle/TimeScale/scale"] = 0.25;
		WEAPON_ANIM_STATE.fall:
			AnimTreeMove["parameters/conditions/idle"] = true;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeActionArm["parameters/conditions/ref"] = true;
			AnimTreeActionPistol["parameters/conditions/ref"] = true;
			
			AnimTreeMove["parameters/idle/TimeScale/scale"] = 0.25;
		WEAPON_ANIM_STATE.shoot:
			AnimTreeMove["parameters/conditions/idle"] = false;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeActionArm["parameters/conditions/ref"] = false;
			AnimTreeActionArm["parameters/conditions/shooting"] = true;
			
			AnimTreeActionPistol["parameters/conditions/ref"] = false;
			AnimTreeActionPistol["parameters/conditions/shooting"] = true;
			


func _on_shooting_timer_timeout():
	$ShootingTimer.wait_time = 0.25;
	state_action = WEAPON_ACTION_STATE.idle;
	AnimTreeActionArm["parameters/conditions/shooting"] = false;
	AnimTreeActionPistol["parameters/conditions/shooting"] = false;
