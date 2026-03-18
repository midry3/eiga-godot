extends Resource
class_name EigaDialogueScriptInfo

@export var function: EigaSpecific.Function
@export var args: Array
@export var wait := true

func _init(function: EigaSpecific.Function=EigaSpecific.Function.SHOW, args: Array=[""], wait: bool = true):
	self.function = function
	self.args = args
	self.wait = wait
