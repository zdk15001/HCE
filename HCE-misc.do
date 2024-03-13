
capture log close
log using HCE-misc, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Miscellaneous tasks completed as part of the peer-review process
local pgm HCE-misc
local dte 2023-5-24
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 Load Data and Settings
use HCE-PSID
note:	`tag'	#1 Load Data and Settings



note:	`tag'	#2 Figure A1: Mechanism 1: Increased insurance rates
//  			#2 Figure A1: Mechanism 1: Increased insurance rates



xtreg insurance   i.ineeds i.meligable i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH if medicare == 0 [aw=weight] , fe i(ID)		

predict prob

label define after			///
0	"Before 2014"	///
1	"After 2014"  	


label define stateH			///
0	"Federal Marketplace"	///
1	"State Marketplace"  	


label define ineeds			///
1	"Needs 0 - 100%"		///
2	"Needs 100 - 200%"  	///
3	"Needs 200 - 300%"		///
4	"Needs 300 - 400%"  	///
5	"Needs 400%+"	

	
label	variable	after "After 2014"
label 	values		after after 

label	variable	stateH "Marketplace Type"
label 	values		stateH stateH 

label	variable	ineeds "Needs Category"
label 	values		ineeds ineeds 

label variable prob "Predicted Probability of Insurance Coverage"

graph dot prob, over(after) over(ineeds) over(stateH) 

collapse (mean) prob ,	by(after ineeds after stateH)


note:	`tag'	#3 Figure A2: Mechanism 2: Doesn't change premiums (for those with insurance)
//  			#3 Figure A2: Mechanism 2: Doesn't change premiums (for those with insurance)
clear
use HCE-PSID


xtreg hiex i.ineeds i.meligable i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH [aw=weight] if insurance == 1 & medicare == 0, fe i(ID)		

predict unlogged


label define after			///
0	"Before 2014"	///
1	"After 2014"  	


label define stateH			///
0	"Federal Marketplace"	///
1	"State Marketplace"  	


label define ineeds			///
1	"Needs 0 - 100%"		///
2	"Needs 100 - 200%"  	///
3	"Needs 200 - 300%"		///
4	"Needs 300 - 400%"  	///
5	"Needs 400%+"	

	
label	variable	after "After 2014"
label 	values		after after 

label	variable	stateH "Marketplace Type"
label 	values		stateH stateH 

label	variable	ineeds "Needs Category"
label 	values		ineeds ineeds 


graph dot unlogged, over(after) over(ineeds) over(stateH) 
collapse (mean) unlogged ,	by(after ineeds after stateH)

note:	`tag'	#4 Figure A3: Mechanism 3: Decreased OOP   (for those with insurance)
//  			#4 Figure A3: Mechanism 3: Decreased OOP   (for those with insurance)

clear
use HCE-PSID

gen hex_oop = hex - hiex
gen lnhex_oop = ln(hex_oop)
replace lnhex_oop = 0 if lnhex_oop == .

gen pays_oop = 0
replace pays_oop = 1 if hex_oop > 0

xtreg lnhex_oop  i.ineeds i.insurance i.meligable i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH if insurance == 1 & medicare == 0 [aw=weight] , fe i(ID)		
levpredict unlogged


label define after			///
0	"Before 2014"	///
1	"After 2014"  	


label define stateH			///
0	"Federal Marketplace"	///
1	"State Marketplace"  	


label define ineeds			///
1	"Needs 0 - 100%"		///
2	"Needs 100 - 200%"  	///
3	"Needs 200 - 300%"		///
4	"Needs 300 - 400%"  	///
5	"Needs 400%+"	

	
label	variable	after "After 2014"
label 	values		after after 

label	variable	stateH "Marketplace Type"
label 	values		stateH stateH 

label	variable	ineeds "Needs Category"
label 	values		ineeds ineeds 

graph dot unlogged, over(after) over(ineeds) over(stateH) 

collapse (mean) unlogged ,	by(after ineeds after stateH)






note:	`tag'	#5 main effects conditional on insurance
//  			#5 main effects conditional on insurance

* with insurance
xtreg lnhex i.ineeds  i.meligable i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH if insurance == 1 & medicare == 0 [aw=weight]  , fe i(ID)	

* without insurance	
xtreg lnhex i.ineeds  i.meligable i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH if insurance == 0 & medicare == 0 [aw=weight]  , fe i(ID)		

	


	
note:	`tag'	#6 Other Trends
//  			#6 Other Trends

********* ln hiex

clear
use HCE-PSID


collapse (mean) lnhiex, by(year ineeds stateH)



label define stateH			///
0	"Federal Marketplace"	///
1	"State Marketplace"  	


label define ineeds			///
1	"Needs 0 - 100%"		///
2	"Needs 100 - 200%"  	///
3	"Needs 200 - 300%"		///
4	"Needs 300 - 400%"  	///
5	"Needs 400%+"	



