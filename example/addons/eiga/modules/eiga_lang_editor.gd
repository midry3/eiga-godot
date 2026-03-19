extends Control
class_name EigaLangEditor

var tabs: TabContainer
var opening: Dictionary[EigaLang, CodeEdit]
var current_font_size: int

func _init(default_font_size: int):
	current_font_size = default_font_size

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
					save(k)
					opening.erase(k)
					break
			tabs.remove_child(c)
			c.queue_free()
	)
	add_child(tabs)

func open(res: EigaLang) -> void:
	if opening.has(res):
		tabs.current_tab = opening[res].get_index()
	else:
		var code_edit := CodeEdit.new()
		tabs.add_child(code_edit)
		code_edit.syntax_highlighter = EigaLangHighlighter.new()
		code_edit.text = res.raw_text
		code_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
		code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		code_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
		apply_font_size(code_edit)
		tabs.set_tab_title(code_edit.get_index(), res.resource_path.get_file())
		tabs.current_tab = code_edit.get_index()
		opening[res] = code_edit

func save_all() -> void:
	for k in opening.keys():
		save(k)

func save(res: EigaLang) -> void:
	var f := FileAccess.open(res.resource_path, FileAccess.WRITE)
	f.store_string(opening[res].text)
	EditorInterface.get_resource_filesystem().reimport_files([res.resource_path])

func add_font_size(delta: int) -> void:
	current_font_size += delta
	for k in opening:
		apply_font_size(opening[k])

func apply_font_size(editor: CodeEdit) -> void:
	editor.add_theme_font_size_override("font_size", current_font_size)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.ctrl_pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				add_font_size(1)
				accept_event()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				add_font_size(-1)
				accept_event()
