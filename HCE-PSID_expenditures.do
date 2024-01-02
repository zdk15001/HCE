capture log close
log using HCE-PSID_expenditures, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm HCE-PSID_expenditures
local dte 2019-2-03
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//				#1	Adjust Settings and load data
note:	`tag'	#1	Adjust Settings and load data

set more off, permanently 

use "HCE-PSID_SES"

//  			#2	health care expenditures
note:	`tag' 	#2	health care expenditures
 
codebook 												///
	ER28037D3_05 ER41027D3_07 ER46971D3_09  			///
	ER52395D3_11 ER58212D3_13 ER65439_15 ER71517_17 ER77566_19, m

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


***	Create expenditures for each year 
*	note: Quarters and z-scores
*	05
gen hex05 = ER28037D3_05*CPI04

*	07
gen hex07 = ER41027D3_07*CPI06

*	09
gen hex09 = ER46971D3_09*CPI08

*	11
gen hex11 = ER52395D3_11*CPI10

*	13
gen hex13 = ER58212D3_13*CPI12

*	15
gen hex15 = ER65439_15*CPI14

*	17
gen hex17 = ER71517_17*CPI16

*	19
gen hex19 = ER77566_19*CPI18

*	Averages 
gen Ahex = 								///
	(hex05 + hex07 + hex09 + 			///
	 hex11 + hex13 + hex15 +hex17 + hex19) / 8

gen Ahexk = Ahex / 1000

*	change in dollars
gen chex05 = hex05 - Ahex
gen chex07 = hex07 - Ahex
gen chex09 = hex09 - Ahex
gen chex11 = hex11 - Ahex
gen chex13 = hex13 - Ahex
gen chex15 = hex15 - Ahex
gen chex17 = hex17 - Ahex
gen chex19 = hex19 - Ahex

*	expenditures in thousands
gen hexk05 = hex05/1000
gen hexk07 = hex07/1000
gen hexk09 = hex09/1000
gen hexk11 = hex11/1000
gen hexk13 = hex13/1000
gen hexk15 = hex15/1000
gen hexk17 = hex17/1000
gen hexk19 = hex19/1000

*	change in thousands
gen chexk05 = hexk05 - Ahexk
gen chexk07 = hexk07 - Ahexk
gen chexk09 = hexk09 - Ahexk
gen chexk11 = hexk11 - Ahexk
gen chexk13 = hexk13 - Ahexk
gen chexk15 = hexk15 - Ahexk
gen chexk17 = hexk17 - Ahexk
gen chexk19 = hexk19 - Ahexk

**	Log hex 

gen lnhex05 = ln(hex05+1)
gen lnhex07 = ln(hex07+1)
gen lnhex09 = ln(hex09+1)
gen lnhex11 = ln(hex11+1)
gen lnhex13 = ln(hex13+1)
gen lnhex15 = ln(hex15+1)
gen lnhex17 = ln(hex17+1)
gen lnhex19 = ln(hex19+1)

*	hex below 0
replace lnhex05 = 0 if hex05 < 0
replace lnhex07 = 0 if hex07 < 0
replace lnhex09 = 0 if hex09 < 0
replace lnhex11 = 0 if hex11 < 0
replace lnhex13 = 0 if hex13 < 0
replace lnhex15 = 0 if hex15 < 0
replace lnhex17 = 0 if hex17 < 0
replace lnhex19 = 0 if hex19 < 0


***	Sum each variable
sum Ahex   Ahexk
sum hex05  hex07  hex09  hex11  hex13  hex15 hex17 hex19
sum chex05 chex07 chex09 chex11 chex13 chex15 chex17 chex19

sum hexk05  hexk07  hexk09  hexk11  hexk13  hexk15 hexk17 hexk19
sum chexk05 chexk07 chexk09 chexk11 chexk13 chexk15 chexk17 chexk19

sum lnhex05 lnhex07 lnhex09 lnhex11 lnhex13 lnhex15 lnhex17 lnhex19

***	Drop unneccesary variables
drop ER28037D3_05 ER41027D3_07 ER46971D3_09 		 ///
	 ER52395D3_11 ER58212D3_13 ER65439_15 ER71517_17 ER77566_19

*	Add notes 
#delimit ;

note Ahexk: Average 2020 1k dollar hex `tag' 			;
note Ahex: Average 2020 dollar hex `tag' 			;

