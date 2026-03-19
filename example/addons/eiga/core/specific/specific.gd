extends Node
class_name EigaSpecific

const PLUGIN_NAME := "Eiga"
const EIGA_SCRIPT_EXT := "e"
const EIGA_SCRIPT_RESOURCE := "EigaLang"
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
	CALL
}
