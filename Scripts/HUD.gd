extends CanvasLayer;

var running = false;
var timer = 0.0;

func _ready():
	get_node("../Player").connect("started_moving", self, "start");
	get_node("../Player").connect("finished", self, "stop");

func _physics_process(delta):
	if running:
		timer += delta;
	
	var minutes = str(floor(timer / 60));
	var seconds = "%.2f" % (fmod(timer, 60));
	var time = minutes + ":";
	
	if float(seconds) < 10.0:
		time += "0";
	time += seconds;
	
	get_node("TimerAnimator/Text").set_text(time);

func start():
	running = true;

func stop():
	running = false;
