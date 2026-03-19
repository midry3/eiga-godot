extends Node
class_name Executor
signal func_called(func_name: String, wait: bool, args: Array)
signal add_text(serif: String)
signal added_text
signal init_text
signal speaker_changed(speaker: String)
signal scene_trans(scene: StringName)
signal next
signal wait(time: float)
signal waited
signal wait_all_call
signal call_finished
signal dialogue_finished

var eiga_lang: EigaLang
var macros: Dictionary[String, EigaMacroInfo]
var current_pos := 0
var can_next := true

func _init(eiga_lang: EigaLang, eiga_macros: Array[EigaMacro]):
	self.eiga_lang = eiga_lang
	macros = {}
	for m in eiga_macros:
		macros.assign(m.macros)

func execute() -> void:
	if eiga_lang == null:
		push_error("no EigaLang file specified!")
		return
	current_pos = 0
	while current_pos < len(eiga_lang.scripts):
		var inst := eiga_lang.scripts[current_pos]
		match inst.action:
			EigaSpecific.Action.START_DIALOG:
				init_text.emit()
				speaker_changed.emit(inst.info.speaker)
				for s in EigaDialogueParser.parse(inst.info.value, macros):
					match s.function:
						EigaSpecific.Function.SHOW:
							add_text.emit(s.args[0])
							await added_text
						EigaSpecific.Function.WAIT:
							wait.emit(s.args[0])
							await waited
						EigaSpecific.Function.PAUSE:
							await next
						EigaSpecific.Function.CALL:
							func_called.emit(s.args[0], s.wait, s.args.slice(1, s.args.size()))
							await call_finished
			EigaSpecific.Action.TRANS:
				dialogue_finished.emit()
				scene_trans.emit(inst.info.value)
		wait_all_call.emit()
		current_pos += 1
		await next
	dialogue_finished.emit()
