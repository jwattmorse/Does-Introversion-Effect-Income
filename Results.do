* Introversion/Income Empirical Project: RESULTS * 
* Names: Robin Park, Olivia Larsen, Jacob Watt-Morse
* Date: November 21, 2014

** Run file after cleaning the data to run regressions and create data tables **

* Close open logs
capture log close

* Download outreg2 add-on to create tables, if not already installed
* ssc install outreg2

* Open log file as text format
log using "IntrovertResults.log", text replace

* Load cleaned data
adopath + "CleanData.dta"

** SUMMARY STATISTICS **

* To get an UNWEIGHTED summary table, regress including all relevant variables UNWEIGHTED
* (This will help show change due to weight)
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK HSCHOOL ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRCHILDNUM PRTAGE AGESQ TRHHCHILD_DUM, robust

* Create a summary table for the UNWEIGHTED regression
outreg2 using myfile, sum replace

* To get a WEIGHTED summary table, regress including all relevant variables WEIGHTED
* (This will help show change due to weight)
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK HSCHOOL ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRCHILDNUM PRTAGE AGESQ TRHHCHILD_DUM [weight =TUFINLWGT], robust

* Create a summary table for the WEIGHTED regression
outreg2 using myfile, sum replace

** REGRESSIONS **

* Run the UNWEIGHTED regression which uses # of kids without age
* (This will help show change due to weight)
* This corresponds with Table 2, Column 1
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK HSCHOOL ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRCHILDNUM, robust

* Create a regression table for the UNWEIGHTED regression
outreg2 using myfile, see replace

* Run the WEIGHTED regression which uses # of kids without age
* This corresponds with Table 1, Column 1
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK HSCHOOL ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRCHILDNUM [pweight = TUFINLWGT], robust

* Create a regression table for the WEIGHTED regression
outreg2 using myfile, see

* (Rest of regressions are using weighted regression only, since weights are more 
* representative of the population)

* Weighted regression which uses # of kids with age (LINEAR) 
* This corresponds with Table 2, Column 2
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK HSCHOOL PRTAGE ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRCHILDNUM [pweight =TUFINLWGT], robust

* Create a regression table
outreg2 using myfile, see

* Weighted regression which uses # of kids with age SQUARED
* This corresponds with Table 2, Column 3
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK HSCHOOL PRTAGE AGESQ ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRCHILDNUM [pw =TUFINLWGT], robust

* Create a regression table
outreg2 using myfile, see

* Weighted regression which uses DUMMY for presence of kids
* This corresponds with Table 1, Column 2
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK PRTAGE AGESQ HSCHOOL ASSOCIATE BACHELOR MALE TRSPPRES_DUM TRHHCHILD_DUM [pweight =TUFINLWGT], robust

* Create a regression table
outreg2 using myfile, see

* Weighted regression if FEMALE using dummy for presence of kids
* This corresponds with Table 1, Column 3
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK PRTAGE AGESQ HSCHOOL ASSOCIATE BACHELOR TRSPPRES_DUM TRHHCHILD_DUM if MALE ==0 [pweight =TUFINLWGT], robust

* Create a regression table
outreg2 using myfile, see

* Weighted regression if MALE using dummy for presence of kids
* This corresponds with Table 1, Column 4
reg LHOUR_WAGE TRTALONE_HOURS TEHRUSLT TRTALONE_ONLYWORK PRTAGE AGESQ HSCHOOL ASSOCIATE BACHELOR TRSPPRES_DUM TRHHCHILD_DUM if MALE ==1 [pweight =TUFINLWGT], robust

* Create a regression table
outreg2 using myfile, tex


