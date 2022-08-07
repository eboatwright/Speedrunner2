extends Area2D;

export var scene = "res://Scenes/Levels/Hub.tscn";
var open = true;
var player_overlapping = false;

func _physics_process(delta):
	if open:
		get_node("Sprite").animation = "Open";
		if Input.is_action_just_pressed("enter_door") && player_overlapping:
			get_tree().change_scene(scene);
	else:
		get_node("Sprite").animation = "Closed";


func _on_area_entered(area):
	if area.get_parent().name == "Player":
		player_overlapping = true;

func _on_area_exited(area):
	if area.get_parent().name == "Player":
		player_overlapping = false;