twoway ///
    (line lnhiex year if ineeds == 1 & stateH == 0, lcolor(gs12) lpattern(dash)) ///
    (line lnhiex year if ineeds == 1 & stateH == 1, lcolor(gs12) lpattern(solid)) ///
    (line lnhiex year if ineeds == 2 & stateH == 0, lcolor(gs8) lpattern(dash)) ///
    (line lnhiex year if ineeds == 2 & stateH == 1, lcolor(gs8) lpattern(solid)) ///
    (line lnhiex year if ineeds == 3 & stateH == 0, lcolor(gs5) lpattern(dash)) ///
    (line lnhiex year if ineeds == 3 & stateH == 1, lcolor(gs5) lpattern(solid)) ///
    (line lnhiex year if ineeds == 4 & stateH == 0, lcolor(gs3) lpattern(dash)) ///
    (line lnhiex year if ineeds == 4 & stateH == 1, lcolor(gs3) lpattern(solid)) ///
    (line lnhiex year if ineeds == 5 & stateH == 0, lcolor(gs1) lpattern(dash)) ///
    (line lnhiex year if ineeds == 5 & stateH == 1, lcolor(gs1) lpattern(solid)), ///
    ytitle("Mean Premium Expenditures (logged)") xtitle("Year") ///
    title("Expenditure Trend by Income Needs Category") ///
    legend(order(9 "Federal Marketplace" 10 "State Marketplace" )) 


********* burden measured as continuous ~ pct

clear
use HCE-PSID

gen pctburden = burden*100
collapse (mean) pctburden, by(year ineeds stateH)



label define stateH			///
0	"Federal Marketplace"	///
1	"State Marketplace"  	


label define ineeds			///
1	"Needs 0 - 100%"		///
2	"Needs 100 - 200%"  	///
3	"Needs 200 - 300%"		///
4	"Needs 300 - 400%"  	///
5	"Needs 400%+"	



twoway ///
    (line pctburden year if ineeds == 1 & stateH == 0, lcolor(gs12) lpattern(dash)) ///
    (line pctburden year if ineeds == 1 & stateH == 1, lcolor(gs12) lpattern(solid)) ///
    (line pctburden year if ineeds == 2 & stateH == 0, lcolor(gs8) lpattern(dash)) ///
    (line pctburden year if ineeds == 2 & stateH == 1, lcolor(gs8) lpattern(solid)) ///
    (line pctburden year if ineeds == 3 & stateH == 0, lcolor(gs5) lpattern(dash)) ///
    (line pctburden year if ineeds == 3 & stateH == 1, lcolor(gs5) lpattern(solid)) ///
    (line pctburden year if ineeds == 4 & stateH == 0, lcolor(gs3) lpattern(dash)) ///
    (line pctburden year if ineeds == 4 & stateH == 1, lcolor(gs3) lpattern(solid)) ///
    (line pctburden year if ineeds == 5 & stateH == 0, lcolor(gs1) lpattern(dash)) ///
    (line pctburden year if ineeds == 5 & stateH == 1, lcolor(gs1) lpattern(solid)), ///
    ytitle("Mean Burden (Percent))") xtitle("Year") ///
    title("Expenditure Trend by Income Needs Category") ///
    legend(order(9 "Federal Marketplace" 10 "State Marketplace" )) 



********* premium burden

clear
use HCE-PSID

gen pctburden = premium_burden*100
collapse (mean) pctburden, by(year ineeds stateH)



label define stateH			///
0	"Federal Marketplace"	///
1	"State Marketplace"  	


label define ineeds			///
1	"Needs 0 - 100%"		///
2	"Needs 100 - 200%"  	///
3	"Needs 200 - 300%"		///
4	"Needs 300 - 400%"  	///
5	"Needs 400%+"	



twoway ///
    (line pctburden year if ineeds == 2 & stateH == 0, lcolor(gs8) lpattern(dash)) ///
    (line pctburden year if ineeds == 2 & stateH == 1, lcolor(gs8) lpattern(solid)) ///
    (line pctburden year if ineeds == 3 & stateH == 0, lcolor(gs5) lpattern(dash)) ///
    (line pctburden year if ineeds == 3 & stateH == 1, lcolor(gs5) lpattern(solid)) ///
    (line pctburden year if ineeds == 4 & stateH == 0, lcolor(gs3) lpattern(dash)) ///
    (line pctburden year if ineeds == 4 & stateH == 1, lcolor(gs3) lpattern(solid)) ///
    (line pctburden year if ineeds == 5 & stateH == 0, lcolor(gs1) lpattern(dash)) ///
    (line pctburden year if ineeds == 5 & stateH == 1, lcolor(gs1) lpattern(solid)), ///
    ytitle("Mean Burden (Percent))") xtitle("Year") ///
    title("Expenditure Trend by Income Needs Category") ///
    legend(order(9 "Federal Marketplace" 10 "State Marketplace" )) 


//				#7	Save and Close Log
note:	`tag'	7	Save and Close Log 

clear
log close
exit
