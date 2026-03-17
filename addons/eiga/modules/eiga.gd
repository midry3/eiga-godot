extends Control
class_name Eiga
signal scene_trans(scene: StringName)
signal add_text(text: String)
signal init_text
signal speaker_changed(speaker: String)

@export var eiga_script: EigaScript

var current_pos := 0
var executor: Executor

func run() -> void:
	executor = Executor.new(eiga_script)
	executor.scene_trans.connect(scene_trans.emit)
	executor.add_text.connect(add_text.emit)
	executor.init_text.connect(init_text.emit)
	executor.speaker_changed.connect(
		func(speaker: String):
			if speaker == "":
				speaker_changed.emit("")
			else:
				speaker_changed.emit(get_character(speaker).show_name)
	)
	executor.wait.connect(
		func(time: float):
			await get_tree().create_timer(time).timeout
			executor.waited.emit()
	)
	executor.execute()

func run_deferred() -> void:
	call_deferred("run")
	
func get_character(chara_name: String) -> EigaCharacter:
	return get_node(chara_name) as EigaCharacter

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if executor != null:
				executor.next.emit()
