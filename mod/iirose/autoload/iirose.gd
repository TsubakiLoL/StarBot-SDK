#----------------------
#版权所有：
#	李志鹏
#	新疆大学 计算机科学与技术学院 
#	计算机科学与技术 21-3班
#	毕业设计
#	学号：20211401239
#----------------------



extends StarBotChatSingleton






##IIROSE徽标字符串
const IIROSE_TEXT="""
ooooo ooooo ooooooooo.     .oooooo.    .oooooo..o oooooooooooo 
`888' `888' `888   `Y88.  d8P'  `Y8b  d8P'    `Y8 `888'     `8 
 888   888   888   .d88' 888      888 Y88bo.       888         
 888   888   888ooo88P'  888      888  `"Y8888o.   888oooo8    
 888   888   888`88b.    888      888      `"Y88b  888    "    
 888   888   888  `88b.  `88b    d88' oo     .d8P  888       o 
o888o o888o o888o  o888o  `Y8bood8P'  8""88888P'  o888ooooood8 
"""

##蔷薇花园的ws缓冲区大小（设置太小容易爆）
var buffer_size:int:
	get():
		return int(GlobalConfig.get_item_value("iirose","buffer_size"))
var account:String:
	get():
		return str(GlobalConfig.get_item_value("iirose","account"))
var password:String:
	get():
		return str(GlobalConfig.get_item_value("iirose","password"))
var room:String:
	get():
		return str(GlobalConfig.get_item_value("iirose","room"))
var auto_login:bool:
	get():
		return bool(GlobalConfig.get_item_value("iirose","auto_login"))




##蔷薇使用的websocket
var ws =WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED
var stock_message=[0,0,0]  #总股数，总金，单股价格
##房间信息缓存
var room_message_cache:Array=[]
##房间信息缓存大小
var room_message_cache_size:int=30
##添加缓存
func put_room_cache(room_mes_dic:Dictionary):
	room_message_cache.append(room_mes_dic)
	if room_message_cache.size()>room_message_cache_size:
		room_message_cache.pop_front()
		
		


var login_package={
	"r":"66234e757a3ce", #房间标识
	"n":"",				#名字
	"p":"",				#密码
	"cp":"",
	"nt":"",
	"st":"n",
	"mo":"",
	"mb":"1",
	"mu":"01",
	"rp":"",
	"vc":"1092",
	"fp":"@"
}
var next_room:String=""
var is_login:bool=false
var is_in_logging:bool=false
var ping_timer: Timer
signal connected_to_server
signal connection_closed(rea:Array)
signal message_received(pac:PackedByteArray)
signal login_success
signal room_message_received(arr:Array)
signal side_message_received(arr:Array)
signal bullet_message_received(arr:Array)
signal stock_update
#是否需要打印debug信息
var need_debug_message:bool:
	get():
		return GlobalConfig.get_item_value("iirose","print_debug_message")


func _ready() -> void:
	print(IIROSE_TEXT)
	
	#添加蔷薇花园设置条目
	#添加节
	var iirose_section=StarBotConfigSection.new("蔷薇花园","iirose")
	#添加选择条目
	var back_end_select_type=StarBotConfigTypeSelect.new()
	back_end_select_type.add_select("ws://m8.iirose.com:8777","ws://m8.iirose.com:8777")
	back_end_select_type.add_select("ws://m1.iirose.com:8777","ws://m1.iirose.com:8777")
	back_end_select_type.set_default("ws://m8.iirose.com:8777")
	var config_item_1=StarBotConfigItem.new("服务地址","backend",back_end_select_type)
	
	
	var buffer_size_select_type=StarBotConfigTypeNumber.new(1024,1048560*16,1048560*8)
	var config_item_2=StarBotConfigItem.new("缓存大小（Byte）","buffer_size",buffer_size_select_type)
	
	
	var print_debug_message_select_type=StarBotConfigTypeBool.new(true)
	var config_item_3=StarBotConfigItem.new("打印调试信息","print_debug_message",print_debug_message_select_type)
	
	var auto_login_select_type=StarBotConfigTypeBool.new(true)
	var config_item_4=StarBotConfigItem.new("开始运行时自动登录","auto_login",auto_login_select_type)
	
	var account_select_type=StarBotConfigTypeText.new("")
	var config_item_5=StarBotConfigItem.new("蔷薇账户(用户名)","account",account_select_type)
	var password_select_type=StarBotConfigTypeText.new("",true)
	var config_item_6=StarBotConfigItem.new("密码","password",password_select_type)
	var room_select_type=StarBotConfigTypeText.new("")
	var config_item_7=StarBotConfigItem.new("登入房间(房间ID)","room",room_select_type)
	
	
	#将条目添加到节
	iirose_section.add_item(config_item_1)
	iirose_section.add_item(config_item_2)
	iirose_section.add_item(config_item_3)
	iirose_section.add_item(config_item_4)
	iirose_section.add_item(config_item_5)
	iirose_section.add_item(config_item_6)
	iirose_section.add_item(config_item_7)
	#添加一节
	GlobalConfig.add_section(iirose_section)
	
	
	
	set_buffer_size(buffer_size)
	ping_timer=Timer.new()
	add_child(ping_timer)
	ping_timer.one_shot=false
	ping_timer.timeout.connect(ping)
	ping_timer.wait_time=30
	ping_timer.start()
	if auto_login and account!="" and password!="" and room!="":
		set_information(account,password,room)
		start_connect()

