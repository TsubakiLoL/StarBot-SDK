#----------------------
#版权所有：
#	李志鹏
#	新疆大学 计算机科学与技术学院 
#	计算机科学与技术 21-3班
#	毕业设计
#	学号：20211401239
#----------------------

extends StarBotModPanel

func _ready() -> void:
	load_account()
	#连接信号
	$MarginContainer/Control/login.pressed.connect(_on_login_request)
	#连接单路的信号
	ModLoader.get_autoload("iirose/iirose").login_success.connect(set_color.bind(Color.GREEN))
	
	get_iirose().need_debug_message=true
	
func load_account():
	#从硬盘加载保存的账户信息
	var res=get_iirose().get_account()
	if res is Array and res.size()==3:
		$MarginContainer/Control/name.text=res[0]
		$MarginContainer/Control/password.text=res[1]
		$MarginContainer/Control/room.text=res[2]

#获取蔷薇加载的单例
func get_iirose():
	return ModLoader.get_autoload("iirose/iirose")


func _on_login_request():
	var _name=$MarginContainer/Control/name.text
	var p=$MarginContainer/Control/password.text
	var r=$MarginContainer/Control/room.text
	get_iirose().set_information(_name,p,r)
	get_iirose().start_connect()
	get_iirose().need_debug_message=true
	if $MarginContainer/Control/shouldsave.button_pressed:
		get_iirose().save_account(_name,p,r)
	
	pass



func set_color(color:Color):
	$MarginContainer/Control/flag.modulate=color

func debug_mes(text:String):
	
	l(text)
	
	pass
