extends Label

var count = 0
var ha_count = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	if !Global.death:
		text = "你好棒棒啊，到现在还没死呢" 
	else:
		while count <= GameData.score / 4:
			ha_count += "哈"
			count += 1
		text = "你个小辣鸡已经死了"+str(GameData.score)+"次"+ ha_count

func update_text():
	Global.death = true
	print("update called")
	while count <= GameData.score / 4:
		ha_count += "哈"
		count += 1
	text = "你个小辣鸡已经死了"+str(GameData.score)+"次"+ ha_count


