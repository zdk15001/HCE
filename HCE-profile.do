capture log close
log using HCE-profile, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Set Profile
//		From Scott Long, "Using Stata in Soc 650 / Stat 503 / 2017-08-24"
//  	File name: cda17-profile-templateV3.do

local pgm HCE-profile
local dte 2019-2-02
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//	#1	Set Profile

version 15.0 // If using Stata 14, change to 14.2
clear all
set linesize 80
matrix drop _all
set more off, permanently
set logtype text, permanently
capture set matsize 11000
set scrollbufsize 500000
set scheme s1manual


log close
exit
