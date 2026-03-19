extends Node
class_name EigaMacroParser

static func parse(path: String) -> EigaMacro:
	var none := EigaMacro.new()
	none.ok = false
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return none
	var raw_text := f.get_as_text()
	f.close()
	var line := 1
	var macros: Dictionary[String, EigaMacroInfo] = {}
	var in_block := false
	var in_args := false
	var macro_key := ""
	var macro_arg_name := ""
	var macro_args: Array[String] = []
	var buf := ""
	var i := 0
	for t in raw_text:
		if in_block:
			if t == "}":
				if in_args:
					push_error("Line: %d, Wrong Syntax!")
					return none
				macros[macro_key.strip_edges()] = EigaMacroInfo.new(macro_args.duplicate(), buf.strip_edges())
				in_block = false
				macro_key = ""
				macro_arg_name = ""
				macro_args.clear()
				buf = ""
			else:
				buf += t
		elif in_args:
			if t == ",":
				macro_args.append(macro_arg_name.strip_edges())
				macro_arg_name = ""
			elif t == ")":
				macro_args.append(macro_arg_name.strip_edges())
				macro_arg_name = ""
				in_args = false
			else:
				macro_arg_name += t
		else:
			match t:
				"\n":
					line += 1
				"(":
					in_args = true
				"{":
					in_block = true
				_:
					macro_key += t
	var res := EigaMacro.new()
	res.macros = macros
	res.raw_text = raw_text
	res.ok = true
	return res
