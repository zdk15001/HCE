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

//		#1	Adjust Settings
note:	`tag'	#1	Adjust Settings

set more off, permanently 

//				#2	Infix Individuals (05, 07, 09, 11, 13, 15, 17, 19) 
note:	`tag'	#2	Infix Individuals (05, 07, 09, 11, 13, 15, 17, 19) 

#delimit ;

infix 
ER30001        2 - 5          
ER30002        6 - 8
ER32006     2064 - 2064

ER33801     3193 - 3197       
ER33802     3198 - 3199       
ER33803     3200 - 3201
	  
ER33901     3492 - 3496       
ER33902     3497 - 3498 
ER33903     3499 - 3500

ER34001     3770 - 3774       
ER34002     3775 - 3776 
ER34003     3777 - 3778
	  
ER34101     3992 - 3996 
ER34102     3997 - 3998       
ER34103     3999 - 4000

ER34201     4229 - 4233       
ER34202     4234 - 4235       
ER34203     4236 - 4237

ER34301     4495 - 4499       
ER34302     4500 - 4501 
ER34303     4502 - 4503

ER34501     4869 - 4873      
ER34502     4874 - 4875 
ER34503     4876 - 4877

ER34701     5249 - 5253 
ER34702     5254 - 5255       
ER34703     5256 - 5257
	  
using IND19.txt, clear 
;
label variable ER30001    "1968 INTERVIEW NUMBER"                    ;
label variable ER30002    "PERSON NUMBER                         68" ;
label variable ER32006    "WHETHER SAMPLE OR NONSAMPLE" 			 ;  

label variable ER33801    "2005 INTERVIEW NUMBER" 					 ;                           
label variable ER33802    "SEQUENCE NUMBER                       05" ;        
label variable ER33803    "RELATION TO HEAD                      05" ;  

label variable ER33901    "2007 INTERVIEW NUMBER"                    ;
label variable ER33902    "SEQUENCE NUMBER                       07" ;
label variable ER33903    "RELATION TO HEAD                      07" ;

label variable ER34001    "2009 INTERVIEW NUMBER"                    ;
label variable ER34002    "SEQUENCE NUMBER                       09" ;
label variable ER34003    "RELATION TO HEAD                      09" ;

label variable ER34101	  "2011 INTERVIEW NUMBER" 					 ;                           
label variable ER34102    "SEQUENCE NUMBER                       11" ;        
label variable ER34103    "RELATION TO HEAD                      11" ; 

label variable ER34201    "2013 INTERVIEW NUMBER" 					 ;                           
label variable ER34202    "SEQUENCE NUMBER                       13" ;        
label variable ER34203    "RELATION TO HEAD                      13" ;

label variable ER34301    "2015 INTERVIEW NUMBER" 					 ;                           
label variable ER34302    "SEQUENCE NUMBER                       15" ;        
label variable ER34303    "RELATION TO HEAD                      15" ;

label variable  ER34501   "2017 INTERVIEW NUMBER" 					 ;                           
label variable  ER34502   "SEQUENCE NUMBER                       17" ;   
label variable  ER34503   "RELATION TO REFERENCE PERSON          17" ;   

label variable  ER34701      "2019 INTERVIEW NUMBER" ;                           
label variable  ER34702      "SEQUENCE NUMBER                       19" ;        
label variable  ER34703      "RELATION TO REFERENCE PERSON          19" ;  

rename ER33801 ID05 ;
rename ER33901 ID07 ;
rename ER34001 ID09 ;
rename ER34101 ID11 ;
rename ER34201 ID13 ;
rename ER34301 ID15 ;
rename ER34501 ID17 ;
rename ER34701 ID19 ;

*	Add notes ;
foreach ind0519 in 	 
	 ER30001 ER30002 
	 ER32006
ID05 ER33802 ER33803 
ID07 ER33902 ER33903 
ID09 ER34002 ER34003 
ID11 ER34102 ER34103 
ID13 ER34202 ER34203
ID15 ER34302 ER34303
ID17 ER34502 ER34503
ID19 ER34702 ER34703
{						;
note `ind0519': `tag'	;
} 						;

*	Select individual heads and spouses who were ;
*	PRESENT and PARTICIPATING across ANY waves;

keep if (
	(inrange (ER33802,1,20) & inrange (ER33803,10,22)) |
	(inrange (ER33902,1,20) & inrange (ER33903,10,22)) |
	(inrange (ER34002,1,20) & inrange (ER34003,10,22)) |
	(inrange (ER34102,1,20) & inrange (ER34103,10,22)) |
	(inrange (ER34202,1,20) & inrange (ER34203,10,22)) |
	(inrange (ER34302,1,20) & inrange (ER34303,10,22)) |
	(inrange (ER34502,1,20) & inrange (ER34503,10,22)) |
	(inrange (ER34702,1,20) & inrange (ER34703,10,22)) 
	) ;
		
