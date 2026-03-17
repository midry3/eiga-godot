@tool
extends CharacterBody2D
class_name EigaCharacter

@export var show_name: String
@export var sprite_frames: SpriteFrames

var anim: AnimatedSprite2D

func _ready():
	if sprite_frames != null:
		anim = AnimatedSprite2D.new()
		anim.sprite_frames = sprite_frames
		add_child(anim)
