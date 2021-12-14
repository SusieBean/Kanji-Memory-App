const Date = preload("res://scripts/RevisionDate.gd")



var headCharacter = ""
var entryNumber : int = 0
var radical = ""
var nonStandardForm = ""
var entryNumberKKLD : int = 0
var listStatus = ""
var strokeCount : int = 0
var meanings : Array = []
var readings : Array = []
var didacticVocabulary : Array = []
var lookalikeCharacters : Array = []

var mneumonic  = ""

var addedToLearning : bool = false
var dateForNextStudy : Date
var boxNum : int = -1

func numOfMeanings() -> int:
	return meanings.size()


func meanings_list():
	var meaningsString = ""
	for Count in range(0,meanings.size()):
		var startingPoint = str(Count + 1) + ". "
		if meanings.size()== 1:
			startingPoint = ""
		if Count > 0 && !(meanings.size() > 2 && Count%2 == 1):
			meaningsString += "\n"
		meaningsString += startingPoint +  meanings[Count]
		if meanings.size() > 2 && Count%2 == 0 && Count != meanings.size() - 1:
			meaningsString += "       "
	return meaningsString

func readings_list():
	var readingsString = ""
	for Count in range(0, readings.size()):
		var startingPoint = ", "
		if Count == 0:
			startingPoint = ""
		readingsString += startingPoint + readings[Count]
	return readingsString
	
func examples_list():
	var examplesString = ""
	for Count in range(0, didacticVocabulary.size()):
		var startingPoint = "\n"
		if Count == 0:
			startingPoint = ""
		examplesString += startingPoint + "> "  + didacticVocabulary[Count]
	return examplesString
		
func lookalike_list():
	var lookalikesString = ""
	for Count in range(0, lookalikeCharacters.size()):
		var startingPoint = ", "
		if Count == 0:
			startingPoint = ""
		lookalikesString += startingPoint + lookalikeCharacters[Count]
	return lookalikesString	
		
func changeBox(var newBox : int):
	var oldBoxNum : int = boxNum
	boxNum = newBox
	match boxNum:
		1:
			match oldBoxNum:
				1:
					Boxes.dailyCharacters.erase(self)
				2:
					Boxes.otherDailyCharacters.erase(self)
				3:
					Boxes.weeklyCharacters.erase(self)
				4:
					Boxes.biweeklyCharacters.erase(self)
				5:
					Boxes.monthlyCharacters.erase(self)
				6:
					Boxes.quarterYearlyCharacters.erase(self)
				7: 
					Boxes.halfYearlyCharacters.erase(self)
				8:
					Boxes.yearlyCharacters.erase(self)
			dateForNextStudy.addDays(1)
			Boxes.dailyCharacters.append(self)
		2:

			dateForNextStudy.addDays(2)
			Boxes.otherDailyCharacters.append(self)
			Boxes.dailyCharacters.erase(self)
		3: 
			dateForNextStudy.addWeeks(1)
			Boxes.weeklyCharacters.append(self)
			Boxes.otherDailyCharacters.erase(self)
		4: 
			dateForNextStudy.addWeeks(2)
			Boxes.biweeklyCharacters.append(self)
			Boxes.weeklyCharacters.erase(self)
		5: 
			dateForNextStudy.addMonths(1)
			Boxes.monthlyCharacters.append(self)
			Boxes.biweeklyCharacters.erase(self)
		6:
			dateForNextStudy.addMonths(3)
			Boxes.quarterYearlyCharacters.append(self)
			Boxes.monthlyCharacters.erase(self)
		7:
			dateForNextStudy.addMonths(6)
			Boxes.halfYearlyCharacters.append(self)
			Boxes.quarterYearlyCharacters.erase(self)
		8:
			dateForNextStudy.addYears(1)
			Boxes.dateForNextStudy.append(self)
			Boxes.halfYearlyCharacters.erase(self)
		_:
			printerr("This character does not belong to an existing box")
			boxNum = -1
			Boxes.notBeganRevision.append(self)
