capture log close
log using HCE-MLM, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm HCE-MLM
local dte 2019-4-8
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 Load Data and Settings
use HCE-PSID
note:	`tag'	#1 Load Data and Settings



note:	`tag'	#1 Main model  + predictions  for table
//  			#1 Main model + predictions for table


xtreg lnhex  i.meligable  i.insurance i.ineeds   i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH if medicare == 0  [aw=weight] , fe i(ID)		
levpredict unlogged, duan 

keep if meligable == 0 & insurance == 1
collapse (mean) unlogged ,	by(after ineeds after stateH)

* for averages
clear
use HCE-PSID

xtreg lnhex  i.meligable  i.insurance   i.stateH##after  if medicare == 0  [aw=weight] , fe i(ID)		
levpredict unlogged, duan 

keep if meligable == 0 & insurance == 1
collapse (mean) unlogged ,	by(after after stateH)


//  			#2 figure 1 show trends 
note:	`tag'	#2 figure 1 show trends 


clear
use HCE-PSID

replace year = year + 2000
collapse (mean) lnhex, by(year ineeds stateH)



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
    (line lnhex year if ineeds == 1 & stateH == 0, lcolor(gs12) lpattern(dash)) ///
    (line lnhex year if ineeds == 1 & stateH == 1, lcolor(gs12) lpattern(solid)) ///
    (line lnhex year if ineeds == 2 & stateH == 0, lcolor(gs8) lpattern(dash)) ///
    (line lnhex year if ineeds == 2 & stateH == 1, lcolor(gs8) lpattern(solid)) ///
    (line lnhex year if ineeds == 3 & stateH == 0, lcolor(gs5) lpattern(dash)) ///
    (line lnhex year if ineeds == 3 & stateH == 1, lcolor(gs5) lpattern(solid)) ///
    (line lnhex year if ineeds == 4 & stateH == 0, lcolor(gs3) lpattern(dash)) ///
    (line lnhex year if ineeds == 4 & stateH == 1, lcolor(gs3) lpattern(solid)) ///
    (line lnhex year if ineeds == 5 & stateH == 0, lcolor(gs1) lpattern(dash)) ///
    (line lnhex year if ineeds == 5 & stateH == 1, lcolor(gs1) lpattern(solid)), ///
    ytitle("Mean Expenditures (logged)") xtitle("Year") ///
    legend(order(9 "Federal Marketplace" 10 "State Marketplace" )) ///
    xline(2014, lcolor(black) lpattern(solid) lwidth(med)) ///
    text(4 2016.5 "Affordable Care Act")



	
	
	
//  			#3 figure 2 - dot plot
note:	`tag'	#3 figure 2 - dot plot

clear
use HCE-PSID


xtreg lnhex i.meligable  i.insurance i.ineeds  i.ineeds i.insurance  i.meligable i.ineeds#i.stateH i.ineeds#after i.ineeds#after#i.stateH  [aw=weight] if medicare == 0, fe i(ID)		

levpredict unlogged, duan
keep if meligable == 0 & insurance == 1

// dot plot

graph dot unlogged, over(after) over(ineeds) over(stateH) 

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

label variable unlogged "Predicted Out-of-Pocket Expenditures"

graph dot unlogged, over(after) over(ineeds) over(stateH) 







	

//				#4	Save and Close Log
note:	`tag'	#4	Save and Close Log 

clear
log close
exit


























