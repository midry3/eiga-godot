extends Resource
class_name EigaScriptInstruction

@export var action: EigaSpecific.Action
@export var info: EigaDialogueInfo
	
func _init(action: EigaSpecific.Action=EigaSpecific.Action.NONE, info: EigaDialogueInfo = EigaDialogueInfo.new("", "")):
	self.action = action
	self.info = info