*	Drop non-followable individuals* 	;
*       Irrelevent to weighted descriptive statistics; 
	
tab ER32006, m						;
drop if ER32006 == 0 				;
	
*	Randomly drop family duplicates ;
*	NOTE: while the N for family ID is consistant, the final sample ;
*		used for analysis may vary due to split-offs with different ;
*		missingness (e.g. families with 2 followable heads) ;
* 		Issue not resolved by seed set ;

replace ID19 = . if ID19 == 0 ;
replace ID17 = . if ID17 == 0 ;
replace ID15 = . if ID15 == 0 ;
replace ID13 = . if ID13 == 0 ;
replace ID11 = . if ID11 == 0 ;
replace ID09 = . if ID09 == 0 ;
replace ID07 = . if ID07 == 0 ;
replace ID05 = . if ID05 == 0 ;


set seed 339487731										;
bys ID19  : gen rnd19 = runiform()  					;
bys ID19 (rnd19) : keep if _n == 1  & 	ID19 != .		;

set seed 339487731										;
bys ID17  : gen rnd17 = runiform()  					;
bys ID17 (rnd17) : keep if _n == 1  & 	ID17 != .		;

set seed 339487731										;
bys ID15  : gen rnd15 = runiform()  					;
bys ID15 (rnd15) : keep if _n == 1  & 	ID15 != .		;

set seed 339487731										;
bys ID13  : gen rnd13 = runiform()  					;
bys ID13 (rnd13) : keep if _n == 1  & 	ID13 != .		;

set seed 339487731										;
bys ID11  : gen rnd11 = runiform()  					;
bys ID11 (rnd11) : keep if _n == 1  & 	ID11 != .		;

set seed 339487731										;
bys ID09  : gen rnd09 = runiform()  					;
bys ID09 (rnd09) : keep if _n == 1 	& 	ID09 != .		;

set seed 339487731										;
bys ID07  : gen rnd07 = runiform()  					;
bys ID07 (rnd07) : keep if _n == 1 	& 	ID07 != .		;

set seed 339487731										;
bys ID05  : gen rnd05 = runiform()  					;
bys ID05 (rnd05) : keep if _n == 1 	& 	ID05 != .		;


*	Sort by 1968 interview and person number;
sort ER30001 ER30002 						;

***	Save IND0517 ;
save "IND0519", replace 					;

clear  										;

//				#3	Infix 05				;
note:	`tag'	#3	Infix 05 				;

infix      
ER25002         2 - 6
ER28078_05      6717 - 6723

ER28049_05      6654 - 6654
ER25020_05        48 - 49
ER25017_05     	  41 - 43
ER25019_05     	  45 - 47

ER25003_05         7 - 8 

ER28037_05      6225 - 6231
ER28039_05      6627 - 6631

ER28037D3_05    6522 - 6531
ER28037D7_05    6562 - 6571
ER27237_05      4346 - 4346

using FAM2005ER.txt, clear ;

*****	Label fam05 ;
*		Label identifiers ;                                
label variable  ER25002      "2005 FAMILY INTERVIEW (ID) NUMBER" ; 
label variable  ER28078_05   "2005 CORE/IMMIGRANT FAM WEIGHT NUMBER 1" ; 

***		Label x-variables;
*		Label Demographic factors;

label variable  ER28049_05      "MARITAL STATUS-GENERATED" ; 
label variable  ER25020_05      "# CHILDREN IN FU" ;   
label variable  ER25017_05      "AGE OF HEAD" ;     
label variable  ER25019_05      "AGE OF WIFE" ;    

label variable  ER25003_05      "PSID STATE OF RESIDENCE CODE" ;     

*		Label SES factors;
label variable  ER28037_05      "TOTAL FAMILY INCOME-2004" ;  
label variable  ER28039_05      "CENSUS NEEDS STANDARD-2004" ; 
*wealth imported above;     

*		expenditures;
label variable  ER28037D3_05    "HEALTH CARE EXPENDITURE 2005" ;  
label variable  ER28037D7_05    "HEALTH INSURANCE EXPENDITURE 2005" ;        

label variable  ER27237_05      "H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS" ;         


*	Rename ID05 ;
rename ER25002 ID05 ;

***	Sort and save;
sort ID05 ;
save "FAM05", replace ;

***	Merge fam05 with ind0517 by id05 ;
merge 1:1 ID05 using "IND0519", keep(using matched) ;
drop _merge ;
save "FAM_IND", replace ;

clear; 

//				#4	Infix 07;
note:	`tag'	#4	Infix 07; 

