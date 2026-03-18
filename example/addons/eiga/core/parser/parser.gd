extends Node
class_name EigaParser

const COMMENT := "#"

static func parse(path: String) -> EigaScript:
	var none := EigaScript.new()
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return none
	var raw_text := f.get_as_text()
	var scripts: Array[EigaScriptInstruction] = []
	var last_speaker := ""
	var line := 0
	for t in raw_text.split("\n"):
		line += 1
		var script := get_line_script(t).strip_edges()
		if script.is_empty():
			continue
		if script.begins_with("@"):
			if !scripts.is_empty():
				var last := scripts.back() as EigaScriptInstruction
				if last.action == EigaSpecific.Action.START_DIALOG:
					last.info.value = last.info.value.strip_edges(false)
				else:
					push_error("Line %d: Syntax error" % line)
					return none
			var speaker := script.substr(1).strip_edges()
			if speaker == "-":
				speaker = last_speaker
			last_speaker = speaker
			var inst := EigaScriptInstruction.new(
				EigaSpecific.Action.START_DIALOG,
				EigaDialogueInfo.new(speaker, "")
			)
			scripts.append(inst)
		elif script.begins_with("->"):
			var inst := EigaScriptInstruction.new(
				EigaSpecific.Action.TRANS,
				EigaDialogueInfo.new("", script.substr(2).strip_edges())
			)
			scripts.append(inst)
		else:
			if scripts.is_empty():
				push_error("The file `%s` does not start with @, so there is no speaker." % path)
				return none
			var last := scripts.back() as EigaScriptInstruction
			if last.action != EigaSpecific.Action.START_DIALOG:
				push_error("Line %d: Syntax error" % line)
				return none
			last.info.value += script + "\n"
	var eiga := EigaScript.new()
	eiga.scripts = scripts
	eiga.raw_text = raw_text
	return eiga	

static func get_line_script(text: String) -> String:
	var idx := text.find(COMMENT)
	return text if idx == -1 else text.lstrip(" ").substr(0, idx)
