extends ResourceFormatLoader
class_name  EigaScriptLoader

func _get_recognized_extensions():
	return [EigaSpecific.EIGA_SCRIPT_EXT]

func _handles_type(type):
	return type == EigaSpecific.EIGA_SCRIPT_RESOURCE

func _get_resource_type(path):
	if path.get_extension() == EigaSpecific.EIGA_SCRIPT_EXT:
		return EigaSpecific.EIGA_SCRIPT_RESOURCE
	return ""

func _load(path, original_path, use_sub_threads, cache_mode):
	return EigaParser.parse(path)
