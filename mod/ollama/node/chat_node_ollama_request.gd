extends StarBotChatNode

var API:String=""
var model:String="llama2"
#节点初始化
func _init(root:StarBotChatNodeRoot) -> void:
	#父类初始化
	super._init(root)
	#输入节点类型数组
	input_port_array=["Bool","String"]
	
	input_port_name=["是否操作","输入"]
	#输出节点类型数组
	output_port_array=["Bool","String"]
	
	output_port_name=["操作成功","回复"]
	#需要使用节点UI控制的变量队列
	variable_name_array=["API","model"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_STRING,StarBotChatNode.variable_type.TYPE_STRING]
	variable_name_view=["API地址","使用模型"]


#当全部输入就绪时调用
#处理输入，输入的为状态机的标识ID，大部分情况为用户ID
func process_input(id:String,input_port_data:Array,output_port_data:Array):
	#第0个端口的输入数据，获取方式以此类推
	input_port_data[0]
	if input_port_data[0] is bool and input_port_data[1] is String:
		if input_port_data[0]:
			var http=ModLoader.get_autoload("ollama/ollama").create_request(model,API,input_port_data[1])
			await http.request_complete
			if http.is_success:
				var response=http.response
				output_port_data[0]=true
				output_port_data[1]=response
			else:
				
				output_port_data[0]=false
				output_port_data[1]=""
			http.queue_free()

		else:
			output_port_data[0]=false
			output_port_data[1]=""

		return true
	return false

#从硬盘中加载数据
func load_from_data(data:Dictionary):
	#父类
	super.load_from_data(data)
	#如果字典中存在这个数据，就进行载入
	if data.has("API"):
		var _test_var=data["API"]
		API=_test_var
	if data.has("model"):
		var _var=data["model"]
		model=_var
#将输入保存到硬盘
func export_data(data:Dictionary):
	#父类
	super.export_data(data)
	#保存
	data["API"]=API
	data["model"]=model
	