##设置信息
func set_information(name_:String,p:String,room:String):
	login_package["r"]=room
	login_package["n"]=name_
	login_package["p"]=p.md5_text()
	login_package["fp"]="@"+str(randf()).md5_text()
func set_buffer_size(innum:int):
	ws.inbound_buffer_size=innum
	ws.outbound_buffer_size=innum
func start_connect():
	var ws_path=GlobalConfig.get_item_value("iirose","backend")
	ws=null
	is_in_logging=true
	ws=WebSocketPeer.new()
	set_buffer_size(buffer_size)
	last_state = WebSocketPeer.STATE_CLOSED
	is_login=false
	ws.connect_to_url(ws_path,TLSOptions.client())
	if need_debug_message:
		l("正在连接ws:%s"%[ws_path])
func send_in_pack():
	if need_debug_message:
		l("发送登陆包")
	if ws.get_ready_state()==WebSocketPeer.STATE_OPEN:
		var str=("*"+JSON.stringify(login_package)).to_utf8_buffer()
		ws.send(str)
		if need_debug_message:
			l("登陆包发送成功")
	else:
		if need_debug_message:
			l("还未与蔷薇建立链接或链接已断开",RED)


func save_account(_name:String,password:String,room:String):
	#var data=[_name,password,room]
	#var f=FileAccess.open(account_file,FileAccess.WRITE)
	#if f!=null:
		#f.store_string(JSON.stringify(data))
	GlobalConfig.set_item_value("iirose","account",_name)
	GlobalConfig.set_item_value("iirose","password",password)
	GlobalConfig.set_item_value("iirose","room",room)
func get_account():
	if account=="" or password=="" or room=="":
		return null
	return [account,password,room]


func _process(delta: float) -> void:
	poll()
func get_gzip(pkg:PackedByteArray):
	var gzip=StreamPeerGZIP.new()
	gzip.clear()
	gzip.start_compression(buffer_size)
	gzip.put_partial_data(pkg)
	var new_pck=PackedByteArray()
	gzip.finish()
	while(gzip.get_available_bytes()>0):
		new_pck.append_array(gzip.get_partial_data(gzip.get_available_bytes())[1])
	gzip.clear()
	return new_pck
func get_string_from_package(pkg:PackedByteArray):
	var text:String
	if pkg[0]==1:
		#text=get_ungzip(pkg).get_string_from_utf8()
		var new_pkg=pkg
		new_pkg.remove_at(0)
		new_pkg=new_pkg.decompress_dynamic(-1,3)
		text=new_pkg.get_string_from_utf8()
		pass
	else:
		text=pkg.get_string_from_utf8()
	exe_message(text)
	pass

func want_stock():
	if need_debug_message:
		l("尝试向蔷薇申请股票信息")
	sent_str(">#")
func _on_ping_timeout() -> void:
	if ws.get_ready_state()==WebSocketPeer.STATE_OPEN:
		ws.send_text("s")
	pass # Replace with function body.