#delimit ; 
infix          
ER36002       2 - 6

ER41039_07    8634 - 8634
ER36020_07        48 - 49
ER36017_07        41 - 43
ER36019_07        45 - 47

ER36003_07         7 - 8

ER41027_07    8205 - 8211 
ER41029_07      8607 - 8611

ER41027D3_07  8502 - 8511
ER41027D7_07    8542 - 8551
ER40409_07      6727 - 6727

using FAM2007ER.txt, clear 
;

***	Identifiers;                         
label variable ER36002    	 "2007 FAMILY INTERVIEW (ID) NUMBER"        ;


***	X-Variables;
**	Demographic;
label variable ER41039_07    "MARITAL STATUS-GENERATED"                 ;
label variable ER36020_07      "# CHILDREN IN FU" ;    
label variable ER36017_07      "AGE OF HEAD" ;     
label variable ER36019_07      "AGE OF WIFE" ;

label variable ER36003_07    	"PSID STATE OF RESIDENCE CODE" 			;            

**	SES;
label variable ER41027_07    "TOTAL FAMILY INCOME-2006"                 ;
label variable ER41029_07      "CENSUS NEEDS STANDARD-2006" ;     

**	expenditures;
label variable  ER41027D3_07    "HEALTH CARE EXPENDITURE 2007" 			;
label variable  ER41027D7_07    "HEALTH INSURANCE EXPENDITURE 2007" ;     
label variable  ER40409_07      "H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS" ;         

*	Rename ID;
rename ER36002 ID07 ;

***	Sort and save;

sort ID07 ;
save "FAM07", replace ;

***	Merge fam07 with ind0517 by id07 ;
merge 1:1 ID07 using "FAM_IND", keep(using matched) ;
drop _merge ;

save "FAM_IND", replace ;

clear ;

//				#5	Infix 09;
note:	`tag'	#5	Infix 09; 

#delimit;
infix     
ER42002       2 - 6

ER46983_09    8544 - 8544
ER42020_09        48 - 49
ER42017_09        41 - 43
ER42019_09        45 - 47

ER42003_09         7 - 8

ER46935_09    7999 - 8005
ER46972_09      8520 - 8524 

ER46971D3_09    8420 - 8429 
ER46971D7_09    8460 - 8469
ER46382_09      6680 - 6680

using FAM2009ER.txt, clear
;

*****	Label fam09;
***		Identifiers;
label variable ER42002    "2009 FAMILY INTERVIEW (ID) NUMBER"        ;

***		X-Variables;
**		Demographic;
label variable ER46983_09    "MARITAL STATUS-GENERATED"                 ;
label variable ER42020_09      "# CHILDREN IN FU" ;     
label variable ER42017_09      "AGE OF HEAD" ;   
label variable ER42019_09      "AGE OF WIFE" ;

label variable ER42003_09      "PSID STATE OF RESIDENCE CODE" ;           

**		SES;
label variable ER46935_09    "TOTAL FAMILY INCOME-2008"                 ;
label variable ER46972_09      "CENSUS NEEDS STANDARD-2008" ;       

**		expenditures;
label variable  ER46971D3_09    "HEALTH CARE EXPENDITURE 2009" 			; 
label variable  ER46971D7_09    "HEALTH INSURANCE EXPENDITURE 2009" ;     
label variable  ER46382_09      "H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS" ;         

  
rename ER42002 ID09;
sort ID09 ;
save "FAM09", replace ;

***	Merge fam09 with ind0517 by id09 ;
merge 1:1 ID09 using "FAM_IND", keep(using matched) ;
drop _merge ;
save "FAM_IND", replace ;


clear; 

//				#6	Infix 11;
note:	`tag'	#6	Infix 11; 

#delimit ; 

infix     
ER47302         2 - 6
        
ER52407_11      8660 - 8660 
ER47320_11        48 - 49
ER47317_11        41 - 43 
ER47319_11        45 - 47 

ER47303_11         7 - 8

ER52343_11      8077 - 8083
ER52396_11      8636 - 8640 

ER52395D3_11    8536 - 8545
ER52395D7_11    8576 - 8585
ER51743_11      6701 - 6701

using FAM2011ER.txt, clear
;

