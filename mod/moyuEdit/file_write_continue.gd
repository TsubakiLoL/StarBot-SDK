extends StarBotChatNode

#写入的路径
var write_path:String=""
#写入的类型：继续写入/覆盖写入
var write_type:String=""
func _init(root:StarBotChatNodeRoot):
	super._init(root)
	input_port_array=["Bool","String"]
	input_port_name=["是否写入","写入字符串"]
	variable_name_array=["write_path","write_type"]
	variable_type_more=[
		#第一个是字符串输入，所以为空
		[],
		[
			[
				"continue",
				"rewrite"
			],
			[
				"继续写入",
				"覆盖写入",
			]
		]
	]
	write_type="continue"
	variable_type_array=[StarBotChatNode.variable_type.TYPE_STRING,StarBotChatNode.variable_type.TYPE_SELECT]
	variable_name_view=["请输入存储文件的路径"]
	pass
	
	
	
func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[1] is String:
		#如果是否写入为真
		if input_port_data[0] and write_path!="" and FileAccess.file_exists(write_path):
			match write_type:
				"continue":
					var f=FileAccess.open(write_path,FileAccess.READ_WRITE)
					if f==null:
						return false
					#将文件光标移到末尾
					f.seek_end()
					f.store_string(input_port_data[1])
					f.close()
					pass
				"rewrite":
					var f=FileAccess.open(write_path,FileAccess.WRITE)
					if f==null:
						return false
					f.store_string(input_port_data[1])
					f.close()
					pass

			
			
			pass
		
		return true
	return false
	
#从硬盘中加载数据
func load_from_data(data:Dictionary):
	#父类
	super.load_from_data(data)
	#如果字典中存在这个数据，就进行载入
	if data.has("write_path"):
		write_path=data["write_path"]
	if data.has("write_type"):
		write_type=data["write_type"]
#将输入保存到硬盘
func export_data(data:Dictionary):
	#父类
	super.export_data(data)
	#保存
	data["write_path"]=write_path
	data["write_type"]=write_type
	