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

//				#1 	Load Data and Settings	
use HCE-PSID_source
note:	`tag'	#1	Load Data and Settings
 
//  			#3	state
note:	`tag' 	#3	state

foreach state in					///
ER66003_17	ER72003_19					///
ER60003_15 ER53003_13 ER47303_11 	///
ER42003_09 ER36003_07 ER25003_05 {
codebook `state'
drop if `state' == 99
drop if `state' == 0
}

gen state05 = ER25003_05
gen state07 = ER36003_07
gen state09 = ER42003_09
gen state11 = ER47303_11
gen state13 = ER53003_13
gen state15 = ER60003_15
gen state17 = ER66003_17
gen state19 = ER72003_19

drop ER66003_17 ER72003_19					///
	ER60003_15 ER53003_13 ER47303_11 	///
	ER42003_09 ER36003_07 ER25003_05

#delimit ;
label define state_name 
1	"Alabama"				
2	"Arizona"		
3	"Arkansas"
4 	"California"
5	"Colorodo"
6	"Connecticut"
7	"Delaware"
8	"District of Columbia"
9	"Florida"
10	"Georgia"
11	"Idaho"
12	"Illinois"
13	"Indiana"
14	"Iowa"
15	"Kansas"
16	"Kentucky"
17	"Louisiana"
18	"Maine"
19	"Maryland"
20	"Massachusetts"
21	"Michigan"
22	"Minnesota"
23	"Mississippi"
24	"Missouri"
25	"Montana"
26	"Nebraska"
27	"Nevada"
28	"New Hampshire"
29	"New Jersey"
30	"New Mexico"
31	"New York"
32	"North Carolina"
33	"North Dakota"
34	"Ohio"
35	"Oklahoma"
36	"Oregon"
37	"Pennsylvania"
38	"Rhode Island"
39	"South Carolina"
40	"South Dakota"
41	"Tennessee"
42	"Texas"
43	"Utah"
44	"Vermont"
45	"Virginia"
46	"Washington"
47	"West Virginia"
48	"Wisconsin"
49	"Wyoming"
50	"Alaska"
51	"Hawaii"
;
#delimit cr

foreach state_ in 					///
state05 state07 state09 			///
state11 state13 state15	state17 state19 {
label values `state_' state_name
codebook `state_'
note				`state_': state of residence `tag'
note				`state_': foreign and missing dropped `tag'
}
	

