extends Node2D



func _ready():
	Kanji.saveToDictionary()

func _on_FlashCardButton_button_down():
	if (Kanji.learningIndex == 0):
		print("You have't started learning yet!")
		return
	FlashCardIndex.setMinMax(0, Kanji.learningIndex)
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_KanjiListButton_button_down():
	get_tree().change_scene("res://scenes/KanjiListScene.tscn")


func _on_LearnButton_button_down():
	var oldMax = Kanji.learningIndex
	Kanji.learnNewKanji()
	Boxes.clearAll()
	FlashCardIndex.setMinMax(oldMax, Kanji.learningIndex)
	get_tree().change_scene("res://scenes/Main.tscn")

	


func _on_Revise_button_down():
	if (Kanji.learningIndex == 0):
		print("You have't started learning yet!")
		return
	get_tree().change_scene("res://scenes/TestQuickFire.tscn")

func _on_Reset_button_down():
	Kanji.clearCharacterData()
	Kanji.saveToDictionary()
	Boxes.clearAll()
