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
	call_deferred("_run")

func _run() -> void:
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
	executor.func_called.connect(
		func(func_name: String, args: Array):
			var f := get_function(func_name)
			f.call(args)
	)
	executor.execute()
	
func get_character(chara_name: String) -> EigaCharacter:
	return get_node(chara_name) as EigaCharacter

func get_function(func_name: String) -> Callable:
	var f := func_name.split(".", false, 1)
	if len(f) == 1:
		return func(arr: Array): callv(f[0], arr)
	else:
		return func(arr: Array): get_character(f[0]).callv(f[1], arr)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if executor != null:
				executor.next.emit()
