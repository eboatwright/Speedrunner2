extends Control;


func _on_play_pressed():
	SoundPlayer.button();
	get_tree().change_scene("res://Scenes/Levels/Hub.tscn");

func _on_quit_pressed():
	get_tree().quit();
