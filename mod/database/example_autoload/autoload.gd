extends StarBotChatSingleton



#当前数据存储的路径
var database_json_path:String=""
#当前持有的数据库缓存
var data_cache:Dictionary={}
func _ready():
	print("hello database!")
	database_json_path=ModLoader.get_mod_path("database")+"/all.db"
	data_cache=get_db()
	pass
	

func get_db()->Dictionary:
	if FileAccess.file_exists(database_json_path):
		var f=FileAccess.open(database_json_path,FileAccess.READ)
		var str:String=f.get_as_text()
		var json=JSON.parse_string(str)
		if json is Dictionary:
			return json
		else:
			return {}
	else:
		return {}


func save_db():
	var f=FileAccess.open(database_json_path,FileAccess.WRITE)
	if f!=null:
		f.store_string(JSON.stringify(data_cache))
		f.close()

func get_data(key:String):
	if !data_cache.has(key):
		return null
	else:
		return data_cache[key]
func write_data(key:String,value):
	data_cache[key]=value
	save_db()

func delete_data(key:String):
	data_cache.erase(key)
	save_db()
	
	
func write_db_num(db_name:String,db_id:String,num:float):
	
	
	
	
	pass
func get_db_num(db_name:String,db_id:String):
	
	
	
	
	
	pass
func get_db_rank(db_name:String):
	
	
	
	
	
	pass
