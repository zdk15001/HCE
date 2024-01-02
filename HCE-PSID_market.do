capture log close
log using market, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm market
local dte 2019-3-25
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 Load Data and Settings
use HCE-PSID_merge
note:	`tag'	#1 Load Data and Settings

//				#2	Market eligable
note:	`tag'	#2	Market eligable

gen 	 market = .
replace  market = 1 if year  >= 14
replace  market = 0 if year  <  14
replace  market = 0 if needs >= 4 // should this be included?
replace  market = 0 if needs <= 1 // should this be included?
tab 	 market, m

note 	 market: R's family is or would be market eligible `tag'
note 	 market: No missing `tag'

//				#3	Detailed census needs categories
note:	`tag'	#3	Detailed census needs categories

gen 	ineeds = .
replace ineeds = 1 if needs < 	1
replace ineeds = 2 if needs >= 1 & needs < 2
replace ineeds = 3 if needs >= 2 & needs < 3
replace ineeds = 4 if needs >= 3 & needs < 4
replace ineeds = 5 if needs >= 4 

note 	 ineeds: R's family census needs in 100% categories `tag'
note 	 ineeds: No missing `tag'

//				#4	Market place type
note:	`tag'	#4	Market place type

gen mtype = .
replace mtype = 3 if state == 1 
replace mtype = 3 if state == 2
replace mtype = 2 if state == 3 
replace mtype = 1 if state == 4
replace mtype = 1 if state == 5
replace mtype = 1 if state == 6
replace mtype = 2 if state == 7
replace mtype = 1 if state == 8
replace mtype = 3 if state == 9
replace mtype = 3 if state == 10
replace mtype = 2 if state == 11 // changes, still state
replace mtype = 2 if state == 12
replace mtype = 3 if state == 13
replace mtype = 1 if state == 14
replace mtype = 3 if state == 15
replace mtype = 1 if state == 16 // changes, still state
replace mtype = 3 if state == 17
replace mtype = 3 if state == 18
replace mtype = 1 if state == 19
replace mtype = 1 if state == 20
replace mtype = 2 if state == 21
replace mtype = 1 if state == 22
replace mtype = 3 if state == 23
replace mtype = 3 if state == 24
replace mtype = 3 if state == 25
replace mtype = 3 if state == 26
replace mtype = 2 if state == 27
replace mtype = 2 if state == 28
replace mtype = 3 if state == 29
replace mtype = 2 if state == 30
replace mtype = 1 if state == 31
replace mtype = 3 if state == 32
replace mtype = 3 if state == 33
replace mtype = 3 if state == 34
replace mtype = 3 if state == 35
replace mtype = 2 if state == 36
replace mtype = 3 if state == 37
replace mtype = 1 if state == 38
replace mtype = 3 if state == 39
replace mtype = 3 if state == 40
replace mtype = 3 if state == 41
replace mtype = 3 if state == 42
replace mtype = 3 if state == 43
replace mtype = 1 if state == 44
replace mtype = 3 if state == 45
replace mtype = 1 if state == 46
replace mtype = 2 if state == 47
replace mtype = 3 if state == 48
replace mtype = 3 if state == 49
replace mtype = 3 if state == 50
replace mtype = 1 if state == 51 // changes, still state
tab mtype, m
replace mtype = 0 if year < 14
replace mtype = 0 if market == 0
tab mtype, m	

label define mtype				///
0	"no marketplace"			///
1	"State-Based"				///
2	"State-Partnership"   		///
3	"Federally-Facilitated" 		

		
	
label	variable	mtype "marketplace type"
label 	values		mtype mtype 
note				mtype: marketplace type, no missing `tag'


//				#5	state or federal
note:	`tag'	#5	state or federal

* make stateH
gen stateH = .
replace stateH = 0 if state == 1 
replace stateH = 0 if state == 2
replace stateH = 1 if state == 3 
replace stateH = 1 if state == 4
replace stateH = 1 if state == 5
replace stateH = 1 if state == 6
replace stateH = 1 if state == 7
replace stateH = 1 if state == 8
replace stateH = 0 if state == 9
replace stateH = 0 if state == 10
replace stateH = 1 if state == 11
replace stateH = 1 if state == 12
replace stateH = 0 if state == 13
replace stateH = 1 if state == 14
replace stateH = 0 if state == 15
replace stateH = 1 if state == 16
replace stateH = 0 if state == 17
replace stateH = 0 if state == 18
replace stateH = 1 if state == 19
replace stateH = 1 if state == 20
replace stateH = 1 if state == 21
replace stateH = 1 if state == 22
replace stateH = 0 if state == 23
replace stateH = 0 if state == 24
replace stateH = 0 if state == 25
replace stateH = 0 if state == 26
replace stateH = 1 if state == 27
replace stateH = 1 if state == 28
replace stateH = 0 if state == 29
replace stateH = 1 if state == 30
replace stateH = 1 if state == 31
replace stateH = 0 if state == 32
replace stateH = 0 if state == 33
replace stateH = 0 if state == 34
replace stateH = 0 if state == 35
replace stateH = 1 if state == 36
replace stateH = 0 if state == 37
replace stateH = 1 if state == 38
replace stateH = 0 if state == 39
replace stateH = 0 if state == 40
replace stateH = 0 if state == 41
replace stateH = 0 if state == 42
replace stateH = 0 if state == 43
replace stateH = 1 if state == 44
replace stateH = 0 if state == 45
replace stateH = 1 if state == 46
replace stateH = 1 if state == 47
replace stateH = 0 if state == 48
replace stateH = 0 if state == 49
replace stateH = 0 if state == 50
replace stateH = 1 if state == 51
tab stateH, m

drop if stateH == .
*	when market
gen stateHm = stateH
replace stateHm = 0 if year < 14
replace stateHm = 0 if market == 0
tab stateHm, m	

gen stateHmtype = stateH
replace stateHmtype = 2 if stateHmtype == 1
replace stateHmtype = 1 if stateHmtype == 0
replace stateHmtype = 0 if year < 14
replace stateHmtype = 0 if ineeds == 1
replace stateHmtype = 0 if ineeds == 5
tab stateHmtype, m


//				#6	After   
note:	`tag'	#6	After

gen after = . 
replace after = 1 if year > 14
replace after = 0 if year < 14
tab after, m



//				#7	Save and Close Log
note:	`tag'	#7	Save and Close Log 

save "HCE-PSID", replace

clear
log close
exit
