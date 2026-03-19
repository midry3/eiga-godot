@tool
extends EditorPlugin

const NEW_EIGA_LANG_MENU := "New EigaLang File"
const NEW_EIGA_MACRO_MENU := "New EigaMacro File"

var importer: EigaLangImporter
var loader: EigaLangLoader
var editor: EigaLangEditor

func _enable_plugin():
	# Add autoloads here.
	pass

func _disable_plugin():
	# Remove autoloads here.
	pass
	
func _handles(object):
	return object is EigaLang or object is EigaMacro

func _edit(object):
	_make_visible(true)
	editor.open(object)

func _save_external_data():
	editor.save_all()

func _enter_tree():
	importer = EigaLangImporter.new()
	add_import_plugin(importer)
	loader = EigaLangLoader.new()
	ResourceLoader.add_resource_format_loader(loader)
	var default_font_size := get_editor_interface().get_editor_settings().get_setting("interface/editor/code_font_size")
	if default_font_size == null:
		default_font_size = 32
	editor = EigaLangEditor.new(default_font_size)
	get_editor_interface().get_editor_main_screen().add_child(editor)
	editor.set_anchors_preset(Control.PRESET_FULL_RECT)
	editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	editor.hide()
	add_tool_menu_item(NEW_EIGA_LANG_MENU, _create_eiga_lang_file)
	add_tool_menu_item(NEW_EIGA_MACRO_MENU, _create_eiga_macro_file)

func _create_eiga_lang_file() -> void:
	_open_dialog(["*.eiga ; EigaLang File"])

func _create_eiga_macro_file() -> void:
	_open_dialog(["*.eigam ; EigaMacro File"])

func _open_dialog(filters: PackedStringArray) -> void:
	var dialog := FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	dialog.access = FileDialog.ACCESS_RESOURCES
	dialog.filters = filters
	dialog.file_selected.connect(
		func(path):
			var f := FileAccess.open(path, FileAccess.WRITE)
			if f:
				f.store_string("")
				f.close()
				var fs := get_editor_interface().get_resource_filesystem()
				await get_tree().process_frame
				fs.scan()
				while fs.is_scanning():
					await get_tree().create_timer(0.5).timeout
				var res := load(path)
				editor.open(res)
				get_editor_interface().set_main_screen_editor(_get_plugin_name())
	)
	get_editor_interface().get_base_control().add_child(dialog)
	dialog.popup_file_dialog()

func _has_main_screen():
	return true

func _get_plugin_name():
	return EigaSpecific.PLUGIN_NAME

func _make_visible(visible):
	if editor:
		editor.visible = visible

func _exit_tree():
	remove_import_plugin(importer)
	ResourceLoader.remove_resource_format_loader(loader)
	editor.queue_free()
	remove_tool_menu_item(NEW_EIGA_LANG_MENU)
	remove_tool_menu_item(NEW_EIGA_MACRO_MENU)
