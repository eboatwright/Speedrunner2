extends Node2D;

onready var buttonPlayer = get_node("Button");
onready var checkpointPlayer = get_node("Checkpoint");
onready var flagPlayer = get_node("Flag");
onready var footstepPlayer = get_node("Footstep");
onready var jumpPlayer = get_node("Jump");
onready var losePlayer = get_node("Lose");

func button():
	buttonPlayer.play();

func checkpoint():
	checkpointPlayer.play();

func flag():
	flagPlayer.play();

func footstep():
	footstepPlayer.play();

func jump():
	jumpPlayer.play();

func lose():
	losePlayer.play();
