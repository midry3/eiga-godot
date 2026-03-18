extends Node
class_name EigaSpecific

const EIGA_SCRIPT_EXT := "e"
const EIGA_SCRIPT_RESOURCE := "EigaScript"
const FUNCTIONS := ["show", "wait", "pause", "term", "call"]

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
	TERM
}