*****	Labels fam11;
***	Identifiers;                            
label variable  ER47302      "2011 FAMILY INTERVIEW (ID) NUMBER" 		; 

***	X-Variables;
**	Demographic;                                                              
label variable  ER52407_11      "MARITAL STATUS-GENERATED" ;   
label variable  ER47320_11      "# CHILDREN IN FU" ;    
label variable  ER47317_11      "AGE OF HEAD" ;       
label variable  ER47319_11      "AGE OF WIFE" ;

label variable  ER47303_11      "PSID STATE OF RESIDENCE CODE" ;     

**	SES;
label variable  ER52343_11      "TOTAL FAMILY INCOME-2010" ;
label variable  ER52396_11      "CENSUS NEEDS STANDARD-2010" ;  
 
**	Expenditures;
label variable  ER52395D3_11    "HEALTH CARE EXPENDITURE 2011" ;     
label variable  ER52395D7_11    "HEALTH INSURANCE EXPENDITURE 2011" ;             
label variable  ER51743_11      "H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS" ;         

rename ER47302 ID11;
sort ID11 ;
save "FAM11", replace ;

***	Merge fam11 with ind0517 by id11 ;
merge 1:1 ID11 using "FAM_IND", keep(using matched) ;
drop _merge ;

save "FAM_IND", replace ;

clear ;

//				#7	Infix 13;
note:	`tag'	#7	Infix 13; 

infix
ER53002         2 - 6

ER58225_13      8803 - 8803
ER53020_13        48 - 49
ER53017_13        41 - 43
ER53019_13        45 - 47

ER53003_13         7 - 8 

ER58152_13      8190 - 8196
ER58213_13      8779 - 8783 

ER58212D3_13    8679 - 8688
ER58212D7_13    8719 - 8728
ER57484_13      6767 - 6767

using FAM2013ER.txt, clear
;


*****	Label fam 13;
***		Identifiers;                                
label variable  ER53002      "2013 FAMILY INTERVIEW (ID) NUMBER"	 	;  

***		X-Variables;
**		Demographic;                          
label variable  ER58225_13      "MARITAL STATUS-GENERATED" ;     
label variable  ER53020_13      "# CHILDREN IN FU" ;   
label variable  ER53017_13      "AGE OF HEAD" ; 
label variable  ER53019_13      "AGE OF WIFE" ;    

label variable  ER53003_13      "PSID STATE OF RESIDENCE CODE" ;     

**		SES;
label variable  ER58152_13      "TOTAL FAMILY INCOME-2012" ;
label variable  ER58213_13      "CENSUS NEEDS STANDARD-2012" ;         
                          
**		Expenditures;
label variable  ER58212D3_13    "HEALTH CARE EXPENDITURE 2013" ; 
label variable  ER58212D7_13    "HEALTH INSURANCE EXPENDITURE 2013" ;     
label variable  ER57484_13      "H61D2 WTR ANY FU MEMBER HLTH INSURANCE" ;          

rename ER53002 ID13;
sort ID13 ;
save "FAM13", replace ;

***	Merge fam13 with ind0517 by id13 ;
merge 1:1 ID13 using "FAM_IND", keep(using matched) ;
drop _merge ;

save "FAM_IND", replace ;

clear ;

//				#8	Infix 15;
note:	`tag'	#8	Infix 15; 

infix      
ER60002         2 - 6
        
ER65461_15       9179 - 9179
ER60021_15        49 - 50
ER60017_15        41 - 43
ER60019_15        45 - 47

ER60003_15         7 - 8

ER65349_15       8567 - 8573 
ER65449_15      9156 - 9160

ER65439_15      9056 - 9065 
ER65443_15      9096 - 9105
ER64606_15      6948 - 6948
using FAM2015ER.txt, clear
;

*****	Label fam 15;
***		Identifiers;                                  
label variable  ER60002      	"2015 FAMILY INTERVIEW (ID) NUMBER" ;  

***		X-Variables;
**		Demographic;                                                                                          
label variable  ER65461_15      "MARITAL STATUS-GENERATED" 	;   
label variable  ER60021_15      "# CHILDREN IN FU" ;      
label variable  ER60017_15      "AGE OF HEAD" ;  
label variable  ER60019_15      "AGE OF SPOUSE" ;   

label variable  ER60003_15      "PSID STATE OF RESIDENCE CODE" ;

**		SES;
label variable  ER65349_15      "TOTAL  FAMILY INCOME-2014" 	;  
label variable  ER65449_15      "CENSUS NEEDS STANDARD-2014" ;    

