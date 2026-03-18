extends Node
class_name EigaDialogParser

static func parse(text: String) -> Array[EigaDialogueScriptInfo]:
	var res: Array[EigaDialogueScriptInfo] = []
	var i := 0
	var buffer := ""
	while i < text.length():
		var c := text[i]
		if c == "[":
			var start := i
			var depth := 1
			i += 1
			while i < text.length() and depth > 0:
				if text[i] == "[":
					depth += 1
				elif text[i] == "]":
					depth -= 1
				i += 1
			if depth != 0:
				buffer += text.substr(start, i - start)
				continue
			var block := text.substr(start, i - start)
			if buffer != "":
				res.append(EigaDialogueScriptInfo.new(
					EigaSpecific.Function.SHOW,
					[buffer],
					true
				))
				buffer = ""
			var inner := block.substr(1, block.length() - 2).strip_edges()
			var wait_flag := true
			if inner.begins_with("&"):
				wait_flag = false
				inner = inner.substr(1)
			var p := inner.find("(")
			var q := inner.rfind(")")
			if p == -1 or q == -1 or q < p:
				res.append(EigaDialogueScriptInfo.new(
					EigaSpecific.Function.SHOW,
					[block],
					true
				))
				continue
			var name := inner.substr(0, p).strip_edges()
			var args_str := inner.substr(p + 1, q - p - 1)
			if not name in EigaSpecific.FUNCTIONS:
				res.append(EigaDialogueScriptInfo.new(
					EigaSpecific.Function.SHOW,
					[block],
					true
				))
				continue
			var args := []
			var current := ""
			var in_string := false
			var quote_char := ""
			var paren_depth := 0
			for ch in args_str:
				if in_string:
					current += ch
					if ch == quote_char:
						in_string = false
				else:
					if ch == "\"" or ch == "'":
						in_string = true
						quote_char = ch
						current += ch
					elif ch == "(":
						paren_depth += 1
						current += ch
					elif ch == ")":
						paren_depth -= 1
						current += ch
					elif ch == "," and paren_depth == 0:
						args.append(_convert(current))
						current = ""
					else:
						current += ch
			if current.strip_edges() != "":
				args.append(_convert(current))
			var func_enum := EigaSpecific.Function.SHOW
			match name:
				"show": func_enum = EigaSpecific.Function.SHOW
				"wait": func_enum = EigaSpecific.Function.WAIT
				"pause": func_enum = EigaSpecific.Function.PAUSE
				"call": func_enum = EigaSpecific.Function.CALL
			res.append(EigaDialogueScriptInfo.new(func_enum, args, wait_flag))
		else:
			buffer += c
			i += 1
	if buffer != "":
		res.append(EigaDialogueScriptInfo.new(
			EigaSpecific.Function.SHOW,
			[buffer],
			true
		))
	for r in res:
		if r.function == EigaSpecific.Function.SHOW:
			r.args[0] = r.args[0].lstrip("\n")
	for idx in range(len(res)-1, 0, -1):
		if res[idx].function == EigaSpecific.Function.SHOW:
			res[idx].args[0] = res[idx].args[0].rstrip("\n")
			break
	return res

static func _convert(text: String) -> Variant:
	var s := text.strip_edges()
	if s.begins_with("\""):
		return (s.lstrip("\"").rstrip("\""))
	else:
		if s.is_valid_int():
			return int(s)
		elif s.is_valid_float():
			return float(s)
		elif s =="true":
			return true
		elif s == "false":
			return false
		elif s == "null":
			return null
		else:
			push_error("Unknown keyword: `%s`" % s)
			return null