func exe_message(txt:String):
	var dic:Array=[]
	if txt.begins_with('%*"'): 			#"#注释
		match txt[3]:
			"*":
				if not is_login:
					if need_debug_message:
						l("登录成功")
					is_login=true
					login_success.emit()
			"s":
				if not is_login:
					if need_debug_message:
						l("房间错误且当前账户已上线，尝试断开与目前房间重新建立链接",Color.RED)
					var new_room=txt.split(">")[0]
					new_room=new_room.right(new_room.length()-4)
					login_package["r"]=new_room
					ws.close()
		#%*"0	名字被占用
		#%*"1	用户不存在
		#%*"2	密码错误
		#%*"4	今日可尝试登录次数达到上限
		#%*"5	房间密码错误
		#%*"x(到期时间)#(原因)	账户被封禁
		#%*"6	房间不存在
			"0":
				if need_debug_message:
					l("名字被占用，请重新登录",RED)
				is_in_logging=false
				ws.close()
				ws=null
				l("名字被占用")
			"1":
				if need_debug_message:
					l("用户不存在，请重新登录",RED)
				is_in_logging=false
				ws.close()
				l("用户不存在")
				pass
			"2":
				if need_debug_message:
					l("密码错误，请重新登录",RED)
				is_in_logging=false
				ws.close()
				l("密码错误")
				pass
			"3":
				if need_debug_message:
					l("尝试登录次数达到上限",RED)
				is_in_logging=false
				ws.close()
				l("登录上限")
				pass
			"4":
				if need_debug_message:
					l("房间错误，请重新输入房间信息",RED)
				is_in_logging=false
				ws.close()
				l("房间错误")
				pass
			"5":
				if need_debug_message:
					l("房间密码错误",RED)
				is_in_logging=false
				ws.close()
				l("房间密码错误")
				pass
			"6":
				if need_debug_message:
					l("房间错误，请重新输入房间信息",RED)
				is_in_logging=false
				ws.close()
				l("房间错误")
	elif txt.begins_with('"'):
		
		var new_text=txt.right(txt.length()-1)
		if new_text.begins_with('"'):
			new_text=txt.right(txt.length()-1)
			if need_debug_message:
				l("私聊信息："+new_text)
			var txt_arr=new_text.split("<")
			var side_dic_array:Array[Dictionary]=[]
			for i in txt_arr:
				var new_dic={}
				var spl=i.split(">")
				new_dic["name"]=spl[2]
				new_dic["message"]=use_escape(spl[4])
				new_dic["head"]=spl[3]
				new_dic["uid"]=spl[1]
				side_dic_array.append(new_dic)
			if need_debug_message:
				l("私聊信息处理结果："+str(side_dic_array))
			side_message_received.emit(side_dic_array)
			_on_side_message_received(side_dic_array)
		else:
			if need_debug_message:
				l("房间信息："+new_text)
			var txt_arr=new_text.split("<")
			var room_dic_array:Array[Dictionary]=[]
			for i in txt_arr:
				var new_dic={}
				var spl=i.split(">")
				new_dic["name"]=spl[2]
				new_dic["message"]=use_escape(spl[3])
				new_dic["head"]=spl[1]
				new_dic["uid"]=spl[8]
				room_dic_array.append(new_dic)
			if need_debug_message:
				l("房间信息处理结果："+str(room_dic_array))
			room_message_received.emit(room_dic_array)
			_on_room_message_received(room_dic_array)
	elif txt.begins_with("="):
		var new_text=txt.right(txt.length()-1)
		if need_debug_message:
			l("弹幕信息："+new_text)
		var txt_arr=new_text.split("<")
		var bullet_dic_array:Array[Dictionary]=[]
		for i in txt_arr:
			var new_dic={}
			var spl=i.split(">")
			new_dic["name"]=spl[0]
			new_dic["message"]=use_escape(spl[1])
			new_dic["head"]=spl[5]
			new_dic["uid"]=spl[7]
			bullet_dic_array.append(new_dic)
		bullet_message_received.emit(bullet_dic_array)
		_on_bullet_message_received(bullet_dic_array)
		if need_debug_message:
			l("弹幕信息处理结果："+str(bullet_dic_array))
	elif txt.begins_with(">"):
		var new_text=txt.right(txt.length()-1)
		if need_debug_message:
			l("股票消息："+new_text)
		var spl=new_text.split('"') #"#抱歉这里就先用注释顶一下了，高亮文本有错误
		stock_message[0]=int(spl[0])
		stock_message[1]=float(spl[1])
		stock_message[2]=float(spl[2])
		if need_debug_message:
			l("股票消息处理结果："+str(stock_message))
		stock_update.emit()
	elif txt.begins_with("m"):
		if txt.length()==1:
			login_package["r"]=next_room
			ws.close()
			pass
		
		pass
	#被动移动消息（其它客户端进行了移动）
	elif txt.begins_with("-*"):
		var new_room:String=txt.right(txt.length()-2)
		login_package["r"]=new_room
		ws.close()
		pass
	else:
		if txt.length()>=100:
			if not is_login:
				l("登录成功")
				if need_debug_message:
					l("登录成功")
				is_login=true
				login_success.emit()
		else:
			l(txt)
			pass
	pass
