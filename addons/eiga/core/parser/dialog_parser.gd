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
						args.append(current.strip_edges())
						current = ""
					else:
						current += ch
			if current.strip_edges() != "":
				args.append(current.strip_edges())
			var func_enum := EigaSpecific.Function.SHOW
			match name:
				"show": func_enum = EigaSpecific.Function.SHOW
				"move": func_enum = EigaSpecific.Function.MOVE
				"wait": func_enum = EigaSpecific.Function.WAIT
				"pause": func_enum = EigaSpecific.Function.PAUSE
				"term": func_enum = EigaSpecific.Function.TERM
				"zoom": func_enum = EigaSpecific.Function.ZOOM
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
	return res
