extends CanvasLayer;
class_name HUD;

@onready var label = $Label;
@onready var player = $"../Player";
@onready var viewmodel = $"../Player/Head/Camera/WeaponAttach/SC_VIEWMODEL_Pistol";

func _ready():
	pass

func _process(delta):
	if is_instance_valid(player):
		label.text = \
			"velocity.x: " + str("%.2f" % float(player.velocity.x))\
			+ "\n" + \
			"velocity.y: " + str("%.2f" % float(player.velocity.y))\
			+ "\n" + \
			"velocity.z: " + str("%.2f" % float(player.velocity.z))\
			+ "\n" + \
			"state: " + str(viewmodel.state)\
			+ "\n" + \
			"speed: " + str("%.2f" % float(Vector2(player.velocity.x, player.velocity.z).length()))\
			+ "\n";
