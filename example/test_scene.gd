extends Node2D

@onready var eiga := $Eiga
@onready var script_ := $Script
@onready var label := $Label

func _ready():
	eiga.run()

func _on_eiga_scene_trans(scene):
	get_tree().change_scene_to_file(scene)

func _on_eiga_add_text(text):
	for t in text:
		script_.text += t
		await get_tree().create_timer(0.1).timeout
	eiga.emit_added_text()

func _on_eiga_init_text():
	script_.text = ""


func _on_eiga_speaker_changed(speaker):
	label.text = speaker


func _on_eiga_dialogue_finished():
	print("fin!")
