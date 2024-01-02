
capture log close
log using HCE-master, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Master Do-File
//	Before Running: Download txt, do, and dta files to working directory
local pgm HCE-master
local dte 2023-5-26
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  #1	Adjust Settings
*	NOTE: These do files will temporarily CHANGE your stata settings and
*			permanently INSTALL packages to your working directory!!!
do HCE-profile
do HCE-setup

//  #2	Data Cleaning 
do HCE-PSID_source
do HCE-PSID_demo
do HCE-PSID_SES
do HCE-PSID_expenditures
do HCE-PSID_medicaid
do HCE-PSID_merge
do HCE-PSID_market

//	#3	Full data set analysis
do HCE-desc
do HCE-market
do HCE-

//	#4	Close Log and Exit
capture log close
exit

