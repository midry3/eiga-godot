extends CodeHighlighter
class_name EigaScriptHighlighter

@export var normal_color := Color.LAVENDER
@export var separate_color := Color.LAVENDER
@export var string_color := Color.DARK_GREEN
@export var num_color := Color.AQUAMARINE
@export var async_call_color := Color.SANDY_BROWN
@export var large_bracket_color := Color.CORNFLOWER_BLUE
@export var call_function_color := Color.LIGHT_BLUE
@export var speaker_color := Color.MEDIUM_PURPLE
@export var trans_color := Color.DARK_CYAN
@export var scene_color := Color.AQUAMARINE
@export var comment_color := Color.DARK_GRAY
@export var keyword_color := Color.CRIMSON

const KEYWORDS := [
	"true",
	"false",
	"null"
]

func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var text := get_text_edit().get_line(line)
	var colors := {}
	var i := 0
	var length := text.length()
	while i < length:
		var c := text[i]
		if c == "[":
			colors[i] = {
				"color": large_bracket_color,
				"length": 1
			}
			var j := i + 1
			while j < length and _is_whitespace(text[j]):
				j += 1
			if text[j] == "&":
				colors[j] = {
					"color": async_call_color,
					"length": 1
				}
				j += 1
			var start := j
			while j < length and text[j] != "(":
				j += 1
			if start < j:
				colors[start] = {
					"color": call_function_color,
					"length": j - start
				}
			i = j
		elif c == "]":
			colors[i] = {
				"color": large_bracket_color,
				"length": 1
			}
			i += 1
		elif c == "\"":
			var j := i + 1
			var start := i
			while j < length and text[j] != "\"":
				j += 1
			if start < j:
				colors[start] = {
					"color": string_color,
					"length": j - start
				}
			i = j + 1
		elif c == "@":
			var j := i + 1
			while j < length and !_is_whitespace(text[j]):
				j += 1
			colors[i] = {
				"color": speaker_color,
				"length": j - i
			}
			i = j
		elif c == "#":
			colors[i] = {
				"color": comment_color,
				"length": length - i
			}
			i = length
			continue
		elif c == "-" and i + 1 < length and text[i + 1] == ">":
			var j := i + 2
			colors[i] = {
				"color": trans_color,
				"length": 2
			}
			while j < length and _is_whitespace(text[j]):
				j += 1
			var start := j
			while j < length and !_is_whitespace(text[j]):
				j += 1
			if start < j:
				colors[start] = {
					"color": scene_color,
					"length": j - start
				}
			i = j
		elif c.is_valid_int():
			if i != 0 and !_is_separete(text[i-1]):
				colors[i] = {
					"color": normal_color,
					"length": 1
				}
				i += 1
				continue
			var start := i
			var j := i + 1
			var n := c
			while j < length and !_is_separete(text[j]):
				n += text[j]
				j += 1
			if n.is_valid_float():
				colors[start] = {
					"color": num_color,
					"length": j - start
				}
			else:
				colors[start] = {
					"color": normal_color,
					"length": j - start
				}
			i = j
		elif _is_separete(c):
			colors[i] = {
				"color": separate_color,
				"length": 1
			}
			i += 1
		else:
			var j := i + 1
			var k := c
			while j < length and !_is_separete(text[j]):
				k += text[j]
				j += 1
			if KEYWORDS.has(k):
				colors[i] = {
					"color": keyword_color,
					"length": len(k)
				}
			else:
				colors[i] = {
					"color": normal_color,
					"length": len(k)
				}
			i = j
	return colors

func _is_whitespace(c: String) -> bool:
	return c == " " or c == "\t"

func _is_separete(c: String) -> bool:
	return _is_whitespace(c) or c == "," or c == "(" or c == ")" or c == "[" or c == "]"
