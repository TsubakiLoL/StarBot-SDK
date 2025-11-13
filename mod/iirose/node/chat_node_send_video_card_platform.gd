extends StarBotChatNode

var video_type:String="*0"
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["video_type"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_SELECT]
	variable_type_more=[
		[
			["*0","*1","*2","*3","*4","*5","*6","*7","*8"],
			[
			"爱奇艺",
			"腾讯视频",
			"优酷",
			"哔哩哔哩视频",
			"芒果电视台",
			"抖音",
			"快手",
			"163MV",
			"哔哩哔哩直播"
			]
		]
	]
	video_type="*0"
	input_port_array=["Bool","String","String","String","String"]
	input_port_name=["是否操作","标题","作者","封面","颜色"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[1] is String and input_port_data[2] is String and input_port_data[3] is String and input_port_data[4] is String:
		if input_port_data[0]:
			ModLoader.get_autoload("iirose/iirose").sent_video_card_platform(video_type,input_port_data[1],input_port_data[2],input_port_data[3],input_port_data[4],"3")
		return true
	else:
		return false
		