func poll() -> void:
	if ws.get_ready_state() != ws.STATE_CLOSED:
		ws.poll()
	var state = ws.get_ready_state()
	if last_state != state:
		last_state = state
		if state == ws.STATE_OPEN:
			connected_to_server.emit()
			connected()
		elif state == ws.STATE_CLOSED:
			var code = ws.get_close_code()
			var reason = ws.get_close_reason()
			var res=[code, reason]

			connection_closed.emit(res)
			ws_closed(res)
	while ws.get_ready_state() == ws.STATE_OPEN and ws.get_available_packet_count():
		var mes_data=get_message()
		message_received.emit(mes_data)
		get_mes(mes_data)
func get_message() -> PackedByteArray:
	if ws.get_available_packet_count() < 1:
		return PackedByteArray()
	var pkt = ws.get_packet()
	return pkt
func connected():
	if need_debug_message:
		l("ws连接成功")
	send_in_pack()
func ws_closed(res:Array):
	if is_in_logging:
		is_login=false
		var ws_path=GlobalConfig.get_item_value("iirose","backend")
		ws.connect_to_url(ws_path,TLSOptions.client())
		if need_debug_message:
			l("ws断开链接，尝试重新连接",RED)
func get_mes(pac:PackedByteArray):
	get_string_from_package(pac)
func sent_popup(mes:String):
	var x:Dictionary={
		"t":"test","c":"040b02","v":0

	}
	x["t"]=mes
	ws.send_text("~"+JSON.stringify(x))
func sent_tu(uid:String,mes:String=""):
	if need_debug_message:
		l("尝试给用户"+uid+"点赞")
	if ws.get_ready_state()==WebSocketPeer.STATE_OPEN:
		sent_str("+*"+uid+""+mes)
func sent_str(txt:String):
	if ws.get_ready_state()==WebSocketPeer.STATE_OPEN:
		var err=ws.send_text(txt)
func sent_room_message(mes:String,color:String="ffffff"):
	if need_debug_message:
		l("尝试向蔷薇发送房间消息："+mes)
	var room_dic={}	 #{"m":"(消息内容)","mc":"(消息颜色)","i":"(随机数)"}	
	room_dic["m"]=mes
	room_dic["mc"]=color
	var z=str(randf())
	z=z.left(14)
	z=z.right(z.length()-2)
	room_dic["i"]=z
	sent_str(JSON.stringify(room_dic))
func sent_bullet_message(mes:String,color:String="ffffff"):
	if need_debug_message:
		l("尝试向蔷薇发送弹幕消息："+mes)
	var bullet_dic={} #~{"t":"(消息内容)","c":"(消息颜色)","v":0}
	bullet_dic["t"]=mes
	bullet_dic["c"]=color
	bullet_dic["v"]=0
	sent_str("~"+JSON.stringify(bullet_dic))
func sent_side_message(uid:String,mes:String,color:String="ffffff"):
	if need_debug_message:
		l("尝试向用户["+uid+"]发送私聊消息："+mes)
	var side_dic={} 
	side_dic["g"]=uid
	side_dic["m"]=mes
	side_dic["mc"]=color
	var z=str(randf())
	z=z.left(14)
	z=z.right(z.length()-2)
	side_dic["i"]=z
	sent_str(JSON.stringify(side_dic))
func ping():
	if ws.get_ready_state()==WebSocketPeer.STATE_OPEN:
		sent_str("s")
		

#发送平台音乐卡片
func sent_music_card_platform(type:String,music_name:String,singer:String,cover:String,color:String,code_rate:String="128"):
	var dic={}
	var m="m__4%s>%s>%s>%s>%s>%s" %[type,music_name,singer,cover,color,code_rate]
	var z=str(randf())
	z=z.left(14)
	z=z.right(z.length()-2)
	dic["m"]=m
	dic["i"]=z
	dic["mc"]=color
	sent_str(JSON.stringify(dic))
