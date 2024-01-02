
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

//				#1	Adjust Settings and load data
note:	`tag'	#1	Adjust Settings and load data

set more off, permanently 

use "HCE-PSID_demo"

//  			#2	income (2000 dollars)
note:	`tag' 	#2	income (2000 dollars)

*		note: income is measured year before (05, measured in 04)
*			inflation therefore uses CPI from previous year

codebook ER28037_05 ER41027_07 ER46935_09 					///
			ER52343_11 ER58152_13 ER65349_15 ER71426_17 ER77448_19, m


*	CPI for inflation
gen CPI04 = (258.8/188.9)
gen CPI05 = (258.8/195.3)
gen CPI06 = (258.8/201.6)
gen CPI07 = (258.8/207.342)
gen CPI08 = (258.8/215.303)
gen CPI09 = (258.8/214.537)
gen CPI10 = (258.8/218.056)
gen CPI11 = (258.8/224.939)
gen CPI12 = (258.8/229.594)
gen CPI13 = (258.8/232.957)
gen CPI14 = (258.8/236.736)
gen CPI15 = (258.8/237.017)
gen CPI16 = (258.8/240.008)
gen CPI17 = (258.8/245.120)
gen CPI18 = (258.8/251.100)
gen CPI19 = (258.8/255.700)


***	Create income for each year 
*	note: Quarters and z-scores
*	05
gen income05 = ER28037_05*CPI04

*	07
gen income07 = ER41027_07*CPI06

*	09
gen income09 = ER46935_09*CPI08


*	11
gen income11 = ER52343_11*CPI10


*	13
gen income13 = ER58152_13*CPI12

*	15
gen income15 = ER65349_15*CPI14

*	17
gen income17 = ER71426_17*CPI16


*	19
gen income19 = ER77448_19*CPI18


**	center income 
gen Aincome = (income05 + income07 + income09 + ///
income11 + income13 + income15 + income17 + income19) / 8

*	05
gen cincome05 = income05 - Aincome
gen cincome07 = income07 - Aincome
gen cincome09 = income09 - Aincome
gen cincome11 = income11 - Aincome
gen cincome13 = income13 - Aincome
gen cincome15 = income15 - Aincome
gen cincome17 = income17 - Aincome
gen cincome19 = income19 - Aincome

*	Thousands
gen Aincome10k = Aincome / 10000

gen cincome10k05 = (income05 / 10000) - Aincome10k
gen cincome10k07 = (income07 / 10000) - Aincome10k
gen cincome10k09 = (income09 / 10000) - Aincome10k
gen cincome10k11 = (income11 / 10000) - Aincome10k
gen cincome10k13 = (income13 / 10000) - Aincome10k
gen cincome10k15 = (income15 / 10000) - Aincome10k
gen cincome10k17 = (income17 / 10000) - Aincome10k
gen cincome10k19 = (income19 / 10000) - Aincome10k

***	Sum each variable
sum income05 income07 income09 income11 income13 income15 income17 income19
sum Aincome Aincome10k
sum cincome05 cincome07 cincome09 cincome11 cincome13 cincome15 cincome17 cincome19
sum cincome10k05 cincome10k07 cincome10k09 	///
	cincome10k11 cincome10k13 cincome10k15 	///
	cincome10k17 cincome10k19

**	Save source income for later

*	Drop inflation measures
drop CPI04 CPI05 CPI06 CPI07 CPI08 CPI09 ///
CPI10 CPI11 CPI12 CPI13 CPI14 CPI15 CPI16 CPI17 CPI18 CPI19


*	Add notes 
#delimit ;
foreach income in 	 
	 income05 income07 
	 income09 income11
	 income13 income15
	 income17 income19
{						;
note `income': 2020 dollar income `tag'	;
} 						;


note Aincome: Average 2000 dollar income `tag' ;

foreach cincome in 	 
	 cincome05 cincome07 
	 cincome09 cincome11
	 cincome13 cincome15
	 cincome17
{						;
note `cincome': 2020 dollar income, mean centered `tag'	;
} 						;

note Aincome10k: Average 2020 dollar income, ten thousand `tag' ;

foreach cincome10k in 	 
	 cincome10k05 cincome10k07 
	 cincome10k09 cincome10k11
	 cincome10k13 cincome10k15
	 cincome10k17
{						;
note `cincome10k': mean centered 2000 dollar income, ten thousand `tag'	;
} 						;

#delimit cr


//  			#3	census needs and categories
note:	`tag' 	#3	census needs and categories

*needs
codebook 									///
	ER28037_05 ER41027_07 ER46935_09 		///
	ER52343_11 ER58152_13 ER65349_15 ER71426_17 ER77448_19, m
	
codebook 									///
	ER28039_05 ER41029_07 ER46972_09 		///
	ER52396_11 ER58213_13 ER65449_15 ER71528_17 ER77589_19, m


gen needs05 = ER28037_05 / ER28039_05 
gen needs07 = ER41027_07 / ER41029_07 
gen needs09 = ER46935_09 / ER46972_09 
gen needs11 = ER52343_11 / ER52396_11 
gen needs13 = ER58152_13 / ER58213_13 
gen needs15 = ER65349_15 / ER65449_15 
gen needs17 = ER71426_17 / ER71528_17 
gen needs19 = ER77448_19 / ER77589_19 


//				#4	Save and Close Log
note:	`tag'	#4	Save and Close Log 

save 	"HCE-PSID_SES", replace 
clear
log close
exit
