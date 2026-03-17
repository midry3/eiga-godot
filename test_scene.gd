extends Node2D

@onready var eiga := $Eiga
@onready var script_ := $Script
@onready var label := $Label

func _ready():
	eiga.run_deferred()

func _on_eiga_scene_trans(scene):
	get_tree().change_scene_to_file(scene)


func _on_eiga_add_text(text):
	script_.text += text

func _on_eiga_init_text():
	script_.text = ""


func _on_eiga_speaker_changed(speaker):
	label.text = speaker