foreach hex in 	 
	 hex05 hex07 
	 hex09 hex11
	 hex13 hex15 hex17 hex19
{						;
note `hex': 2020 dollar Hexpenditures `tag'	;
} 						;

foreach chex in 	 
	 chex05 chex07 
	 chex09 chex11
	 chex13 chex15  chex17 chex19
{													;
note `chex': 2020 dollar hex, mean centered `tag'	;
} 													;


foreach hexk in 	 
	 hexk05 hexk07 
	 hexk09 hexk11
	 hexk13 hexk15 hexk17 hexk19
{						;
note `hex': 2020 dollar Hexpenditures `tag'	;
} 						;

foreach chexk in 	 
	 chexk05 chexk07
	 chexk09 chexk11
	 chexk13 chexk15 chexk17 chexk19
{														;
note `chexk': 2020 1k dollar hex, mean centered `tag'	;
} 														;


foreach lnhex in 	 
	 lnhex05 lnhex07 
	 lnhex09 lnhex11
	 lnhex13 lnhex15 lnhex17 lnhex19
{															;
note `lnhex': 2020 dollar hex, logged `tag'	;
} 															;

													
#delimit cr

//  			#3	Insurance premiums
note:	`tag' 	#3	Insurance premiums
 
codebook									///
ER28037D7_05 ER41027D7_07 ER46971D7_09 		///
ER52395D7_11 ER58212D7_13 ER65443_15 ER71521_17 ER77573_19, m
	
	
***	Create expenditures for each year 

gen hiex05 = ER28037D7_05*CPI04
gen hiex07 = ER41027D7_07*CPI06
gen hiex09 = ER46971D7_09*CPI08
gen hiex11 = ER52395D7_11*CPI10
gen hiex13 = ER58212D7_13*CPI12
gen hiex15 = ER65443_15*CPI14
gen hiex17 = ER71521_17*CPI16 
gen hiex19 = ER77573_19*CPI18 


*	expenditures in thousands
gen hiexk05 = hiex05/1000
gen hiexk07 = hiex07/1000
gen hiexk09 = hiex09/1000
gen hiexk11 = hiex11/1000
gen hiexk13 = hiex13/1000
gen hiexk15 = hiex15/1000
gen hiexk17 = hiex17/1000
gen hiexk19 = hiex19/1000

**	Log hex (hex below 0 to 0)
gen lnhiex05 = ln(hiex05+1)
gen lnhiex07 = ln(hiex07+1)
gen lnhiex09 = ln(hiex09+1)
gen lnhiex11 = ln(hiex11+1)
gen lnhiex13 = ln(hiex13+1)
gen lnhiex15 = ln(hiex15+1)
gen lnhiex17 = ln(hiex17+1)
gen lnhiex19 = ln(hiex19+1)

* hex below 0
replace lnhiex05 = 0 if hiex05 < 0
replace lnhiex07 = 0 if hiex07 < 0
replace lnhiex09 = 0 if hiex09 < 0
replace lnhiex11 = 0 if hiex11 < 0
replace lnhiex13 = 0 if hiex13 < 0
replace lnhiex15 = 0 if hiex15 < 0
replace lnhiex17 = 0 if hiex17 < 0
replace lnhiex19 = 0 if hiex19 < 0

***	Sum each variable
sum hiex05 hiex07 hiex09 hiex11 hiex13 hiex15 hiex17 hiex19

sum hiexk05 hiexk07 hiexk09 hiexk11 hiexk13 hiexk15 hiexk17 hiexk19
 
sum lnhiex05 lnhiex07 lnhiex09 lnhiex11 lnhiex13 lnhiex15 lnhiex17 lnhiex19

***	Drop unneccesary variables
drop										///
ER28037D7_05 ER41027D7_07 ER46971D7_09 		///
ER52395D7_11 ER58212D7_13 ER65443_15  ER71521_17 ER77573_19
	
	
*	Drop inflation measures
drop CPI04 CPI05 CPI06 CPI07 CPI08 CPI09 		///
CPI10 CPI11 CPI12 CPI13 CPI14 CPI15 CPI16 CPI17 CPI18 CPI19

*	Add notes 
#delimit ;

foreach hiex in 	 
	 hiex05 hiex07 
	 hiex09 hiex11
	 hiex13 hiex15  hiex17 hiex19
{						;
note `hiex': 2020 dollar Health insurance expenditures `tag'	;
} 						;


