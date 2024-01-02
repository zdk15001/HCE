These syntax were used to create results for paper titled, "The Effects of State-Managed Marketplaces on Out-of-Pocket Health Care Costs: Before and After the Affordable Care Act."

Citation: Kline, Zachary. 2023. "The Effects of State-Managed Marketplaces on Out-of-Pocket Health Care Costs: Before and After the Affordable Care Act." Research in Social Stratification and Mobility. ONLINE FIRST.

[https://academic.oup.com/sf/article-abstract/99/3/947/5858251](https://www.google.com/url?q=https%3A%2F%2Fdoi.org%2F10.1016%2Fj.rssm.2023.100881&sa=D)

Acknowledgement: The collection of data used in this study was partly supported by the National Institutes of Health under grant number R01 HD069609 and R01 AG040213, and the National Science Foundation under award numbers SES 1157698 and 1623684.

To create data set, download csv files for individual and family data directly from PSID data center.

A summary of do files are as follows:

GRR-master : Master do file used to create data set and run all analyses. See for notes

These do files create the Stata environment used at the time this replication package was created

GRR-profile : Sets prefered visual settings for Stata, credit Dr. Scott Long

GRR-setup : Downloads and loads neccesary STATA packages using dated version of stata, credit Dr. Scott Long

These do files create the data set used in the analyses

GRR-PSID_source : Imports and merges data from CSV files downloaded from PSID data center.

GRR-PSID_demo: Cleans demographic factors

GRR-PSID_SES : Cleans socioconomic factors

GRR-PSID_expenditures : Calculates family-level Medicaid eligibility using family data and state-level data from the Kaiser Family Foundation 

GRR-PSID_merge : Mergers family data with KFF 

GRR-PSID_market: Imports marketplace information (state-level) from KFF


At this stage, the final data set used for analyses is created

GRR-desc + GRR-market: Creates results presented in the published paper
