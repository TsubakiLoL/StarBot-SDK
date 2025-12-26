#----------------------
#版权所有：
#	李志鹏
#	新疆大学 计算机科学与技术学院 
#	计算机科学与技术 21-3班
#	毕业设计
#	学号：20211401239
#----------------------


extends StarBotChatSingleton

class_name StarBotPromptMessageControler

##发布用户消息（id为用户在全局的唯一表示，triger_type为触发器类型，mes为消息内容）
func prompt(id:String,triger_type:String,mes:Dictionary):
	for  i in triget_array:
		if i!=null:
			i.callv([id,triger_type,mes])
	
	
	pass
##已经链接的函数
var triget_array:Array[Callable]=[]
##链接函数
func link(cal:Callable):
	if cal not in triget_array:
		triget_array.append(cal)
##是否链接到函数
func is_linked(cal:Callable)->bool:
	return cal in triget_array
##取消链接
func dislink(cal:Callable):
	if cal in triget_array:
		triget_array.pop_at(triget_array.find(cal))
