extends PlayerViewmodelControl
class_name PlayerWeaponSShotgun


func _ready():
	player = $"../../../../../../";
	
	AnimWeapon = $"shotgun/AnimWeapon";
	AnimArm = $"arm/AnimArm";
	
	AnimMove = $"AnimMove";
	AnimTreeMove = $"AnimTreeMove";
	
	AnimTreeActionWeapon = $"AnimTreeActionWeapon";
	AnimTreeActionArm = $"AnimTreeActionArm";
	
	weapon_node = $"../../WeaponControl";
	
	AnimWeapon.active = true;
	AnimArm.active = true;
	AnimMove.active = true;
	AnimTreeMove.active = true;
	AnimTreeActionArm.active = true;
	AnimTreeActionWeapon.active = true;
	
	timer_shoot_logic_end = 0;
	timer_shoot_logic_period = 0.3;

	timer_shoot_anim_end = 0;
	timer_shoot_anim_period = 0.4;

func _process(delta):
	super(delta);

func shoot_timeout():
	super();
