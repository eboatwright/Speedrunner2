extends CanvasLayer;

var running = false;
var timer = 0.0;

func _ready():
	get_node("../Player").connect("started_moving", self, "start");
	get_node("../Player").connect("finished", self, "stop");

func _physics_process(delta):
	if running:
		timer += delta;
	
	get_node("TimerAnimator/Text").set_text(SaveLoad.format_time(timer));

func start():
	running = true;

func stop():
	running = false;
	SaveLoad.write(get_tree().get_current_scene().get_name(), timer);
