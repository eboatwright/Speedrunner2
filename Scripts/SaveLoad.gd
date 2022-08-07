extends Node2D;

var save_path = "user://save.dat";

func read():
	var file = File.new();
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "nocheating>:(");
		if error == OK:
			var data = file.get_var();
			file.close();
			return data;
	return {};

func write(level, time):
	var data = read();
	if !data.has(level) || data[level] == NAN || time < data[level]:
		data[level] = time;
	
	var file = File.new();
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "nocheating>:(");
	if error == OK:
		file.store_var(data);
		file.close();

func format_time(timer):
	var minutes = str(floor(timer / 60));
	var seconds = "%.2f" % (fmod(timer, 60));
	var time = minutes + ":";
	
	if float(seconds) < 10.0:
		time += "0";
	time += seconds;
	
	return time;
