extends Node
class_name Executor
signal func_called(func_name: String, args: Array)
signal add_text(serif: String)
signal init_text
signal speaker_changed(speaker: String)
signal scene_trans(scene: StringName)
signal next
signal wait(time: float)
signal waited

var eiga_script: EigaScript
var current_pos := 0

func _init(eiga_script: EigaScript):
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
						EigaSpecific.Function.WAIT:
							wait.emit(s.args[0])
							await waited
						EigaSpecific.Function.PAUSE:
							await next
						EigaSpecific.Function.CALL:
							func_called.emit(s.args[0], s.args.slice(1, s.args.size()))
			EigaSpecific.Action.TRANS:
				scene_trans.emit(inst.info.value)
		current_pos += 1
		await next

func script_executor() -> void:
	pass
