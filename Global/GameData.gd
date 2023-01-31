#GameData.gd as Singleton Autoloaded
extends Node

var score = load_record()

func update_record():
	print("score:" + str(score) + "   " + str(load_record()))
	if score > load_record():
		FileHelper.save("user://record.dat", score)

func load_record():
	return  FileHelper.read("user://record.dat",0)

func reset_score():
	FileHelper.save("user://record.dat", 0)
	score = 0
