*branch 2


*Author: Stephanie Chan 
*Date: January 14 2016
*********************************************************************************
*Purpose: Analysis file for Day Reconstruction Method data (full dataset) 
*********************************************************************************

clear
use "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/2_Raw Data/Kahneman et al (2004)/DRMwrktall.dta"
cd "/Users/stephaniechan/Dropbox (MIT)/9. Sleep and happiness/3_Analysis Files/DRM graphs"
ssc install binscatter
set more off

*************
/*Overview:
*************

	This dataset was provided by David Schkade, one of the researchers on Kahenman et al. (2004)
	As compared with another dataset that was previously provided to us (DRM2focus.dta), 
	this one includes multiple episodes/lines PER RESPONDENT, whereas the previous dataset only
	included aggregate information with one line per respondent.

	Variables compared to the previous dataset are the same. Key variables include:
		1. how many hours did you sleep last month? (slphours)
		2. how many hours did you sleep last night? (slplast) 
		3. how would you rate your overall sleep quality? (slpqual)
		4. others perception of me (see_`i')
		5. wellbeing/emotions **these were labeled differently than previous dataset**
			feel_a "impatient for it to end"
			feel_b "happy"
			feel_c "frustrated/annoyed"
			feel_d "depressed/blue"
			feel_e "competent/capable"
			feel_f "hassled/pushed around"
			feel_g "warm/friendly"
			feel_h "angry/hostile"
			feel_i "worried/anxious"
			feel_j "enjoying myself"
			feel_k "criticized/put down"
			feel_l "tired"
	

	New variables there were not in the truncated dataset but would be important to explore: 
		6. What were they doing? (what_`x' where x=b/q)
		7. Who were they with? (who_`x' where x=a/h)

	For each of the episodes, there is a rating of wellbeing/emotions associated
	
	*/ 


