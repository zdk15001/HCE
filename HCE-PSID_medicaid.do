capture log close
log using HCE-PSID_medicaid, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm HCE-PSID_medicaid
local dte 2019-2-12
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//				#1	Adjust Settings and load data
note:	`tag'	#1	Adjust Settings and load data

set more off, permanently 
use "HCE-PSID_expenditures"

//  			#2	medicaid eligability by state
note:	`tag' 	#2	medicaid eligability by state

codebook  state05 state07 state09 state11 state13 state15 state17 state19, m

merge m:1 state05 using medicaid05, nogenerate
merge m:1 state07 using medicaid07, nogenerate
merge m:1 state09 using medicaid09, nogenerate
merge m:1 state11 using medicaid11, nogenerate
merge m:1 state13 using medicaid13, nogenerate
merge m:1 state15 using medicaid15, nogenerate
merge m:1 state17 using medicaid17, nogenerate
merge m:1 state19 using medicaid19


drop if _merge == 2
drop if _merge == 1
drop _merge							

//  			#4	Eligable for medicaid in state
note:	`tag' 	#4	Eligable for medicaid in state

gen meligable05 = 0
gen meligable07 = 0
gen meligable09 = 0
gen meligable11 = 0
gen meligable13 = 0
gen meligable15 = 0
gen meligable17 = 0
gen meligable19 = 0

replace meligable05 = 1 if											///
(((needs05 	<= mparent05) & (family05 ==  1 | family05 == 3))	|	///
 ((needs05 	<= moadult05) & (family05 ==  2 | family05 == 4)))
 
 replace meligable07 = 1 if											///
(((needs07 	<= mparent07) & (family07 ==  1 | family07 == 3))	|	///
 ((needs07 	<= moadult07) & (family07 ==  2 | family07 == 4)))
 
 replace meligable09 = 1 if											///
(((needs09 	<= mparent09) & (family09 ==  1 | family09 == 3))	|	///
 ((needs09 	<= moadult09) & (family09 ==  2 | family09 == 4)))
 
 replace meligable11 = 1 if											///
(((needs11 	<= mparent11) & (family11 ==  1 | family11 == 3))	|	///
 ((needs11 	<= moadult11) & (family11 ==  2 | family11 == 4)))

replace meligable13 = 1 if											///
(((needs13 	<= mparent13) & (family13 ==  1 | family13 == 3))	|	///
 ((needs13 	<= moadult13) & (family13 ==  2 | family13 == 4)))

replace meligable15 = 1 if											///
(((needs15 	<= mparent15) & (family15 ==  1 | family15 == 3))	|	///
 ((needs15 	<= moadult15) & (family15 ==  2 | family15 == 4)))
 
replace meligable17 = 1 if											///
(((needs17 	<= mparent17) & (family17 ==  1 | family17 == 3))	|	///
 ((needs17 	<= moadult17) & (family17 ==  2 | family17 == 4)))
 
 
replace meligable19 = 1 if											///
(((needs17 	<= mparent19) & (family19 ==  1 | family17 == 3))	|	///
 ((needs17 	<= moadult19) & (family19 ==  2 | family17 == 4)))
 
 
tab1 	meligable05 meligable07 meligable09 				///
		meligable11 meligable13 meligable15 meligable17, m 

//				#5	Save and Close Log
note:	`tag'	#5	Save and Close Log 

save 	"HCE-PSID_medicaid", replace 
clear
log close
exit
