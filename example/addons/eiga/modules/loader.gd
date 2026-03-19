extends ResourceFormatLoader
class_name  EigaLangLoader

func _get_recognized_extensions():
	return EigaSpecific.EIGA_SUPPORTING_EXTS

func _handles_type(type):
	return type == EigaSpecific.EIGA_LANG_RESOURCE or type == EigaSpecific.EIGA_MACRO_RESOURCE

func _get_resource_type(path):
	match path.get_extension():
		EigaSpecific.EIGA_LANG_EXT:
			return EigaSpecific.EIGA_LANG_RESOURCE
		EigaSpecific.EIGA_MACRO_EXT:
			return EigaSpecific.EIGA_MACRO_RESOURCE
	return ""

func _load(path, original_path, use_sub_threads, cache_mode):
	match path.get_extension():
		EigaSpecific.EIGA_LANG_EXT:
			return EigaParser.parse(path)
		EigaSpecific.EIGA_MACRO_EXT:
			return EigaMacroParser.parse(path)