*************
*Analysis
*************

	*Since there are multiple episodes per respondent.

		*There are 909 unique respondents.
			codebook id 
		
		*The number of episodes per respondent ranges from 3 to 30. 
			tab id, sort
			
		*relabel "other people" to "other activities" for clarity
			label var what_q "other activities"
		
		**SC: how to find the mode of frequency, etc? (how many activities did most people do?)
	
	
	*Explore wellbeing/emotions variables
	
		foreach var of varlist feel_* {
			tab `var', m
			}
		
	*Figuring out what variables mean 
	
		*posaff is the average of happy/warm/enjoying myself - TRUE
			gen test = (feel_b + feel_g + feel_j)/3
			compare test posaff
			
			drop test
		
		*negaff is the average of frustrated, depressed, hassled, angry, worried, criticized - TRUE
			gen test = (feel_c + feel_d + feel_f + feel_h + feel_i + feel_k)/6
			compare test negaff
			
			drop test
		
	
	*binscatters with sleep hours
	
		*positive affects
			*positive affects were identified by Kahneman et al (2004) as 
			*happy, warm, and enjoying myself
		
		foreach var of varlist feel_b feel_g feel_j {
			binscatter `var' slphours, line(connect) ytitle(`: variable label `var'') xtitle("hours slept on avg last month") ///
			title("`: variable label `var'' & hours slept last month")
			graph export `var'-slphours.eps, replace
		}
		
		
		foreach var of varlist feel_b feel_g feel_j {
				binscatter `var' slplast, controls(id) ytitle(`: variable label `var'') xtitle("hours slept last night") ///
				title("`: variable label `var'' & hours slept last night")
				graph export `var'-slplast.eps, replace
			}	


			foreach var of varlist feel_b feel_g feel_j {
				binscatter `var' slpqual, controls(id) ytitle(`: variable label `var'') xtitle("sleep quality last month") ///
				title("`: variable label `var'' & sleep quality last month")
				graph export `var'-slpqual.eps, replace
			}	
		
			*controlling for variable id
		foreach var of varlist feel_b feel_g feel_j {
			binscatter `var' slphours, controls(id) line(connect) ytitle(`: variable label `var'') xtitle("hours slept on avg last month") ///
			title("`: variable label `var'' & hours slept last month (with controls(id))")
			graph export `var'-slphours2.eps, replace
		}
		
		/*binscatter feel_b began, absorb (id) ytitle("feeling happy") xtitle("hours slept on avg last month") ///
			title("feeling happy & hours slept last month (with absorb id)") 
			graph export atest2.eps, replace
		
		binscatter feel_b began, control (id) ytitle("feeling happy") xtitle("hours slept on avg last month") ///
			title("feeling happy & hours slept last month (with control id)")
			graph export atest.eps, replace
			
		
		binscatter feel_b began, absorb(id) ytitle("feeling happy") xtitle("hours slept on avg last month") ///
			title("feeling happy & hours slept last month (with control id)")
			graph export atest.eps, replace	*/
		
		*negative affects 
			*negative affects were identified by Kahneman et al (2004) as 
			*frustrated, depressed, hassled, angry, worried, criticized
			
			foreach var of varlist feel_c feel_d feel_f feel_h feel_i feel_k {
				binscatter `var' slphours, controls(id) ytitle(`: variable label `var'') xtitle("hours slept on avg last month") ///
				title("`: variable label `var'' & hours slept last month")
				graph export `var'-slphours.eps, replace
			}	
			
			foreach var of varlist feel_c feel_d feel_f feel_h feel_i feel_k {
				binscatter `var' slplast, controls(id) ytitle(`: variable label `var'') xtitle("hours slept last night") ///
				title("`: variable label `var'' & hours slept last night")
				graph export `var'-slplast.eps, replace
			}	


			foreach var of varlist feel_c feel_d feel_f feel_h feel_i feel_k {
				binscatter `var' slpqual, controls(id) ytitle(`: variable label `var'') xtitle("sleep quality last month") ///
				title("`: variable label `var'' & sleep quality last month")
				graph export `var'-slpqual.eps, replace
			}	


		*controlling for fixed effects
	
			*areg posaff slphour age married, absorb(id) 
				
			est clear
			xtset id 
		
			eststo: xtreg posaff slphour slplast slpqual, re	
			eststo: xtreg posaff slphour slplast slpqual age lghsinc married haskids imp_rel, re
			eststo: xtreg posaff slphour slplast age lghsinc married haskids imp_rel, re			
			eststo: xtreg feel_b slphour slplast slpqual age lghsinc married haskids imp_rel, re
			esttab using posaff.tex, b se stat(r2 N) ///
			nonumbers mtitles ("net positive" "net positive" "net positive" "happy only") ///
			title(Regression with positive affects) ///
			addnote("includes individual fixed effects (id)")replace
	
	
		*sleep and number of activities 
		
			binscatter adjusted slphours, controls(id)
			**binscatter adjusted slphours, absorb(id)

			*the hours slept does not seem to impact the number of activities conducted per day
		
		
		*sleep hours LAST MONTH and happiness by choice of activity 
			
			*positive affects 
			foreach var of varlist what_* {	
		
				foreach x of varlist feel_b feel_g feel_j {
					binscatter `x' slphours if `var' == 1, controls(id) ///
					ytitle(`: variable label `x'') xtitle("hours slept last month") ///
					title("`: variable label `x'' when `: variable label `var''", size (large))
				
					graph export `x'-`var'sleepmonth.eps, replace
				}
			
			}
			
			*negative affects
			
			foreach var of varlist what_* {	
		
				foreach x of varlist feel_c feel_d feel_f feel_h feel_i feel_k {
					binscatter `x' slphours if `var' == 1, controls(id) ///
					ytitle(`: variable label `x'') xtitle("hours slept last month") ///
					title("`: variable label `x'' when `: variable label `var''", size (large))
				
					graph export `x'-`var'sleepmonth.eps, replace
				}
			
			}
			
			
			
		*sleep hours YESTERDAY and happiness by choice of activity 
			
			
			*positive affects 
			
			foreach var of varlist what_* {	
		
				foreach x of varlist feel_b feel_g feel_j {
					binscatter `x' slplast if `var' == 1, controls(id) ///
					ytitle(`: variable label `x'') xtitle("hours slept last night") ///
					title("`: variable label `x'' when `: variable label `var''", size (large))
				
					graph export `x'-`var'sleeplast.eps, replace
				}
			
			}	
		
			*negative affects 
		
			
			foreach var of varlist what_* {	
		
				foreach x of varlist feel_c feel_d feel_f feel_h feel_i feel_k {
					binscatter `x' slplast if `var' == 1, controls(id) ///
					ytitle(`: variable label `x'') xtitle("hours slept last night") ///
					title("`: variable label `x'' when `: variable label `var''", size (large))
				
					graph export `x'-`var'sleeplast.eps, replace
				}
			
			}	
			
				*NAPS (what_k)
					*last night's sleep duration is a much better predictor of how positive you 
					*feel about naps, compared with last month's sleep
				
					
					
				est clear
				xtset id 
				
				foreach var of varlist posaff negaff feel_b feel_g feel_j {
				eststo: xtreg `var' slphour slplast slpqual if what_k ==1 , re	
					}
				esttab using naprating.tex, b se stat(r2 N) ///
				mtitles ("posaff" "negaff" "happy" "warm" "enjoy") ///
				title(Regression for naps) ///
				addnote("includes individual fixed effects (id)") replace
				
				
				est clear
				xtset id 
				
				foreach var of varlist feel_c feel_d feel_f feel_h feel_i feel_k {
				*eststo: xtreg `var' slphour if what_k == 1, re	
				*eststo: xtreg `var' slplast if what_k == 1, re	
				eststo: xtreg `var' slphour slplast slpqual if what_k ==1 , re	
					}
				esttab using naprating2.tex, b se stat(r2 N) ///
				mtitles ("frustrated" "depressed" "hassled" "angry" "worried" "criticized") ///
				title(Regression for naps - negative affects) ///
				addnote("includes individual fixed effects (id)") replace
				
				
			
		*sleep quality and happiness by choice of activity 
			
			
			foreach var of varlist what_* {	
		
				foreach x of varlist feel_* {
					binscatter `x' slpqual if `var' == 1, controls(id) ///
					ytitle(`: variable label `x'') xtitle("sleep quality") ///
					title("`: variable label `x'' when `: variable label `var''", size (large))
				
					graph export `x'-`var'sleepquality.eps, replace
				}
			
			}	
			

			
		*Hypothesis: Energy-intensive activities are more affected by sleep 
	
			
			*energy intensive = "exercise" "shopping" "housework" "preparing food" (1)
			*non-energy intensive = "eating" "praying/worshipping" "watching TV" "relaxing" (2)
			
		
			gen energy = .
				replace energy = 1 if what_p == 1
				replace energy = 1 if what_e == 1
				replace energy = 1 if what_c == 1
				replace energy = 1 if what_d == 1
				
				replace energy = 2 if what_g == 1
				replace energy = 2 if what_h == 1
				replace energy = 2 if what_j == 1
				replace energy = 2 if what_m == 1
			
				binscatter posaff slphours, by(energy) control(id) ///
				ytitle("positive affect") xtitle("hours slept last night") ///
				title("Energy-intensive activities are affected by sleep") ///
				legend(lab(1 "energy intensive") lab(2 "non-energy intensive")) ///
				
				graph export energyintensive.eps, replace

			
				
				binscatter posaff slphours, by(energy) control(id) ///
				ytitle("positive affect") xtitle("hours slept last night") ///
				title("Energy-intensive activities are affected by sleep") ///
				legend(lab(1 "energy intensive") lab(2 "non-energy intensive")) ///
				
				graph export energyintensive.eps, replace
				
			
			*testing difference in co-efficients
			
			set mat 1000		
			est clear
			
			reg posaff slphours c.id if energy == 1
			est store reg1
	
			reg posaff slphours c.id if energy == 2
			est store reg2
			
			suest reg1 reg2
			
			test[reg1_mean]slphours = [reg2_mean]slphours 
			
			
			foreach var of varlist what_* { 
				reg posaff slphours c.id if `var' == 1
				est store `var'
		}
			
			suest what_*
			
			test[what_q_mean]slphours = [what_p_mean]slphours
			
			*for each activity separately
				
				local i = 1 
				gen dummy = . 
				foreach var of varlist what_* {
					replace dummy = `i' if `var' == 1
				local i = `i' + 1
				}
	
	
			binscatter posaff slplast if (dummy <= 10) , by(dummy) control(id)
			binscatter posaff slphours if (dummy >10) , by(dummy) control(id)
				
			*happiness from doing chores are most affected by sleep	
			binscatter posaff slplast if (dummy == 4 | dummy == 5), by(dummy) control(id) ///
			ytitle("positive affect") xtitle("hours slept yesterday") ///
				title("household chores are most affected by sleep") ///
				legend(lab(1 "preparing food") lab(2 "doing housework")) ///
				
				graph export doingchores.eps, replace

				
		*sleep and duration of activities 
		
				*Calculate minutes spent per activity
						gen spent = (end - began)*60
											
					gen act = ""	
					foreach letter in a b c d e f g h i j k l m n o p q  {
						replace act = act + "`letter'" if what_`letter' == 1
						
				}
					foreach letter in a b c d e f g h i j k l m n o p q  {	
						bysort id: egen totaltime`letter' = total(spent) if regexm(act, "`letter'")
				
				}		

						
					*logic checks
						foreach var of varlist what_* {
							sum totaltime* if `var' == 1
						}
						
						
				*Graph time spent on activity given hours slept 
					foreach x of varlist what_* {
						binscatter totaltime slphours if `x' == 1, controls(id) ///
						ytitle("time spent on activity") xtitle("hours slept last month") ///
					title("time spent on `: variable label `x''", size (large))
				
					graph export timespent`x'.eps, replace
				}
						
						
