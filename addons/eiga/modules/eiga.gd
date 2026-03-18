extends Control
class_name Eiga
signal all_call_finished
signal scene_trans(scene: StringName)
signal add_text(text: String)
signal init_text
signal speaker_changed(speaker: String)

@export var eiga_script: EigaScript

var current_pos := 0
var executor: Executor
var calls_finished: Array[bool] = []
var wait_all_call_finished := false

func run() -> void:
	call_deferred("_run")

func _run() -> void:
	executor = Executor.new(eiga_script)
	executor.scene_trans.connect(scene_trans.emit)
	executor.add_text.connect(add_text.emit)
	executor.init_text.connect(init_text.emit)
	executor.speaker_changed.connect(
		func(speaker: String):
			calls_finished.clear()
			wait_all_call_finished = false
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
		func(func_name: String, wait: bool, args: Array):
			var f := get_function(func_name)
			var idx := len(calls_finished)
			call_function(func(): await f.call(args))
			if wait:	
				while !calls_finished[idx]:
					await get_tree().create_timer(0.5).timeout
			await get_tree().create_timer(0.1).timeout
			executor.call_finished.emit()
	)
	executor.wait_all_call.connect(
		func():
			wait_all_call_finished = true
	)
	executor.execute()
	
func get_character(chara_name: String) -> EigaCharacter:
	return get_node(chara_name) as EigaCharacter
	
func call_function(f: Callable) -> void:
	var idx := len(calls_finished)
	calls_finished.append(false)
	await f.call()
	calls_finished[idx] = true
	if is_all_call_finished():
		all_call_finished.emit()

func is_all_call_finished() -> bool:
	for fin in calls_finished:
		if !fin: return false
	return true

func get_function(func_name: String) -> Callable:
	var f := func_name.split(".", false, 1)
	if len(f) == 1:
		return func(arr: Array): await callv(f[0], arr)
	else:
		return func(arr: Array): await get_character(f[0]).callv(f[1], arr)

func emit_next() -> void:
	if !wait_all_call_finished or (wait_all_call_finished and is_all_call_finished()):
		executor.next.emit()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if executor != null:
				emit_next()
