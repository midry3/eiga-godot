@tool
extends EditorPlugin

var importer: EigaScriptImporter

func _enable_plugin():
	# Add autoloads here.
	pass

func _disable_plugin():
	# Remove autoloads here.
	pass


func _enter_tree():
	importer = EigaScriptImporter.new()
	add_import_plugin(importer)

func _exit_tree():
	remove_import_plugin(importer)
