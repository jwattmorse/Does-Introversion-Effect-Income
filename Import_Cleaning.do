* Introversion/Income Empirical Project *
* Names: Robin Park, Olivia Larsen, Jacob Watt-Morse
* Date: November 3, 2014

*** NOTE: Before loading data, locate the Relevant Data folder. Use 'File >
*** Change Working Directory' to set the working directory as Relevant Data. 

** MERGING DATA **

* Clear any previously loaded data from Stata
clear

* Close any open log file
capture log close

* Open log file as text format 
log using "IntrovertLog.log", text replace

* Open file with data of individual's reported use of time
use "30901-0005-Data.dta"

* Convert case and person ID numbers to string variables (to make it compatible
* with the variables in the Education data set)
tostring TUCASEID TULINENO, replace

* Sort data using case and person ID numbers
sort TUCASEID TULINENO

* Save sorted data set
save "Respondent2.dta", replace

* Clear data from Stata
clear

* Open file with data of individual's and household members' personal traits
use "30901-0006-Data.dta"

* Convert TUCASEID and TULINENO to string variables and sort
tostring TUCASEID TULINENO, replace
sort TUCASEID TULINENO

* Save sorted data set
save "Roster2.dta", replace

* Only keep cases that have values for TUCASEID and TULINENO in all data sets
merge 1:1 TUCASEID TULINENO using "Respondent2.dta"
keep if _merge == 3
drop _merge

* Save merged data
save "MergedResRos.dta", replace 

* Clear data from Stata
clear

* Open file with data containing education information
use "30901-0004-Data.dta" 

* String and sort data using case and person ID numbers
tostring TUCASEID TULINENO, replace
sort TUCASEID TULINENO

* Save sorted data set
save "Education2.dta", replace

* Merge this data set with the previously merged data set 
merge 1:1 TUCASEID TULINENO using "MergedResRos.dta"

* Only keep cases that have values for TUCASEID and TULINENO in all data sets
keep if _merge == 3
drop _merge

** MANIPULATING VARIABLES **

* Convert string variable (total hours usually worked per week) to integers
destring TEHRUSLT, replace

* Drop cases in which people did not report their earnings or hours usually worked per week
drop if TEHRUSLT == -4

* Create variable that represents the number of minutes an individual spends alone at work
gen TRTALONE_ONLYWORK = TRTALONE_WK - TRTALONE

* Create variable that represents nonwork hours spent alone per week
gen TRTALONE_HOURS = TRTALONE/60

* Changes presence of child variable to a dummy variable (0 = no, 1 = yes) 
gen TRHHCHILD_DUM = TRHHCHILD
replace TRHHCHILD_DUM = 0 if TRHHCHILD == 2

* Changes sex variable to a dummy variable (0 = female, 1 = male)
gen MALE = TESEX
replace MALE = 0 if TESEX == 2

* Changes presence of partner from a 3 part dummy to 2 part dummy
gen TRSPPRES_DUM = TRSPPRES
replace TRSPPRES_DUM = 1 if TRSPPRES == 2
replace TRSPPRES_DUM = 0 if TRSPPRES == 3

* Genearate variables HSDROP HSCHOOL ASSOCIATE BACHELOR
* Each Dummy indicates what level of education the person most obtained
* HSDROP is a dummy variable indicating if respondent did not finish High School 
* if HSDROP = 1
gen HSDROP = PEEDUCA
replace HSDROP = 1 if PEEDUCA <= 38
replace HSDROP = 0 if PEEDUCA > 38

* HSCHOOL is a dummy that indicates if the person finished high school but did
* not obtain a higher degree
gen HSCHOOL = PEEDUCA
replace HSCHOOL = 1 if PEEDUCA == 39| PEEDUCA == 40
replace HSCHOOL = 0 if PEEDUCA > 40| PEEDUCA < 39

* ASSOCIATE is a dummy that indicate if the respondent has an assocaites degree
gen ASSOCIATE = PEEDUCA
replace ASSOCIATE = 1 if PEEDUCA == 41| PEEDUCA == 42
replace ASSOCIATE = 0 if PEEDUCA < 41 | PEEDUCA > 42 

*BACHELOR is a dummy that indicates if the repsondent has a bachelors degree or higher
gen BACHELOR = PEEDUCA
replace BACHELOR = 1 if PEEDUCA >= 43
replace BACHELOR = 0 if PEEDUCA < 43

* Drop missing data and people who work for no wage
drop if TRERNHLY == -1
drop if TRERNHLY == 0

* Create new variable that represent hourly wage in dollors not cents
gen HOUR_WAGE = TRERNHLY/100
gen LHOUR_WAGE = ln(HOUR_WAGE)

* Creates a dummy that indicates if the respondent is White or non-White
gen WHITE = PTDTRACE
replace WHITE = 1 if PTDTRACE == 1
replace WHITE = 0 if PTDTRACE == 0

* Drop if people not between ages of 18 and 64
drop if PRTAGE < 18 | PRTAGE > 64

*Create Age Squared Variable
gen AGESQ = PRTAGE^2

* Create Dummy for age ranges
* YOUTH = 18-26, MIDDLE = 27-44 MATURE = 45-64
gen YOUTH = PRTAGE
replace YOUTH = 1 if PRTAGE < 27
replace YOUTH = 0 if PRTAGE >= 27

gen MIDDLE = PRTAGE
replace MIDDLE = 1 if PRTAGE >= 27 & PRTAGE <= 64
replace MIDDLE = 0 if PRTAGE < 27 | PRTAGE > 64 

gen MATURE = PRTAGE
replace MATURE = 1 if PRTAGE > 64
replace MATURE = 0 if PRTAGE <= 64

* Save updated clean data
save "CleanData.dta", replace

* Close log
log close
