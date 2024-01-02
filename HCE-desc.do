capture log close
log using HCE-MLM, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm HCE-desc
local dte 2019-10-24
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 Load Data and Settings
use HCE-PSID
note:	`tag'	#1 Load Data and Settings

//  			#2 descriptive statistics
note:	`tag'	#2 descriptive statistics

sum Aincome Ahex  [aw=weight] 
sum meligable  [aw=weight] 
tab1 family state ineeds  [aw=weight] , m

foreach continuous in cincome chex meligable burden premium_bu{
bys year: sum `continuous'  [aw=weight] 
}

foreach categorical in ineeds{
bys year: tab `categorical'  [aw=weight] 
}

pwcorr lnhex Aincome  [aw=weight]  , sig

//  			#3 descriptive statistics, state level
note:	`tag'	#3 descriptive statistics, state level

recode ineeds (1=1) (2/5 = 0) (else = .), gen(needs100)
tab needs100, m

recode ineeds (1=0) (2=1) (3=1) (4=1) (5=0) (else=.), gen(needs400)
tab needs400, m 


*	 count state
bys state: count

*	collapse
collapse (mean) 							///
Savghex   = hex 	 Smeligable = meligable ///
Sneeds100 = needs100 Sweight  = weight	///  
Sneeds400 = needs400					  , ///
by(state year)

***	Biggest increases 
gen Savghex_range = .
forvalues state = 1/51 {
sum Savghex if state == `state'
replace Savghex_range = r(max)-r(min) if state == `state'
}

tab Savghex_range, m
sum Savghex_range	

*	Get averages

bys state: sum Savghex Savghex_range Sneeds100 Sneeds400 Smeligable [aw=Sweight]

bys state: sum Sneeds100 Sneeds400 Smeligable [aw=Sweight]


//				#4	Save and Close Log
note:	`tag'	#4	Save and Close Log 

clear
log close
exit







