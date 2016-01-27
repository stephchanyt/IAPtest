clear

* Edit the insheet statement to reference the data file on your computer.;

import delimited using "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/2_Raw Data/ATUS/1_Well-Being Data/wbact_1013 (cum 2010,2012,2013 data)/wbact_1013.dat"
*102796 observations
cd "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/2_Raw Data/ATUS"
	sort tucaseid
	save wellbeingall, replace
clear 

import delimited using "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/2_Raw Data/ATUS/2_Activity Summary Data/atussum_0314 (cum 2003 to 2014 data)/atussum_0314.dat"
*455 variables, 159937 observations
	sort tucaseid
	save summaryall, replace

merge 1:m tucaseid using "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/2_Raw Data/ATUS/wellbeingall"
*all well-being tucaseid are matched with activity summary 
*30814 were matched in both 
*there are 1007 people just in activity summary but not well-being. Presumably they did not answer those questions in the survey. 
*drop these so all the information are consistent
drop if _merge == 1
	
label variable tuactivity_n "Activity line number"
label variable wufnactwt "Well-being module original activity weight"
label variable wufnactwtc "Well-being module adjusted annual activity weight"
label variable wuhapord "Order of WUHAPPY"
label variable wuhappy "From 0 to 6, where a 0 means you were not happy at all and a 6 means you were very happy, how happy did you feel during this time?"
label variable wuinteract "Were you interacting with anyone during this time, including over the phone?"
label variable wumeaning "From 0 to 6, how meaningful did you consider what you were doing?"
label variable wupain "From 0 to 6, where a 0 means you did not feel any pain at all and a 6 means you were in severe pain, how much pain did you feel during this time if any?"
label variable wupnord "Order of WUPAIN"
label variable wusad "From 0 to 6, where a 0 means you were not sad at all and a 6 means you were very sad, how sad did you feel during this time?"
label variable wusadord "Order of WUSAD"
label variable wustress "From 0 to 6, where a 0 means you were not stressed at all and a 6 means you were very stressed, how stressed did you feel during this time?"
label variable wustrord "Order of WUSTRESS"
label variable wutired "From 0 to 6, where a 0 means you were not tired at all and a 6 means you were very tired, how tired did you feel during this time?"
label variable wutrdord "Order of WUTIRED"

label variable tucaseid   "ATUS Case ID (14-digit identifier)"
label variable gtmetsta   "Metropolitan status (2000 definitions)"
label variable peeduca    "Edited: what is the highest level of school you have completed or the highest degree you have received?"
label variable pehspnon   "Edited: are you Spanish, Hispanic, or Latino?"
label variable ptdtrace   "Race (topcoded)"
label variable teage      "Edited: age"
*
label variable tehruslt   "Edited: total hours usually worked per week (sum of TEHRUSL1 and TEHRUSL2)"
label variable telfs      "Edited: labor force status"
label variable tuyear    "Year the survey was conducted (2010, 2012, 2013)"
*
label variable temjot     "Edited: in the last seven days did you have more than one job?"
label variable teschenr   "Edited: are you enrolled in high school, college, or university?"
label variable teschlvl   "Edited: would that be high school, college, or university?"
label variable tesex      "Edited: sex"
*
label variable tespempnot "Edited: employment status of spouse or unmarried partner"
label variable trchildnum "Number of household children < 18"
*
label variable trdpftpt   "Full time or part time employment status of respondent"
label variable trernwa    "Weekly earnings (2 implied decimals)"
label variable trspftpt   "Full time or part time employment status of spouse or unmarried partner"
label variable trsppres   "Presence of the respondent's spouse or unmarried partner in the household"
label variable tryhhchild "Age of youngest household child < 18"
label variable tudiaryday "Day of the week of diary day (day of the week about which the respondent was interviewed)"
label variable trholiday  "Flag to indicate if diary day was a holiday"

label variable t010101 "Sleeping (minutes)"
	
*Save
		save "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/2_Raw Data/ATUS/3_merged/merged file", replace


		
