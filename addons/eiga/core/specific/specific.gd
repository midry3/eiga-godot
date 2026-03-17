extends Node
class_name EigaSpecific

const EIGA_SCRIPT_EXT := "e"
const EIGA_SCRIPT_RESOURCE := "EigaScript"
const FUNCTIONS := ["show", "move", "wait", "pause", "term", "zoom"]

enum Action {
	NONE,
	START_DIALOG,
	TRANS
}

enum Function {
	SHOW,
	MOVE,
	WAIT,
	PAUSE,
	TERM,
	ZOOM
}
