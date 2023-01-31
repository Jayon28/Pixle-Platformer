#FileHelper.gd
class_name FileHelper

#普通写入
static func save(path,data):
	var file = FileAccess.open(path, FileAccess.WRITE)
	print("data:"+str(data))
	file.store_var(data)
	file = null

#普通读取
static func read(path,default_data):
	var data = default_data
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ_WRITE)
		var content = file.get_var()
		print(content)
		if !content == null:
			data = content
		file = null
		return data
	else:
		FileAccess.open(path, FileAccess.WRITE)
		return 0


#加密写入
static func save_encrypted(path,data,key):
	var file = FileAccess.open_encrypted_with_pass(path,FileAccess.WRITE,key)
	file.store_string(var_to_str(data))
	file = null
	


#加密读取
static func read_encrypted(path,key,default_data):
	var data = default_data
	var file = FileAccess.open_encrypted_with_pass(path,FileAccess.READ_WRITE,key)
	var content :String = file.get_as_text()
	if not content.is_empty():
		data = str_to_var(content)
	file = null
	return data