//  			#4	Family Formation
note:	`tag' 	#4	Family Formation
*		Note: 	1) couple w/kids 		2) couple w/out kids 
*				3) single, with kids	4) single w/out kids
*		check and drop missing; no missing children
codebook ER28049_05 ER25020_05, m
codebook ER41039_07 ER36020_07, m
codebook ER46983_09 ER42020_09, m
codebook ER52407_11 ER47320_11, m
codebook ER58225_13 ER53020_13, m
codebook ER65461_15 ER60021_15, m
codebook ER71540_17 ER66021_17, m
codebook ER77601_19 ER72021_19, m

foreach marital in 							///
	ER28049_05 ER41039_07 ER46983_09 		///
	ER52407_11 ER58225_13 ER65461_15		///
	ER71540_17 ER77601_19 ER72021_19	{
drop if `marital' == 8
drop if `marital' == 9					
										}

****	05
tab1 ER28049_05 ER25020_05, m

gen family05 = .
replace family05 = 1 if ER28049_05 == 1 & ER25020_05 >  0
replace family05 = 2 if ER28049_05 == 1 & ER25020_05 == 0
replace family05 = 3 if ER28049_05 >  1 & ER25020_05 >  0
replace family05 = 4 if ER28049_05 >  1 & ER25020_05 == 0
tab family05, m

****	07
tab1 ER41039_07 ER36020_07, m

gen family07 = .
replace family07 = 1 if ER41039_07 == 1 & ER36020_07 >  0
replace family07 = 2 if ER41039_07 == 1 & ER36020_07 == 0
replace family07 = 3 if ER41039_07 >  1 & ER36020_07 >  0
replace family07 = 4 if ER41039_07 >  1 & ER36020_07 == 0
tab family07, m

****	09
tab1 ER46983_09 ER42020_09, m

gen family09 = .
replace family09 = 1 if ER46983_09 == 1 & ER42020_09 >  0
replace family09 = 2 if ER46983_09 == 1 & ER42020_09 == 0
replace family09 = 3 if ER46983_09 >  1 & ER42020_09 >  0
replace family09 = 4 if ER46983_09 >  1 & ER42020_09 == 0
tab family09, m

****	11
tab1 ER52407_11 ER47320_11, m

gen family11 = .
replace family11 = 1 if ER52407_11 == 1 & ER47320_11 >  0
replace family11 = 2 if ER52407_11 == 1 & ER47320_11 == 0
replace family11 = 3 if ER52407_11 >  1 & ER47320_11 >  0
replace family11 = 4 if ER52407_11 >  1 & ER47320_11 == 0
tab family11, m

****	13
tab1 ER58225_13 ER53020_13, m

gen family13 = .
replace family13 = 1 if ER58225_13 == 1 & ER53020_13 >  0
replace family13 = 2 if ER58225_13 == 1 & ER53020_13 == 0
replace family13 = 3 if ER58225_13 >  1 & ER53020_13 >  0
replace family13 = 4 if ER58225_13 >  1 & ER53020_13 == 0
tab family13, m

****	15
tab1 ER65461_15 ER60021_15, m

gen family15 = .
replace family15 = 1 if ER65461_15 == 1 & ER60021_15 >  0
replace family15 = 2 if ER65461_15 == 1 & ER60021_15 == 0
replace family15 = 3 if ER65461_15 >  1 & ER60021_15 >  0
replace family15 = 4 if ER65461_15 >  1 & ER60021_15 == 0
tab family15, m

****	17
tab1 ER71540_17 ER66021_17, m

gen family17 = .
replace family17 = 1 if ER71540_17 == 1 & ER66021_17 >  0
replace family17 = 2 if ER71540_17 == 1 & ER66021_17 == 0
replace family17 = 3 if ER71540_17 >  1 & ER66021_17 >  0
replace family17 = 4 if ER71540_17 >  1 & ER66021_17 == 0
tab family17, m

****	19
tab1  ER77601_19 ER72021_19, m

gen family19 = .
replace family19 = 1 if ER77601_19 == 1 & ER72021_19 >  0
replace family19 = 2 if ER77601_19 == 1 & ER72021_19 == 0
replace family19 = 3 if ER77601_19 >  1 & ER72021_19 >  0
replace family19 = 4 if ER77601_19 >  1 & ER72021_19 == 0
tab family19, m


*****	summarize all
tab1 family05 family07 family09 family11 family13 family15 family17, m

label define family_types ///
1	"couple w/	  kids"	  ///
2	"couple w/out kids"   ///
3	"single w/    kids"   ///
4	"single w/out kids"

foreach family in								///
		family05 family07 family09 				///
		family11 family13 family15	family17 family19 {		
label	variable	`family' "family formation:couple w/,w/o; single w/,w/o"
label 	values		`family' family_types
note				`family':time varying; Missing dropped `tag'
}


*	drop unnecesary
drop ER28049_05 ER25020_05
drop ER41039_07 ER36020_07
drop ER46983_09 ER42020_09
drop ER52407_11 ER47320_11
drop ER58225_13 ER53020_13
drop ER65461_15 ER60021_15
drop ER71540_17 ER66021_17
drop ER77601_19 ER72021_19

//				#6	Age
note:	`tag'	#6	Age 

codebook ER25017_05 ER36017_07 ER42017_09 ER47317_11 ER53017_13 ER60017_15 ER66017_17 ER72017_19, m
codebook ER25019_05 ER36019_07 ER42019_09 ER47319_11 ER53019_13 ER60019_15 ER66019_17 ER72019_19, m

*	drop missing and medicare eligable
gen medicare = 0
#delimit ; 
foreach age in 
ER25017_05 ER36017_07 ER42017_09 ER47317_11 ER53017_13 ER60017_15 ER66017_17 ER72017_19
ER25019_05 ER36019_07 ER42019_09 ER47319_11 ER53019_13 ER60019_15 ER66019_17 ER72019_19	{ ;
drop if `age' == 999	;
replace medicare = 1 if `age' >= 65	;};
#delimit cr	

tab 			medicare, m
label define	medicare 1 "yes" 0 "no"
label values 	medicare medicare
label variable 	medicare "is R or spouse medicare eligable at any point"
note 		 	medicare: missing on age dropped; medicare at 65 or older; `tag'
codebook	 	medicare, m



*	drop unnecesary
drop ER25017_05 ER36017_07 ER42017_09 ER47317_11 ER53017_13 ER60017_15 ER66017_17 ER72017_19
drop ER25019_05 ER36019_07 ER42019_09 ER47319_11 ER53019_13 ER60019_15


//				#7	Save and Close Log
note:	`tag'	#7	Save and Close Log 

save 	"HCE-PSID_demo", replace 
clear
log close
exit
