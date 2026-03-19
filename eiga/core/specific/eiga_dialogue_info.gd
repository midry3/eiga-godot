extends Resource
class_name EigaDialogueInfo

@export var speaker: String
@export var value: String

func _init(speaker: String = "", value: String = ""):
	self.speaker = speaker
	self.value = value

func execute() -> void:
	pass