#发送自定义卡片
func sent_card_self(type:String,author:String,cover:String,color:String):
	var dic={}
	var m="m__4%s>>%s>%s" %[type,author,cover]
	var z=str(randf())
	z=z.left(14)
	z=z.right(z.length()-2)
	dic["m"]=m
	dic["i"]=z
	dic["mc"]=color
	sent_str(JSON.stringify(dic))
#发送平台视频卡片
func sent_video_card_platform(type:String,title:String,author:String,cover:String,color:String,resolution:String):
	var dic={}
	var m="m__4%s>%s>%s>%s>%s>>%s>>>" %[type,title,author,cover,color,resolution]
	var z=str(randf())
	z=z.left(14)
	z=z.right(z.length()-2)
	dic["m"]=m
	dic["i"]=z
	dic["mc"]=color
	sent_str(JSON.stringify(dic))

#点歌自定义媒体
func sent_media_self(addr:String,long:float,cover:String,media_name:String,author:String,type:String):
	
	sent_str(
		'&1{"s":"%s","d":%f,"c":"%s","n":"%s","r":"%s","b":"%s"}'
		%
		[addr,long,cover,media_name,author,type]
		)
#点歌平台媒体
func sent_media_platform(addr:String,long:float,cover:String,media_name:String,author:String,type:String,turn_to:String,LRC:String):
	sent_str(
		'&1{"s":"%s","d":%f,"c":"%s","n":"%s","r":"%s","b":"%s","o":"%s","l":"%s"}'
		%
		[addr,long,cover,media_name,author,type,turn_to,LRC]
	)


#{"m":"m__4(音频平台媒体卡片类型)>(歌名)>(歌手)>(卡片封面图)>(卡片颜色)>(码率)","mc":"(卡片颜色)","i":"(随机数)"}

func get_self_name()->String:
	return login_package["n"]



func move_to_room(r:String):
	next_room=r
	sent_str("m"+r)


func _on_bullet_message_received(arr: Array) -> void:
	for i in arr:
		var id:String=i["name"]
		if id!=get_self_name():
			PromptMessageControler.prompt(id,"iirose_triger_bullet",i)
			
	pass # Replace with function body.


func _on_room_message_received(arr: Array) -> void:
	for i in arr:
		var id:String=i["name"]
		put_room_cache(i)
		if id!=get_self_name():
			var text:String=i["message"]
			if text=="'3":
				PromptMessageControler.prompt(id,"iirose_triger_room_exit",i)
			elif text=="'1":
				PromptMessageControler.prompt(id,"iirose_triger_room_enter",i)
			else:
				PromptMessageControler.prompt(id,"iirose_triger_room",i)
	pass # Replace with function body.


func _on_side_message_received(arr:Array) -> void:
	for i in arr:
		var id:String=i["name"]
		if id!=get_self_name():
			PromptMessageControler.prompt(id,"iirose_triger_side",i)
			
			