foreach hiexk in 	 
	 hiexk05 hiexk07 
	 hiexk09 hiexk11
	 hiexk13 hiexk15 hiexk17 hiexk19
{						;
note `hiex': 2020 dollar Health insurance expenditures `tag'	;
} 						;


foreach lnhiex in 	 
	 lnhiex05 lnhiex07 
	 lnhiex09 lnhiex11
	 lnhiex13 lnhiex15 lnhiex17 lnhiex19
{															;
note `lnhiex': 2020 dollar hiex, logged `tag'				;
} 															;

															
#delimit cr

//				#5	expenses as proportion of income
note:	`tag'	#5	expenses as proportion of income

gen burden05 = hex05 / income05 
gen burden07 = hex07 / income07
gen burden09 = hex09 / income09
gen burden11 = hex11 / income11
gen burden13 = hex13 / income13
gen burden15 = hex15 / income15
gen burden17 = hex17 / income17
gen burden19 = hex19 / income19

* cap at 1
replace burden05 = 1 if burden05 > 1
replace burden07 = 1 if burden07 > 1
replace burden09 = 1 if burden09 > 1
replace burden11 = 1 if burden11 > 1
replace burden13 = 1 if burden13 > 1
replace burden15 = 1 if burden15 > 1
replace burden17 = 1 if burden17 > 1
replace burden19 = 1 if burden19 > 1



*	indeterminate when income == 0
codebook burden05 burden07 burden09 burden11 burden13 burden15 burden17 burden19, m


* insurance prop
gen premium_burden05 = hiex05 / income05 
gen premium_burden07 = hiex07 / income07
gen premium_burden09 = hiex09 / income09
gen premium_burden11 = hiex11 / income11
gen premium_burden13 = hiex13 / income13
gen premium_burden15 = hiex15 / income15
gen premium_burden17 = hiex17 / income17
gen premium_burden19 = hiex19 / income19

* cap at 1
replace premium_burden05 = 1 if premium_burden05 > 1
replace premium_burden07 = 1 if premium_burden07 > 1
replace premium_burden09 = 1 if premium_burden09 > 1
replace premium_burden11 = 1 if premium_burden11 > 1
replace premium_burden13 = 1 if burden13 > 1
replace premium_burden15 = 1 if burden15 > 1
replace premium_burden17 = 1 if burden17 > 1
replace premium_burden19 = 1 if burden19 > 1

*	indeterminate when income == 0
codebook 	premium_burden05 premium_burden07 premium_burden09 ///
			premium_burden11 premium_burden13 premium_burden15 ///
			premium_burden17 premium_burden19, m


//				#6	any insurance
note:	`tag'	#6	any insurance

codebook 	ER27237  ER40409  ER46382  ///
			ER51743 ER57484  ER64606  ER70682 ER76690 , m

			
* make dummy and drop missing
gen insurance05 = .
gen insurance07 = .
gen insurance09 = .
gen insurance11 = .
gen insurance13 = .
gen insurance15 = .
gen insurance17 = .
gen insurance19 = .

replace insurance05 = 1 if ER27237 == 1
replace insurance07 = 1 if ER40409 == 1
replace insurance09 = 1 if ER46382 == 1
replace insurance11 = 1 if ER51743 == 1
replace insurance13 = 1 if ER57484 == 1
replace insurance15 = 1 if ER64606 == 1
replace insurance17 = 1 if ER70682 == 1
replace insurance19 = 1 if ER76690 == 1


replace insurance05 = 0 if ER27237 == 5
replace insurance07 = 0 if ER40409 == 5
replace insurance09 = 0 if ER46382 == 5
replace insurance11 = 0 if ER51743 == 5
replace insurance13 = 0 if ER57484 == 5
replace insurance15 = 0 if ER64606 == 5
replace insurance17 = 0 if ER70682 == 5
replace insurance19 = 0 if ER76690 == 5


drop if insurance05 == .
drop if insurance07 == .
drop if insurance09 == .
drop if insurance11 == .
drop if insurance13 == .
drop if insurance15 == .
drop if insurance17 == .
drop if insurance19 == .

codebook 	insurance05 insurance07 insurance09 ///
			insurance11 insurance13 insurance15 ///
			insurance17 insurance19, m


//				#7	Save and Close Log
note:	`tag'	#7	Save and Close Log 

save 	"HCE-PSID_expenditures", replace 

log close
exit
