extends Node2D;

onready var jumpPlayer = get_node("Jump");

func jump():
	jumpPlayer.play();
