extends Control;

var timer = 2.0;

func _physics_process(delta):
	timer -= delta;
	if timer <= 0.0:
		get_tree().change_scene("res://Scenes/Menu.tscn");
