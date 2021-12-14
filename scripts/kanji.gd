extends Node


var kanjiList

const CharacterEntry = preload("res://scripts/CharacterEntry.gd")
const Date = preload("res://scripts/RevisionDate.gd")
var characterArray : Array = []
var learningIndex : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var kanjidata = File.new()
	kanjidata.open("res://kanji/kanji.json",File.READ)
	var kanji_json = JSON.parse(kanjidata.get_as_text())
	kanjidata.close()
	kanjiList = kanji_json.result
	for i in kanjiList:
		addCharacterToList(i)
	loadCharacterDataToList()
	Boxes.putInBoxes()
		

func addCharacterToList(var dictEntry):
	var newCharacter = CharacterEntry.new()
	newCharacter.headCharacter = dictEntry["Head Character"]
	newCharacter.entryNumber = int(dictEntry["Entry Number"])
	newCharacter.radical = dictEntry["Radical"]
	newCharacter.nonStandardForm = dictEntry["Nonstandard Form"]
	newCharacter.entryNumberKKLD = 0#int(dictEntry["Entry Number KKLD"])
	newCharacter.listStatus = dictEntry["List Status"]
	newCharacter.strokeCount = int(dictEntry["Stroke Count"])
	
	
	newCharacter.meanings = str(dictEntry["Meaning(s)"]).split("|")
	newCharacter.readings = str(dictEntry["Readings"]).split("|")
	newCharacter.didacticVocabulary = str(dictEntry["Didactic Vocabulary"]).split("|")
	newCharacter.lookalikeCharacters = str(dictEntry["Look-alike Characters"]).split("|")
	
	
	newCharacter.mneumonic = dictEntry["Mneumonic and Other Annotations"]
	
	 
	newCharacter.addedToLearning = false
	
	characterArray.append(newCharacter)

func loadCharacterDataToList():
	var kanjidata = File.new()
	kanjidata.open("res://saveData/save.json",File.READ)
	if (kanjidata == null):
		return
	var kanji_json = JSON.parse(kanjidata.get_as_text())
	kanjidata.close()
	var dataToPass = kanji_json.result
	for i in range(0,dataToPass.size()):
		if (dataToPass[i]["Head Character"] != characterArray[i].headCharacter):
			print("Error for " + dataToPass[i]["Head Character"] + " and " + characterArray[i].headCharacter)
		var keys : Array = dataToPass[i].keys()
		if (keys.has("Is Learnt")):
			characterArray[i].addedToLearning = dataToPass[i]["Is Learnt"]
			if characterArray[i].addedToLearning:
				learningIndex+=1
		if (keys.has("BoxNum")):
			characterArray[i].boxNum = dataToPass[i]["BoxNum"]
		var currentDate : Date = Date.new()
		if (keys.has("Date For Next Study")):
			currentDate.stringToDate(dataToPass[i]["Date For Next Study"])
		else:
			currentDate.newDate()
		characterArray[i].dateForNextStudy = currentDate
			
	
func clearCharacterData():
	for i in characterArray:
		i.addedToLearning = false
		i.boxNum = - 1
		var currentDate : Date = Date.new()
		currentDate.newDate()
		i.dateForNextStudy = currentDate
	learningIndex = 0

func saveToDictionary():
	var saveDictArray : Array = []
	for i in characterArray:
		var saveDict : Dictionary
		saveDict["Head Character"] = i.headCharacter
		saveDict["Is Learnt"] = i.addedToLearning
		saveDict["BoxNum"] = i.boxNum
		var date : Date = i.dateForNextStudy
		if (date == null):
			date = Date.new()
		saveDict["Date For Next Study"] = date.dateToString()
		saveDictArray.append(saveDict)
	var kanjidata = File.new()
	kanjidata.open("res://saveData/save.json",File.WRITE)
	kanjidata.store_line("[")
	var isEnd : int = 0
	for i in saveDictArray:
		isEnd += 1
		kanjidata.store_line( "\t" + to_json(i) + ("," if isEnd != saveDictArray.size() else ""))
	kanjidata.store_line("]")
	kanjidata.close()
	
func addRandomToLearnt():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(27):
		var randomNumber : int = rng.randi()%characterArray.size()
		characterArray[randomNumber].addedToLearning = true
		
func learnNewKanji():
	var newIndex : int = (int(learningIndex/10)+1)*10
	if (newIndex > characterArray.size()):
		newIndex = characterArray.size()
	for i in range(learningIndex,newIndex):
		characterArray[i].addedToLearning = true
		characterArray[i].boxNum = 1
		characterArray[i].dateForNextStudy.addDays(1)
	learningIndex = newIndex
	print("learnt more words")
	Kanji.saveToDictionary()

