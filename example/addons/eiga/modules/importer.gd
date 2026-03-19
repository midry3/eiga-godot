extends EditorImportPlugin
class_name EigaLangImporter

func _get_importer_name():
	return "eiga"
	
func _get_visible_name():
	return "Eiga Lang"
	
func _get_recognized_extensions():
	return [EigaSpecific.EIGA_SCRIPT_EXT]
	
func _get_save_extension():
	return "tres"
	
func _get_resource_type():
	return "Resource"

func _get_import_options(path, preset_index):
	return []

func _import(source_file, save_path, options, platform_variants, gen_files):
	var res :=  EigaParser.parse(source_file)
	if res.ok:
		return ResourceSaver.save(res, "%s.%s" % [save_path, _get_save_extension()])
	return ERR_BUG
