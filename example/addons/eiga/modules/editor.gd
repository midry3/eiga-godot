extends Control
class_name EigaScriptEditor

var tabs: TabContainer
var opening

func _ready():
	opening = {}
	tabs = TabContainer.new()
	tabs.set_anchors_preset(Control.PRESET_FULL_RECT)
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var bar := tabs.get_tab_bar()
	bar.tab_close_display_policy = TabBar.CLOSE_BUTTON_SHOW_ALWAYS
	bar.tab_close_pressed.connect(
		func(idx):
			var c := tabs.get_child(idx)
			for k in opening:
				if opening[k] == c:
					opening.erase(k)
					save(k)
					break
			tabs.remove_child(c)
			c.queue_free()
	)
	add_child(tabs)

func open(res) -> void:
	if opening.has(res):
		tabs.current_tab = opening[res].get_index()
	else:
		var code_edit := CodeEdit.new()
		tabs.add_child(code_edit)
		code_edit.syntax_highlighter = EigaScriptHighlighter.new()
		code_edit.text = res.raw_text
		code_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
		code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		code_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tabs.set_tab_title(code_edit.get_index(), res.resource_path.get_file())
		tabs.current_tab = code_edit.get_index()
		opening[res] = code_edit

func save_all() -> void:
	for k in opening.keys():
		save(k)

func save(res) -> void:
	var f := FileAccess.open(res.resource_path, FileAccess.WRITE)
	f.store_string(opening[res].text)
