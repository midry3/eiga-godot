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

var eiga_script: EigaLang
var current_pos := 0
var can_next := true

func _init(eiga_script: EigaLang):
	self.eiga_script = eiga_script

func execute() -> void:
	current_pos = 0
	while current_pos < len(eiga_script.scripts):
		var inst := eiga_script.scripts[current_pos]
		match inst.action:
			EigaSpecific.Action.START_DIALOG:
				init_text.emit()
				speaker_changed.emit(inst.info.speaker)
				for s in EigaDialogParser.parse(inst.info.value):
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
				scene_trans.emit(inst.info.value)
		wait_all_call.emit()
		current_pos += 1
		await next
