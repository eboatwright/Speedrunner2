extends Area2D;

var open = true;
var player_overlapping = false;

func _ready():
	var index = self.name.trim_prefix("Door");
	get_node("LevelName").set_text("LEVEL " + index);
	
	var best = NAN;
	var data = SaveLoad.read();
	var level_name = str("Level", index);
	if data.has(level_name):
		best = SaveLoad.format_time(data[level_name]);
		
	get_node("Record").set_text("BEST: " + str(best));

func _physics_process(delta):
	if open:
		get_node("Sprite").animation = "Open";
		if Input.is_action_just_pressed("enter_door") && player_overlapping:
			SoundPlayer.button();
			get_tree().change_scene("res://Scenes/Levels/Level" + self.name.trim_prefix("Door") + ".tscn");
	else:
		get_node("Sprite").animation = "Closed";


func _on_area_entered(area):
	if area.get_parent().name == "Player":
		player_overlapping = true;

func _on_area_exited(area):
	if area.get_parent().name == "Player":
		player_overlapping = false;
