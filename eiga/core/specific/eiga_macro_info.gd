extends Resource
class_name  EigaMacroInfo

@export var args: Array
@export var text: String

func _init(args: Array = [], text: String = ""):
	self.args = args
	self.text = text

func build(in_args: Array) -> String:
	if len(in_args) != len(args):
		push_error("Argument count are different!")
		return ""
	var res := text
	for i in range(len(args)):
		var r := RegEx.new()
		r.compile("\\$%s[^,)\\s]*" % args[i])
		if in_args[i] is String:
			res = r.sub(res, "\"%s\"" % in_args[i], true)
		else:
			res = r.sub(res, str(in_args[i]), true)
	return res
