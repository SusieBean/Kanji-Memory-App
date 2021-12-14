var year : int = 2021
var month : int = 1
var day : int = 1

func newDate():
	var date : Dictionary = OS.get_date()
	year = int(date["year"])
	month = int(date["month"])
	day = int(date["day"])

func stringToDate(var string):
	var array : Array = string.split("-",false)
	if(array.size() != 3):
		printerr("incorrect string input for date")
		return
	year = int(array[0])
	month = int(array[1])
	day = int(array[2])
	
func dateToString():
	return str(year) + "-" + str(month) + "-" + str(day)
	
func isPastCurrentDate() -> int:
	var date : Dictionary = OS.get_date()
	var thisYear : int = int(date["year"])
	var thisMonth : int = int(date["month"])
	var thisDay = int(date["day"])
	
	if (year != thisYear):
		return 1 if year > thisYear else -1
	if (month != thisMonth):
		return 1 if month > thisMonth else -1
	if (day != thisDay):
		return 1 if day > thisDay else -1
	return 0
	
func numOfDaysInCurrentMonth() -> int:
	match month:
		1:
			return 31
		2:
			return 28
		3:
			return 31
		4:
			return 30
		5:
			return 31
		6:
			return 30
		7:
			return 31
		8:
			return 31
		9:
			return 30
		10:
			return 31
		11:
			return 30
		12:
			return 31
	return 31

func addDays(var daysToAdd : int, var declareNewDate : bool = true):
	if declareNewDate:
		newDate()
	var numberOfDaysInThisMonth : int = numOfDaysInCurrentMonth()
	var newMonth : bool = daysToAdd + day > numberOfDaysInThisMonth
	day += daysToAdd
	day %= numberOfDaysInThisMonth
	if (day == 0):
		day = numberOfDaysInThisMonth
	if (newMonth):
		addMonths(1,false)
	
func addWeeks(var weeksToAdd: int):
	addDays(7 * weeksToAdd)
	
func addMonths(var monthsToAdd : int, var declareNewDate : bool = true):
	if declareNewDate:
		newDate()
	var newYear : bool = month + monthsToAdd > 12
	month += monthsToAdd
	month %= 12
	if (month == 0):
		month = 12
	if (newYear):
		addYears(1,false)
#		year += 1
	addDays(0,false)
	
func addYears(var yearsToAdd : int, var declareNewDate : bool = true):
	if declareNewDate:
		newDate()
	year += yearsToAdd
	addDays(0,false)
	
