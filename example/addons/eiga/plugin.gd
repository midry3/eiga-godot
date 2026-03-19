@tool
extends EditorPlugin

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
	return object is EigaLang

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
