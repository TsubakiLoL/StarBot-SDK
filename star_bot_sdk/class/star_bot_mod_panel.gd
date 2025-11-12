extends Control
class_name StarBotModPanel

var panel_name:String="未命名"

const GREEN=Color.GREEN
const RED=Color.RED

##使用的环境(外部注入)
var environment:StarBotEnvironment

##单例映射
var GlobalConfig:
	get():
		return environment.get_singletion("GlobalConfig")
var ModLoader:
	get():
		return environment.get_singletion("ModLoader")

var PromptMessageControler:
	get():
		return environment.get_singletion("PromptMessageControler")


##打印调试信息
func l(message:String,color:Color=Color.WHITE):
	print_label_content(panel_name,message,Color.GREEN,color)
##标签打印
func print_label_content(label:String,content:String,label_color:Color=Color.GREEN,content_color:Color=Color.WHITE):
	if OS.get_name()!="Web":
		print_rich("[color=#%s][%s]:[/color][color=#%s]%s[/color]"%[label_color.to_html(false),label,content_color.to_html(false),content])
	else:
		print_rich("[%s]:%s"%[label,content])
##使用表格的方式打印字典数组
func print_table(arr:Array[Dictionary],title:String=""):
	if title!="":
		print(title)
	if arr.is_empty():
		return
	var all_keys_cache:Array
	all_keys_cache=arr[0].keys()
	for i in arr:
		if  i is Dictionary:
			var j:int=0
			while j<all_keys_cache.size():
				if not i.has(all_keys_cache[j]):
					all_keys_cache.pop_at(j)
					j-=1
				j+=1
	var rich_text:String="[table=%d]"%[all_keys_cache.size()]
	for i in all_keys_cache:
		rich_text+="\n[cell border=#fff3 bg=#000]"+i+"[/cell]"
	for i in arr:
		if i is Dictionary:
			for j in all_keys_cache:
				rich_text+=("\n[td]"+str(i[j])+"[/td]")
				rich_text+="\n[cell border=#fff3 bg=#000]"+str(i[j])+"[/cell]"
	rich_text+="\n[/table]"
	print_rich(rich_text)

##重写注入环境
func add_child_injection(node: Node, force_readable_name: bool = false, internal: InternalMode = 0):
	if node is StarBotChatSingleton:
		print("注入：%s"%[node.singleton_name])
		node.environment=self.environment
	super.add_child(node,force_readable_name,internal)