**		Expenditures;
label variable  ER65439_15      "HEALTH CARE EXPENDITURE 2015" ; 
label variable  ER65443_15      "HEALTH INSURANCE EXPENDITURE 2015" ;    
label variable  ER64606_15      "H61D2 WTR ANY FU MEMBER HLTH INSURANCE" ;          

rename ER60002 ID15;
sort ID15 ;
save "FAM15", replace ;

***	Merge fam15 with ind0517 by id15 ;
merge 1:1 ID15 using "FAM_IND", keep(using matched) ;
drop _merge ;
save "FAM_IND", replace ;
clear					;

//				#9	Infix 17;
note:	`tag'	#9	Infix 17; 

infix 
ER66002	                2 - 6 

ER71540_17           9392 - 9392
ER66021_17             49 - 50
ER66017_17       		41 - 43
ER66019_17       		45 - 47
ER66003_17        	    7 - 8

long ER71426_17      8760 - 8766
long ER71528_17      9369 - 9373

long ER71517_17      9259 - 9268 
long ER71521_17      9299 - 9308
ER70682_17     7084 - 7084


using FAM2017ER.txt, clear
;

*****	Label fam 17;
***		Identifiers;                                  
label variable  ER66002       "2017 FAMILY INTERVIEW (ID) NUMBER" ;   

***		X-Variables;
**		Demographic;                                                                                          
label variable  ER71540_17       "MARITAL STATUS-GENERATED" ;       
label variable  ER66021_17       "# CHILDREN IN FU" ;   
label variable  ER66017_17      "AGE OF REFERENCE PERSON" ;                         
label variable  ER66019_17      "AGE OF SPOUSE" ;                                   
label variable  ER66003_17       "PSID STATE OF RESIDENCE CODE" ;   

**		SES;
label variable  ER71426_17       "TOTAL FAMILY INCOME-2016" ;        
label variable  ER71528_17       "CENSUS NEEDS STANDARD-2016" ;    

**		Expenditures;
label variable  ER71517_17       "HEALTH CARE EXPENDITURE 2017" ;     
label variable  ER71521_17       "HEALTH INSURANCE EXPENDITURE 2017" ;       
label variable  ER70682_17      "H61D2 WTR ANY FU MEMBER HLTH INSURANCE" ;          

rename ER66002 ID17;
sort ID17 ;
save "FAM17", replace ;

***	Merge fam17 with ind0517 by id17 ;
merge 1:1 ID17 using "FAM_IND", keep(using matched) ;
drop _merge ;

save "FAM_IND", replace ;

clear ;




//				#10	Infix 19;
note:	`tag'	#10	Infix 19; 

infix 
ER72002        2 - 6

ER77601_19     9573 - 9573
ER72021_19       49 - 50
ER72017_19       41 - 43
ER72019_19       45 - 47
ER72003_19        7 - 8

long ER77448_19     8876 - 8882 
long ER77589_19     9550 - 9554

long ER77566_19     9410 - 9419
long ER77573_19     9453 - 9462
ER76690_19     7108 - 7108

using FAM2019ER.txt, clear
;

*****	Label fam 17;
***		Identifiers;                                  
label variable  ER72002      "2019 FAMILY INTERVIEW (ID) NUMBER" ;               

***		X-Variables;
**		Demographic;                                                                                          
label variable  ER77601_19      "MARITAL STATUS-GENERATED" ;                        
label variable  ER72021_19      "# CHILDREN IN FU" ;              
label variable  ER72017_19      "AGE OF REFERENCE PERSON" ;                         
label variable  ER72019_19      "AGE OF SPOUSE" ;                                   
                  
label variable  ER72003_19      "PSID STATE OF RESIDENCE CODE" ;                    

**		SES;
label variable  ER77448_19      "TOTAL FAMILY INCOME-2018" ;                        
label variable  ER77589_19      "CENSUS NEEDS STANDARD-2018" ;                      

**		Expenditures;
label variable  ER77566_19      "HEALTH CARE EXPENDITURE 2019" ;                    
label variable  ER77573_19      "HEALTH INSURANCE EXPENDITURE 2019" ;               
label variable  ER76690      "H61D2 WTR ANY FU MEMBER HLTH INSURANCE" ;          

rename ER72002 ID19;
sort ID19 ;
save "FAM19", replace ;

***	Merge fam17 with ind0517 by id17 ;
merge 1:1 ID19 using "FAM_IND", keep(using matched) ;
drop _merge ;





#delimit cr

//				#10	Save and Close Log
note:	`tag'	#10	Save and Close Log 

save 	"HCE-PSID_source", replace 
clear
log close
exit
















