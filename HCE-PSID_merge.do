
capture log close
log using HCE-PSID_source, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  	HCE: Infix Source Data
local pgm HCE-PSID_source
local dte 2019-1-31
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//				#1	Adjust Settings
note:	`tag'	#1	Adjust Settings

set more off, permanently 

use "HCE-PSID_medicaid"

//  			#2	weights 
note:	`tag' 	#2	weights 

*		Drop missing
codebook ER28078_05, m
	*	No missing
****	05

gen weights05 = ER28078_05

***		Drop old weight values
drop ER28078_05 

//  			#5	reshape long
note:	`tag' 	#5	reshape long

***		Drop unnecesary variables (from merging)
drop ER30001 ER30002
drop ER33802 ER33803   
drop ID07 ER33902 ER33903     
drop ID09 ER34002 ER34003     
drop ID11 ER34102 ER34103 
drop ID13 ER34202 ER34203 
drop ID15 ER34302 ER34303     
drop ID17 ER34502 ER34503    
drop ID19 ER34702 ER34703    

*		Creat unique identifier

sort ID05
gen ID = _n
drop ID05

*		Save wide dataset

save "HCE-PSID_wide", replace


*		Reshape long
reshape long 					///
income  cincome  cincome10k		///
hex	  	hexk	chexk 			///
state							///
lnhex	chex					///
hiex	lnhiex	hiexk			///
burden	premium_burden						///
family	moadult mparent			///
needs	meligable insurance				///
, i(ID) j(year 05 07 09 11 13 15 17 19)

//				#3	Save and Close Log
note:	`tag'	#3	Save and Close Log 

save "HCE-PSID_merge", replace 
clear
log close
exit




















