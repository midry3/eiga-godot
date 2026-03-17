extends Node
class_name EigaParser

const COMMENT := "#"

static func parse(path: String) -> Array[EigaScriptInstruction]:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return []
	var text := f.get_as_text()
	var res: Array[EigaScriptInstruction] = []
	var last_speaker := ""
	var line := 0
	for t in text.split("\n"):
		line += 1
		var script := get_line_script(t).strip_edges()
		if script.is_empty():
			continue
		if script.begins_with("@"):
			# 直前のダイアログを閉じる
			if not res.is_empty():
				var last := res.back() as EigaScriptInstruction
				if last.action == EigaSpecific.Action.START_DIALOG:
					last.info.value = last.info.value.strip_edges(false)
				else:
					push_error("Line %d: Syntax error" % line)
					return []
			var speaker := script.substr(1).strip_edges()
			if speaker == "-":
				speaker = last_speaker
			last_speaker = speaker
			var inst := EigaScriptInstruction.new(
				EigaSpecific.Action.START_DIALOG,
				EigaDialogueInfo.new(speaker, "")
			)
			res.append(inst)
		elif script.begins_with("->"):
			var inst := EigaScriptInstruction.new(
				EigaSpecific.Action.TRANS,
				EigaDialogueInfo.new("", script.substr(2).strip_edges())
			)
			res.append(inst)
		else:
			if res.is_empty():
				push_error("The file `%s` does not start with @, so there is no speaker." % path)
				return []
			var last := res.back() as EigaScriptInstruction
			if last.action != EigaSpecific.Action.START_DIALOG:
				push_error("Line %d: Syntax error" % line)
				return []
			last.info.value += script + "\n"
	return res

static func get_line_script(text: String) -> String:
	var idx := text.find(COMMENT)
	return text if idx == -1 else text.lstrip(" ").substr(0, idx)
