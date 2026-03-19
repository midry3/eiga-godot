extends Node
class_name EigaSpecific

const PLUGIN_NAME := "Eiga"
const EIGA_LANG_EXT := "eiga"
const EIGA_MACRO_EXT := "eigam"
const EIGA_SUPPORTING_EXTS := [EIGA_LANG_EXT, EIGA_MACRO_EXT]
const EIGA_LANG_RESOURCE := "EigaLang"
const EIGA_MACRO_RESOURCE := "EigaMacro"
const FUNCTIONS := ["show", "wait", "pause", "call"]

enum Action {
	NONE,
	START_DIALOG,
	TRANS
}

enum Function {
	SHOW,
	WAIT,
	PAUSE,
	CALL,
	MACRO
}
