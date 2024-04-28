extends Node3D
class_name PlayerViewmodelControl

# Animation for arm imported actions
# AnimArm

# Animation for weapon imported actions
# AnimWeapon

# Animation for idle, moving etc.
# AnimMove

# Animation Tree for idle, moving etc.
# AnimTreeMove

# Animation Tree for arm imported actions
# AnimTreeActionArm

# Animation Tree for weapon imported actions
# AnimTreeActionWeapon

@onready var player: CharacterBody3D = null;

@onready var AnimWeapon: AnimationPlayer = null;
@onready var AnimArm: AnimationPlayer = null;

@onready var AnimMove: AnimationPlayer = null;
@onready var AnimTreeMove: AnimationTree = null;

@onready var AnimTreeActionWeapon: AnimationTree = null;
@onready var AnimTreeActionArm: AnimationTree = null;

@onready var MuzzleFX: Node3D = null;

var timer_shoot_logic_end: float = 0;
var timer_shoot_logic_period: float = 0.0;

var timer_shoot_anim_end: float = 0.0;
var timer_shoot_anim_period: float = 0.0;

var timer_shoot_state_change: float = 0.0;

var current_weapon: int = 0;
@onready var weapon_node = null;

var can_shoot = true;

enum WEAPON_ANIM_STATE {
	ref,
	idle,
	shoot,
	walk,
	jump,
	fall,
	reload,
	draw
}

enum WEAPON_ACTION_STATE {
	ref,
	idle,
	shoot
}

var state_anim: int = WEAPON_ANIM_STATE.idle;
var state_action: int = WEAPON_ACTION_STATE.idle;

func _ready():
	pass

func _process(delta):
	if player == null:
		return
	
	if has_node("../../WeaponControl"):
		current_weapon = weapon_node.get_weapon();
	
	if timer_shoot_state_change > 0:
		timer_shoot_state_change -= delta;
		
	if timer_shoot_state_change <= 0\
	&& !can_shoot:
		state_action = WEAPON_ACTION_STATE.shoot;
		AnimTreeActionArm["parameters/playback"].travel("ref");
		AnimTreeActionWeapon["parameters/playback"].travel("ref");
		timer_shoot_state_change = 0.0;

	if Input.is_action_pressed("mouse_left")\
	&& can_shoot:
		if state_action != WEAPON_ACTION_STATE.shoot:
			state_action = WEAPON_ACTION_STATE.shoot;
			AnimTreeActionArm["parameters/playback"].travel("ref");
			AnimTreeActionWeapon["parameters/playback"].travel("ref");
		else:
			state_action = WEAPON_ACTION_STATE.idle;
			AnimTreeActionArm["parameters/playback"].travel("ref");
			AnimTreeActionWeapon["parameters/playback"].travel("ref");
			timer_shoot_state_change = 0.1;
		#timer_shoot_logic_end = timer_shoot_logic_period;
		#timer_shoot_anim_end = timer_shoot_anim_period;
		#timer_shoot_state_change = 0.05;
		can_shoot = false;

	var threshold = 1;
	
	if player.velocity.y < 0.0:
		state_anim = WEAPON_ANIM_STATE.fall;
	elif player.velocity.y > 0.0:
		state_anim = WEAPON_ANIM_STATE.jump;
	else:
		if int(player.velocity.x) in range(-threshold, threshold) && int(player.velocity.z) in range(-threshold, threshold):
			state_anim = WEAPON_ANIM_STATE.idle;
		else:
			state_anim = WEAPON_ANIM_STATE.walk;

		
			
	animate();

func animate():
	
	match(state_action):
		WEAPON_ACTION_STATE.ref:
			
			AnimTreeActionArm["parameters/conditions/ref"] = true;
			AnimTreeActionArm["parameters/conditions/shooting"] = false;
			
			AnimTreeActionWeapon["parameters/conditions/ref"] = true;
			AnimTreeActionWeapon["parameters/conditions/shooting"] = false;
		WEAPON_ACTION_STATE.idle:
			
			AnimTreeActionArm["parameters/playback"].travel("ref");
			AnimTreeActionWeapon["parameters/playback"].travel("ref");
			
		WEAPON_ACTION_STATE.shoot:
			
			AnimTreeActionArm["parameters/playback"].travel("shooting");
			AnimTreeActionWeapon["parameters/playback"].travel("shooting");

	match(state_anim):
		WEAPON_ANIM_STATE.ref:
			pass
		WEAPON_ANIM_STATE.idle:
			AnimTreeMove["parameters/conditions/idle"] = true;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeMove["parameters/idle/TimeScale/scale"] = 0.5;
		WEAPON_ANIM_STATE.walk:
			AnimTreeMove["parameters/conditions/idle"] = false;
			AnimTreeMove["parameters/conditions/walk"] = true;
			
			AnimTreeMove["parameters/walk/TimeScale/scale"] = float(Vector2(player.velocity.x, player.velocity.z).length() / player.BASE_SPEED);
		WEAPON_ANIM_STATE.jump:
			AnimTreeMove["parameters/conditions/idle"] = true;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeMove["parameters/idle/TimeScale/scale"] = 0.25;
		WEAPON_ANIM_STATE.fall:
			AnimTreeMove["parameters/conditions/idle"] = true;
			AnimTreeMove["parameters/conditions/walk"] = false;
			
			AnimTreeMove["parameters/idle/TimeScale/scale"] = 0.25;
			

func shoot_timeout():
	can_shoot = true;

func shoot_anim_timeout():
	state_action = WEAPON_ACTION_STATE.idle;
