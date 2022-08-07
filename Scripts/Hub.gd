extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene("res://Scenes/Menu.tscn");
