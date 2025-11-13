extends StarBotChatSingleton

#当前数据存储的路径
var database_json_path:String=""
#当前持有的数据库缓存
var data_cache:Dictionary={}

var now_contain_dialog

var timer:Timer
func _ready():
	timer=Timer.new()
	timer.one_shot=false
	timer.wait_time=3
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	database_json_path=ModLoader.get_mod_path("dialogue")+"/all.db"
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

func start(dialogue_name:String):
	if now_contain_dialog!=null:
		return false
	if not data_cache.has(dialogue_name):
		return false
	now_contain_dialog=DialogResource.new(data_cache[dialogue_name]["raw"])
	send_now_str()
	timer.start()
	return true

func stop():
	if now_contain_dialog!=null:
		now_contain_dialog=null
		return true
		timer.stop()
	return false
	
	pass
func select(ind:int):
	if now_contain_dialog==null:
		return false
	var res= now_contain_dialog.select(ind)
	send_now_str()
	return res
func add_dialogue(user:String,dialogue_name:String,raw:String):
	if data_cache.has(dialogue_name):
		return false
	data_cache[dialogue_name]={
		"user":user,
		"raw":raw,
	}
	save_db()
	return true

func delete_dialogue(user:String,dialogue_name:String):
	if not data_cache.has(dialogue_name):
		return false
	var self_user=data_cache[dialogue_name]["user"]
	if user!=self_user:
		return false
	data_cache.erase(dialogue_name)
	return true





class DialogResource:
	var _data:Dictionary={}
	var now_scene:String="main"
	var now_index:int=0
	func _init(raw:String) -> void:
		_data=parse_data(raw)
		print(_data)
	func reset():
		now_scene="main"
		now_index=0
	func parse_data(raw:String):
		var str_arr:PackedStringArray=raw.split("\n",false)
		var data:Dictionary={}
		var now_scene:String="main"
		data[now_scene]=[]
		for i in str_arr:
			if i=="":
				continue
			elif i.ends_with(":") and i.length()>1:
				var scene_name=i.left(i.length()-1)
				now_scene=scene_name
				data[now_scene]=[]
			else:
				data[now_scene].append(i)
		return data

	
	func get_select()->Array:
		var res=[]
		var now_scene_arr:Array=_data[now_scene]
		var ind:int=now_index
		while ind<now_scene_arr.size() and get_select_data(now_scene_arr[ind])!=null:
			res.append(get_select_data(now_scene_arr[ind]))
			ind+=1
		return res
	func is_in_select():
		if is_finish():
			return false
		return get_select_data(_data[now_scene][now_index])!=null

	func get_select_data(str:String):
		var spl=str.split("->",false)
		if spl.size()!=2:
			return null
		return [spl[0],spl[1]]
	
	func is_finish():
		if not _data.has(now_scene):
			return true
		else:
			var arr=_data[now_scene]
			if not arr is Array:
				return true
			elif now_index>=arr.size():
				return true
			else:
				return false
	func get_now_str():
		if is_finish():
			return ""
		if is_in_select():
			var data=get_select()
			var str:String="选项：\n"
			for i in data.size():
				str+="\t"+str(i+1)+". "+data[i][0]+"\n"
			str+="发送select （选项数字）进行选择"
			return str
		else:
			return _data[now_scene][now_index]
		
	func go_next():
		now_index+=1
	func select(ind:int):
		if not is_in_select():
			return false
		if is_finish():
			return false
		var select =get_select()
		if ind<=0  || ind>get_select().size():
			return false
		else:
			var ind_data=get_select()[ind]
			var select_name=ind_data[0]
			var scene_name=ind_data[1]
			now_scene=scene_name
			now_index=0
			
			return true
func send_data(str:String):
	var iirose_autoload=ModLoader.get_autoload("iirose/iirose")
	if iirose_autoload!=null:
		iirose_autoload.sent_room_message(str)
	
	pass


func _on_timer_timeout() -> void:
	if now_contain_dialog==null:
		return
	var res:DialogResource=now_contain_dialog
	if res.is_in_select():
		return
	if res.is_finish():
		now_contain_dialog=null
		timer.stop()
		send_data("剧本结束")
		return
	res.go_next()
	send_now_str()
		
	pass # Replace with function body.
func send_now_str():
	if now_contain_dialog==null || now_contain_dialog.is_finish():
		return
	var res:DialogResource=now_contain_dialog
	send_data(res.get_now_str())
	
	pass
