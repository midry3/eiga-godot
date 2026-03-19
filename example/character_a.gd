extends EigaCharacter

func pr(a: String, time: float=3.0):
	await get_tree().create_timer(time).timeout
	print(a)