#转义字典
const escape_library:Dictionary={
	"&amp;":"&",
	"&quot;":'"',#"
	"&lt;":"<",
	"&gt;":">",
	"&nbsp;":" ",
	"&iexcl;":"?",
	"&cent;":"￠",
	"&pound;":"￡",
	"&curren;":"¤",
	"&yen;":"￥",
	"&brvbar;":"|",
	"§":"&sect;",
	"&uml;":"¨",
	"&copy;":"©",
	"&ordf;":"a",
	"&laquo;":"?",
	"&not;":"?",
	"&shy;":"/x7f",
	"&reg;":"®",
	"&macr;":"ˉ",
	"&deg;":"°",
	"&plusmn;":"±",
	"&sup2;":"2",
	"&sup3;":"3",
	"&acute;":"′",
	"&micro;":"μ",
	"&para;":"?",
	"&middot;":"·",
	"&cedil;":"?",
	"&sup1;":"1",
	"&ordm;":"o",
	"&raquo;":"?",
	"&frac14;":"?",
	"&frac12;":"?",
	"&frac34;":"?",
	"&iquest;":"?",
	"&Agrave;":"À",
	"&Aacute;":"Á",
	"&circ;":"Â",
	"&Atilde;":"Ã",
	"&Auml":"Ä",
	"&ring;":"Å",
	"&AElig;":"Æ",
	"&Ccedil;":"Ç",
	"&Egrave;":"È",
	"&Eacute;":"É",
	"&Ecirc;":"Ê",
	"&Euml;":"Ë",
	"&Igrave;":"Ì",
	"&Iacute;":"Í",
	"&Icirc;":"Î",
	"&Iuml;":"Ï",
	"&ETH;":"Ð",
	"&Ntilde;":"Ñ",
	"&Ograve;":"Ò",
	"&Oacute;":"Ó",
	"&Ocirc;":"Ô",
	"&Otilde;":"Õ",
	"&Ouml;":"Ö",
	"&times;":"&times;",
	"&Oslash;":"Ø",
	"&Ugrave;":"Ù",
	"&Uacute;":"Ú",
	"&Ucirc;":"Û",
	"&Uuml;":"Ü",
	"&Yacute;":"Ý",
	"&THORN;":"Þ",
	"&szlig;":"ß",
	"&agrave;":"à",
	"&aacute;":"á",
	"&acirc;":"â",
	"&atilde;":"ã",
	"&auml;":"ä",
	"&aring;":"å",
	"&aelig;":"æ",
	"&ccedil;":"ç",
	"&egrave;":"è",
	"&eacute;":"é",
	"&ecirc;":"ê",
	"&euml;":"ë",
	"&igrave;":"ì",
	"&iacute;":"í",
	"&icirc;":"î",
	"&iuml;":"ï",
	"&ieth;":"ð",
	"&ntilde;":"ñ",
	"&ograve;":"ò",
	"&oacute;":"ó",
	"&ocirc;":"ô",
	"&otilde;":"õ",
	"&ouml;":"ö",
	"&divide;":"÷",
	"&oslash;":"ø",
	"&ugrave;":"ù",
	"&uacute;":"ú",
	"&ucirc;":"û",
	"&uuml;":"ü",
	"&yacute;":"ý",
	"&thorn;":"þ",
	"&yuml;":"ÿ",	
}
static var back_escape_library:Dictionary=back_dic(escape_library)
static func back_dic(from:Dictionary):
	var res={}
	for i in from.keys():
		res[from[i]]=i
	return res


var regex:RegEx=RegEx.create_from_string("(?<escape>&[^&^;]+;)")

#获取原始文本
func use_escape(text:String)->String:
	var str=text
	#输入栈
	var input_stack:PackedStringArray=str.split("")
	#输出栈
	var output_stack:PackedStringArray=PackedStringArray([])
	
	#转义计数
	var cacul_num:int=0
	#是否读取头
	var is_in_cacul:bool=false
	var i:int=0
	while i<input_stack.size():
		var input_character:String=input_stack[i]
		#推入栈
		output_stack.append(input_character)
		match input_character:
			"&":
				is_in_cacul=true
				cacul_num=1
				pass
			
			";":
				if is_in_cacul:
					is_in_cacul=false
					cacul_num+=1
					#起始下标
					var start_index=i-cacul_num+1
					#结束下标
					var end_index=i
					#获取得到的匹配字符
					var cacul_character:String=""
					var x:int=start_index
					while x<=end_index:
						cacul_character=cacul_character+input_stack[x]
						x+=1
					#监测库中是否存在此字符
					if escape_library.has(cacul_character):
						
						#如果存在，弹出匹配转义栈
						var y:int=0
						while y<cacul_num:
							output_stack.remove_at(output_stack.size()-1)
							y+=1
						output_stack.append(escape_library[cacul_character])
				else:
					pass
				is_in_cacul=false
				cacul_num=0
			_:
				if is_in_cacul:
					cacul_num+=1
				pass
		i+=1
	var out_str:String=""
	for z in output_stack:
		out_str+=z
	return out_str


#转义字符串
func get_escape(text:String)->String:
	var str=text
	#输入栈
	var input_stack:PackedStringArray=str.split("")
	#输出栈
	var output_stack:PackedStringArray=PackedStringArray([])
	
	var i:int=0
	while i<input_stack.size():
		var input_character:String=input_stack[i]
		#推入栈
		if back_escape_library.has(input_character):
			output_stack.append(back_escape_library[input_character])
		else:
			output_stack.append(input_character)
		i+=1
	var out_str:String=""
	for z in output_stack:
		out_str+=z
	return out_str
