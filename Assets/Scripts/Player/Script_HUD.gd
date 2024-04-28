extends CanvasLayer;
class_name HUD;

@onready var label = $Label;
@onready var player = $"../Player";
@onready var viewmodel = $"Player/Head/Camera/WeaponAttach/ViewmodelControl/Weapon/VIEWMODEL_Pistol";

func _ready():
	pass

func _process(delta):
	
	
	viewmodel = player.get_node("Head/Camera/WeaponAttach/ViewmodelControl/Weapon/VIEWMODEL_Pistol");

	if is_instance_valid(player):
		if is_instance_valid(viewmodel):
			label.text = \
				#"velocity.x: " + str("%.2f" % float(player.velocity.x))\
				#+ "\n" + \
				#"velocity.y: " + str("%.2f" % float(player.velocity.y))\
				#+ "\n" + \
				#"velocity.z: " + str("%.2f" % float(player.velocity.z))\
				#+ "\n" + \
				"stateanim: " + str(viewmodel.timer_shoot_state_change)\
				+ "\n" + \
				"stateaction: " + str(viewmodel.state_action)\
				+ "\n" + \
				"canshoot: " + str(viewmodel.can_shoot)\
				+ "\n";
				#"speed: " + str("%.2f" % float(Vector2(player.velocity.x, player.velocity.z).length()))\
				#+ "\n";
