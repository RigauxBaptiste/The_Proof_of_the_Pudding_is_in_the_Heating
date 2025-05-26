********************************************************************************
*               The Proof of the Pudding is in the Heating:                    *
*    a Field Experiment on Household Engagement with Heat Pump Flexibility     *
*                                May 2025                    	         	   *
*            Baptiste Rigaux°, Sam Hamels° and Marten Ovaere°                  *
*         ° Department of Economics, Ghent University (Belgium)                *
*                  Energy Economics, doi: 10.1016/j.eneco.2025.108565          *
********************************************************************************

// Contact: baptiste.rigaux@ugent.be

* Stata version 18.0

* Stata replication file for the paper figures and tables, incl. appendices

clear
program drop _all
graph set window fontface default
frames reset
set more off

* Directory:
cd "C:\Users\" // Change this with your directory

* This .do file runs each of the results for the paper. To see the results of just one part, select it in the list below and run it.
* The code is structured around Tables and Figures but also presents the commands used to interpret the results in the text (e.g. t-tests).
* In addition to outputting the figures, most of these programs also output relevant quantitites  (discussed in the text alongside the figures) directly in the console. 

program define run_all 

// Section 2:
Table_1_characteristics // Table 1 - output: Table_1_top.tex, Table_1_middle.tex, Table_1_bottom.tex + console outputs

// Section 4:
data_preparation 				// Data preparation (prerequisite for other Tables/Figures) ; Output: "data_prepared.dta"
Table_2_duration_reason_stops   // Console outputs for Table 2  
Fig_1_hist_duration 			// "Fig_1.pdf"
Table_3_reg_duration 			// Console outputs for Table 3 
ATT_temperature_eq_7 			// Console output: ATT indoor temperature reduction during interventions
ATT_power_eq_8 					// Console output: ATT powder reduction during interventions
Fig_2_pow_temp_profiles 		// "Fig_2_left.pdf" and "Fig_2_right.pdf" 
Fig_3_hist_kWh_reduction 		// "Fig_3.pdf" + console outputs
Fig_4_rebound_post_inter 		// "Fig_4_left.pdf" and "Fig_4_right.pdf" + console outputs
Fig_5_A15_pow_cons_during_event // "Fig_5_left.pdf", "Fig_5_right.pdf" and "Fig_A15.pdf"
Fig_6_event_temp 				// "Fig_6.pdf", "Fig_A16_top_left.pdf", "Fig_A16_top_right.pdf", "Fig_A16_bottom_left.pdf", "Fig_A16_bottom_right.pdf", "Fig_A17_top_left.pdf", "Fig_A17_top_right.pdf", "Fig_A17_bottom_left.pdf", "Fig_A17_bottom_right.pdf"
Fig_7_both_panels 			    // "Fig_7_left.pdf" and "Fig_7_right.pdf" ; using the dataset outputted by Python code (already incl. in the archive for convenience) + console outputs
Fig_8_both_panels 			   // "Fig_8_right_legend_non_edited.gph", "Fig_8_right_legend_non_edited.pdf", "Fig_8_left_legend_non_edited.gph", "Fig_8_left_legend_non_edited.pdf", "Fig_A18.pdf" + console outputs
overrules_temperatures          // Statements in the text of section 4.3.1 about indoor temperature at overrule and comparison with presurvey stated preferences
F9_hist_temp_drop              // "Fig_9.pdf" + console outputs
postexperiment_survey          // Console outputs for Sect. 4.3.3

// Appendices: 
App_A1_Table_A4
App_A2_Table_A5
App_A3_Fig_A10
App_A4_Fig_A11
App_A5_Fig_A12
App_A6_Fig_A13
App_A7_Fig_A14
App_C_Fig_C19
App_D_Table_D6
App_F_Fig_F20
App_F_Table_F8
App_G_Table_G9
App_H_Table_H10 
end

// run_all // uncomment this line to run the whole program 

********************************************************************************
********************************************************************************
**                                                                            **
**                   SECTION 2: Experimental setting and data                 **
**              														      **
********************************************************************************
********************************************************************************

********************************************************************************
* Table 1: Participants' characteristics									   *
********************************************************************************
capture program drop Table_1_characteristics
program define Table_1_characteristics
// This programs returns as an output three .tex files for each panel of Table 1:
// Table_1_top.tex, Table_1_middle.tex, Table_1_bottom.tex
// As well as the few coefficients of variation mentioned in the text 

use presurvey_data, clear

* Upper panel: Household characteristics 

	    // Latex code for Table 1: upper panel "Household characteristics"

    capture file close latex_table

    *

    capture drop respondent_flag_budget 
    capture drop respondent_flag_working 
    capture drop respondent_flag_tertiary 
    capture drop budget_above_5000
    capture drop avg_hh_size 
    capture drop num_resp 
    capture drop avg_kids_l6yo 
    capture drop num_resp_kids_l6yo 
    capture drop share_budget_above_5000 
    capture drop num_resp_budget 
    capture drop share_working_fulltime 
    capture drop num_resp_working 
    capture drop share_tertiary_degree 
    capture drop num_resp_tertiary
    capture drop working_fulltime
    capture drop tertiary_degree

    *

    quietly{

    sum total_number_hh
    scalar avg_hh_size = round(r(mean), 0.01)

    sum respondent_flag
    scalar num_resp = round(r(sum), 0.01)

	sum number_kids_l6yo if respondent_flag_kids
	scalar avg_kids_l6yo = round(r(mean), 0.01)

    sum respondent_flag_kids
    scalar num_resp_kids_l6yo = round(r(sum), 0.01)

    gen budget_above_5000 = (Q642 == "5000â‚¬ - 5999â‚¬") | (Q642 == "> 6000â‚¬")
    sum budget_above_5000 if !missing(Q642)
    scalar share_budget_above_5000 = round(100 * r(mean), 0.01)  // percentage

    gen respondent_flag_budget = !missing(Q642)
    sum respondent_flag_budget
    scalar num_resp_budget = round(r(sum), 0.01)

    gen working_fulltime = (Q6231 == "Ik werk fulltime") | (Q6232 == "Werkt fulltime")
    sum working_fulltime if !missing(Q6231) | !missing(Q6232)
    scalar share_working_fulltime = round(100 * r(mean), 0.01)  // percentage

    gen respondent_flag_working = !missing(Q6231) | !missing(Q6232)
    sum respondent_flag_working
    scalar num_resp_working = round(r(sum), 0.01)

    gen tertiary_degree = ((Q643 == "Bachelordiploma" | Q643 == "Doctoraat" | Q643 == "Masterdiploma") & !missing(Q643)) | ((Q644 == "Bachelordiploma" | Q644 == "Doctoraat" | Q644 == "Masterdiploma") & !missing(Q644))
    sum tertiary_degree if !missing(Q643) | !missing(Q644)
    scalar share_tertiary_degree = round(100 * r(mean), 0.01)  // percentage

    gen respondent_flag_tertiary = !missing(Q643) | !missing(Q644)
    sum respondent_flag_tertiary
    scalar num_resp_tertiary = round(r(sum), 0.01)

    *

    local avg_hh_size = avg_hh_size
    local num_resp = num_resp
    local avg_kids_l6yo = avg_kids_l6yo
    local num_resp_kids_l6yo = num_resp_kids_l6yo
    local share_budget_above_5000 = share_budget_above_5000
    local num_resp_budget = num_resp_budget
    local share_working_fulltime = share_working_fulltime
    local num_resp_working = num_resp_working
    local share_tertiary_degree = share_tertiary_degree
    local num_resp_tertiary = num_resp_tertiary

    }
    
    *

    file open latex_table using "Table_1_top.tex", write text replace

    *

    file write latex_table "\begin{table}[h!]" _n
    file write latex_table "\centering" _n
    file write latex_table "\caption{Household characteristics}" _n
    file write latex_table "\begin{tabular}{l@{\hskip 0.5in}cc}" _n
    file write latex_table "\hline" _n
    file write latex_table "  \textit{Household characteristics} & \makecell{Total\\respondents} & \makecell{Sample\\statistics} \\" _n
    file write latex_table "\hline" _n
    file write latex_table "Mean household size (persons) & `num_resp' & `avg_hh_size' \\" _n
    file write latex_table "Mean number of children < 6 years old & `num_resp_kids_l6yo' & `avg_kids_l6yo' \\" _n
    file write latex_table "Share of respondents and/or partner employed full time & `num_resp_working' & `share_working_fulltime' \% \\" _n
    file write latex_table "Share of respondents and/or partner holding a university degree & `num_resp_tertiary' & `share_tertiary_degree' \% \\" _n
    file write latex_table "Share of households with total monthly income > € 5,000 & `num_resp_budget' & `share_budget_above_5000' \% \\" _n
    file write latex_table "\hline" _n
    file write latex_table "\end{tabular}" _n
    file write latex_table "\label{tab:household_char}" _n
    file write latex_table "\end{table}" _n
    file close latex_table

* Middle panel: Participants' housing characteristics
	
    ci means elec_consumption_yearly
	
    // Latex code for Table 1: middle panel "Participants' Housing Characteristics"

    capture file close latex_table

    * 

    capture drop rel_Q631
    capture drop ans_Q631
    capture drop ans_Q632_appt
    capture drop freq_Q631
    capture drop perc_Q631
    capture drop num_ans_Q631
    capture drop rel_Q632_rh
    capture drop ans_Q632
    capture drop freq_Q632_rh
    capture drop perc_Q632_rh
    capture drop rel_Q632_appt
    capture drop freq_Q632_appt
    capture drop perc_Q632_appt
    capture drop rel_Q635
    capture drop ans_Q635
    capture drop freq_Q635
    capture drop perc_Q635
    capture drop rel_Q636
    capture drop ans_Q636
    capture drop freq_Q636
    capture drop perc_Q636
    capture drop rel_Q637
    capture drop ans_Q637
    capture drop freq_Q637
    capture drop perc_Q637
    capture drop rel_epc
    capture drop ans_epc
    capture drop freq_epc
    capture drop perc_epc

    quietly{

    * Q631: Urban or Suburban Environment
    gen rel_Q631 = (Q631 == "Stedelijk omgeving") + (Q631 == "Voorstedelijke omgeving")
    gen ans_Q631 = !missing(Q631)
    sum rel_Q631
    scalar freq_Q631 = r(sum)
    sum ans_Q631
    scalar num_ans_Q631 = r(sum)
    scalar perc_Q631 = 100 * freq_Q631 / num_ans_Q631

    * Q632: Semi-detached House
    gen rel_Q632_rh = (Q632 == "Halfvrijstaande woning")
    gen ans_Q632 = !missing(Q632)
    sum rel_Q632_rh
    scalar freq_Q632_rh = r(sum)
    sum ans_Q632
    scalar num_ans_Q632 = r(sum)
    scalar perc_Q632_rh = 100 * freq_Q632_rh / num_ans_Q632

    * Q632: Apartment
    gen rel_Q632_appt = (Q632 == "Appartement")
    gen ans_Q632_appt = !missing(Q632)
    sum rel_Q632_appt
    scalar freq_Q632_appt = r(sum)
    scalar perc_Q632_appt = 100 * freq_Q632_appt / num_ans_Q632

    * Q635: > 150 m2
    gen rel_Q635 = (Q635 == "150 - 200 m2" | Q635 == "> 200 m2")
    gen ans_Q635 = !missing(Q635)
    sum rel_Q635
    scalar freq_Q635 = r(sum)
    sum ans_Q635
    scalar num_ans_Q635 = r(sum)
    scalar perc_Q635 = 100 * freq_Q635 / num_ans_Q635

    * Q636: Built After 2006
    gen rel_Q636 = (Q636 == "na 2006")
    gen ans_Q636 = !missing(Q636)
    sum rel_Q636
    scalar freq_Q636 = r(sum)
    sum ans_Q636
    scalar num_ans_Q636 = r(sum)
    scalar perc_Q636 = 100 * freq_Q636 / num_ans_Q636

    * Q637: Energy-Retrofitted
    gen rel_Q637 = (Q637 == "Ja")
    gen ans_Q637 = !missing(Q637)
    sum rel_Q637
    scalar freq_Q637 = r(sum)
    sum ans_Q637
    scalar num_ans_Q637 = r(sum)
    scalar perc_Q637 = 100 * freq_Q637 / num_ans_Q637

    * EPC: Rated A
    gen rel_epc = (epc == "A")
    gen ans_epc = !missing(epc)
    sum rel_epc
    scalar freq_epc = r(sum)
    sum ans_epc
    scalar num_ans_epc = r(sum)
    scalar perc_epc = 100 * freq_epc / num_ans_epc

    *

    local perc_Q631 = perc_Q631
    local num_ans_Q631 = num_ans_Q631

    local perc_Q632_rh = perc_Q632_rh
    local num_ans_Q632 = num_ans_Q632

    local perc_Q632_appt = perc_Q632_appt

    local perc_Q635 = perc_Q635
    local num_ans_Q635 = num_ans_Q635

    local perc_Q636 = perc_Q636
    local num_ans_Q636 = num_ans_Q636

    local perc_Q637 = perc_Q637
    local num_ans_Q637 = num_ans_Q637

    local perc_epc = perc_epc
    local num_ans_epc = num_ans_epc

    }

    *

    capture file close latex_table

    *

    file open latex_table using "Table_1_middle.tex", write text replace

    *

    file write latex_table "\begin{table}[h!]" _n
    file write latex_table "\centering" _n
    file write latex_table "\caption{Participants' Housing Characteristics}" _n
    file write latex_table "\begin{tabular}{l@{\hskip 0.5in}cc}" _n
    file write latex_table "\hline" _n
    file write latex_table "  \textit{Participants' housing characteristics} & \makecell{Total\\respondents} & \makecell{Sample\\statistics} \\" _n
    file write latex_table "\hline" _n
    file write latex_table "Share residing in urban or suburban environmentt & `num_ans_Q631' & `perc_Q631' \% \\" _n
    file write latex_table "Share residing in a semi-detached house & `num_ans_Q632' & `perc_Q632_rh' \% \\" _n
    file write latex_table "Share residing in an apartment & `num_ans_Q632' & `perc_Q632_appt' \% \\" _n
    file write latex_table "Share residing in a home surface > 150 m\(^2\) & `num_ans_Q635' & `perc_Q635' \% \\" _n
    file write latex_table "Share residing in a home built after 2006 & `num_ans_Q636' & `perc_Q636' \% \\" _n
    file write latex_table "Share home has been energy-retrofitted & `num_ans_Q637' & `perc_Q637' \% \\" _n
    file write latex_table "Share energy performance certificate rated A & `num_ans_epc' & `perc_epc' \% \\" _n
    file write latex_table "\hline" _n
    file write latex_table "\end{tabular}" _n
    file write latex_table "\label{tab:sum_stats}" _n
    file write latex_table "\end{table}" _n
    file close latex_table

* Bottom panel: Behavioral metrics

    // Self-assessed knowledge of energy transition related concepts

    capture drop knowledge_energytransition
    capture drop knowledge_smarthome
    capture drop knowledge_flexibility
    capture drop knowledge_DR
    capture drop knowledge_metric

    gen knowledge_energytransition = .
    replace knowledge_energytransition = 1 if Q53_1 == "Nooit van gehoord"
    replace knowledge_energytransition = 2 if Q53_1 == "Ik heb ervan gehoord, maar ik begrijp het concept niet"
    replace knowledge_energytransition = 3 if Q53_1 == "Ik weet een beetje over het concept"
    replace knowledge_energytransition = 4 if Q53_1 == "Ik weet veel over het concept"

    gen knowledge_smarthome = .
    replace knowledge_smarthome = 1 if Q53_2 == "Nooit van gehoord"
    replace knowledge_smarthome = 2 if Q53_2 == "Ik heb ervan gehoord, maar ik begrijp het concept niet"
    replace knowledge_smarthome = 3 if Q53_2 == "Ik weet een beetje over het concept"
    replace knowledge_smarthome = 4 if Q53_2 == "Ik weet veel over het concept"

    gen knowledge_flexibility = .
    replace knowledge_flexibility = 1 if Q53_3 == "Nooit van gehoord"
    replace knowledge_flexibility = 2 if Q53_3 == "Ik heb ervan gehoord, maar ik begrijp het concept niet"
    replace knowledge_flexibility = 3 if Q53_3 == "Ik weet een beetje over het concept"
    replace knowledge_flexibility = 4 if Q53_3 == "Ik weet veel over het concept"

    gen knowledge_DR = .
    replace knowledge_DR = 1 if Q53_4 == "Nooit van gehoord"
    replace knowledge_DR = 2 if Q53_4 == "Ik heb ervan gehoord, maar ik begrijp het concept niet"
    replace knowledge_DR = 3 if Q53_4 == "Ik weet een beetje over het concept"
    replace knowledge_DR = 4 if Q53_4 == "Ik weet veel over het concept"

    egen knowledge_metric = rowtotal(knowledge_energytransition knowledge_smarthome knowledge_flexibility knowledge_DR)
    replace knowledge_metric = knowledge_metric/4
	
    // Proenvironmental behavior

    capture drop proenvi_contribution
    capture drop proenvi_worry
    capture drop proenvi_ecology
    capture drop proenvi_ecoconscious
    capture drop proenvi_metric

    gen proenvi_contribution = .
    replace proenvi_contribution = 1 if Q55_1 == "Sterk mee oneens"
    replace proenvi_contribution = 2 if Q55_1 == "Oneens"
    replace proenvi_contribution = 3 if Q55_1 == "Noch mee eens, noch mee oneens"
    replace proenvi_contribution = 4 if Q55_1 == "Eens"
    replace proenvi_contribution = 5 if Q55_1 == "Sterk mee eens"

    gen proenvi_worry = .
    replace proenvi_worry = 1 if Q55_2 == "Sterk mee oneens"
    replace proenvi_worry = 2 if Q55_2 == "Oneens"
    replace proenvi_worry = 3 if Q55_2 == "Noch mee eens, noch mee oneens"
    replace proenvi_worry = 4 if Q55_2 == "Eens"
    replace proenvi_worry = 5 if Q55_2 == "Sterk mee eens"

    gen proenvi_ecology = .
    replace proenvi_ecology = 1 if Q55_3 == "Sterk mee oneens"
    replace proenvi_ecology = 2 if Q55_3 == "Oneens"
    replace proenvi_ecology = 3 if Q55_3 == "Noch mee eens, noch mee oneens"
    replace proenvi_ecology = 4 if Q55_3 == "Eens"
    replace proenvi_ecology = 5 if Q55_3 == "Sterk mee eens"

    gen proenvi_ecoconscious = .
    replace proenvi_ecoconscious = 1 if Q55_4 == "Sterk mee oneens"
    replace proenvi_ecoconscious = 2 if Q55_4 == "Oneens"
    replace proenvi_ecoconscious = 3 if Q55_4 == "Noch mee eens, noch mee oneens"
    replace proenvi_ecoconscious = 4 if Q55_4 == "Eens"
    replace proenvi_ecoconscious = 5 if Q55_4 == "Sterk mee eens"

    egen proenvi_metric = rowtotal(proenvi_contribution proenvi_worry proenvi_ecology proenvi_ecoconscious)
    replace proenvi_metric = proenvi_metric/4
	
    // Electricity conservation measures

    capture drop habit_light
    capture drop habit_naturallight
    capture drop habit_led
    capture drop habit_switchoff
    capture drop habit_pcoff
    capture drop habit_electronicdevices
    capture drop habit_fridge
    capture drop habit_temperature
    capture drop habit_bath
    capture drop habit_metric

    gen habit_light = .
    replace habit_light = 1 if Q56_1 == "Nooit"
    replace habit_light = 2 if Q56_1 == "Zelden"
    replace habit_light = 3 if Q56_1 == "Soms"
    replace habit_light = 4 if Q56_1 == "Vaak"
    replace habit_light = 5 if Q56_1 == "Altijd"

    gen habit_naturallight = .
    replace habit_naturallight = 1 if Q56_2 == "Nooit"
    replace habit_naturallight = 2 if Q56_2 == "Zelden"
    replace habit_naturallight = 3 if Q56_2 == "Soms"
    replace habit_naturallight = 4 if Q56_2 == "Vaak"
    replace habit_naturallight = 5 if Q56_2 == "Altijd"

    gen habit_led = .
    replace habit_led = 1 if Q56_3 == "Nooit"
    replace habit_led = 2 if Q56_3 == "Zelden"
    replace habit_led = 3 if Q56_3 == "Soms"
    replace habit_led = 4 if Q56_3 == "Vaak"
    replace habit_led = 5 if Q56_3 == "Altijd"

    gen habit_switchoff = .
    replace habit_switchoff = 1 if Q56_4 == "Nooit"
    replace habit_switchoff = 2 if Q56_4 == "Zelden"
    replace habit_switchoff = 3 if Q56_4 == "Soms"
    replace habit_switchoff = 4 if Q56_4 == "Vaak"
    replace habit_switchoff = 5 if Q56_4 == "Altijd"

    gen habit_pcoff = .
    replace habit_pcoff = 1 if Q56_5 == "Nooit"
    replace habit_pcoff = 2 if Q56_5 == "Zelden"
    replace habit_pcoff = 3 if Q56_5 == "Soms"
    replace habit_pcoff = 4 if Q56_5 == "Vaak"
    replace habit_pcoff = 5 if Q56_5 == "Altijd"

    gen habit_electronicdevices = .
    replace habit_electronicdevices = 1 if Q56_6 == "Nooit"
    replace habit_electronicdevices = 2 if Q56_6 == "Zelden"
    replace habit_electronicdevices = 3 if Q56_6 == "Soms"
    replace habit_electronicdevices = 4 if Q56_6 == "Vaak"
    replace habit_electronicdevices = 5 if Q56_6 == "Altijd"

    gen habit_fridge = .
    replace habit_fridge = 1 if Q56_7 == "Nooit"
    replace habit_fridge = 2 if Q56_7 == "Zelden"
    replace habit_fridge = 3 if Q56_7 == "Soms"
    replace habit_fridge = 4 if Q56_7 == "Vaak"
    replace habit_fridge = 5 if Q56_7 == "Altijd"

    gen habit_temperature = .
    replace habit_temperature = 1 if Q56_8 == "Nooit"
    replace habit_temperature = 2 if Q56_8 == "Zelden"
    replace habit_temperature = 3 if Q56_8 == "Soms"
    replace habit_temperature = 4 if Q56_8 == "Vaak"
    replace habit_temperature = 5 if Q56_8 == "Altijd"

    gen habit_bath = .
    replace habit_bath = 1 if Q56_9 == "Nooit"
    replace habit_bath = 2 if Q56_9 == "Zelden"
    replace habit_bath = 3 if Q56_9 == "Soms"
    replace habit_bath = 4 if Q56_9 == "Vaak"
    replace habit_bath = 5 if Q56_9 == "Altijd"

    egen habit_metric = rowtotal(habit_light habit_naturallight habit_led habit_switchoff habit_pcoff habit_electronicdevices habit_fridge habit_temperature habit_bath)
    replace habit_metric = habit_metric/9
	
    // Latex code for Table 1: bottom panel "Behavioral metrics"

    capture file close latex_table

    quietly{

    *

    capture drop num_resp_knowledge 
    capture drop num_resp_proenvi 
    capture drop num_resp_habit 
    capture drop avg_knowledge 
    capture drop avg_proenvi 
    capture drop avg_habit
    capture drop respondent_flag_knowledge
    capture drop respondent_flag_proenvi
    capture drop respondent_flag_habit

    summarize knowledge_metric if !missing(Q53_1)
    scalar avg_knowledge = round(r(mean), 0.01)

    summarize proenvi_metric if !missing(Q55_1)
    scalar avg_proenvi = round(r(mean), 0.01)

    summarize habit_metric if !missing(Q56_1)
    scalar avg_habit = round(r(mean), 0.01)

    *

    gen respondent_flag_knowledge = !missing(Q53_1)
    summarize respondent_flag_knowledge
    scalar num_resp_knowledge = round(r(sum), 0.01)

    gen respondent_flag_proenvi = !missing(Q55_1)
    summarize respondent_flag_proenvi
    scalar num_resp_proenvi = round(r(sum), 0.01)

    gen respondent_flag_habit = !missing(Q56_1)
    summarize respondent_flag_habit
    scalar num_resp_habit = round(r(sum), 0.01)

    *

    local avg_knowledge = avg_knowledge
    local num_resp_knowledge = num_resp_knowledge

    local avg_proenvi = avg_proenvi
    local num_resp_proenvi = num_resp_proenvi

    local avg_habit = avg_habit
    local num_resp_habit = num_resp_habit

    }

    *

    file open latex_table using "Table_1_bottom.tex", write text replace

    *

    file write latex_table "\begin{table}[h!]" _n
    file write latex_table "\centering" _n
    file write latex_table "\caption{Behavioral metrics}" _n
    file write latex_table "\begin{tabular}{l@{\hskip 0.5in}ccc}" _n
    file write latex_table "\hline" _n
    file write latex_table " \textit{Behavioral metrics} & \makecell{Total\\respondents} & \makecell{Sample\\statistics} \\" _n
    file write latex_table "\hline" _n
    file write latex_table "\addlinespace" _n
    file write latex_table "\makecell[l]{Understanding of flexibility-related concepts} & `num_resp_knowledge' & `avg_knowledge' \\" _n
    file write latex_table "\makecell[l]{Pro-environmental behavior}  & `num_resp_proenvi' & `avg_proenvi' \\" _n
    file write latex_table "\makecell[l]{Frequency of engagement in electricity-saving practices} & `num_resp_habit' & `avg_habit' \\" _n
    file write latex_table "\hline" _n
    file write latex_table "\end{tabular}" _n
    file write latex_table "\label{tab:behavioral_metrics}" _n
    file write latex_table "\end{table}" _n
    file close latex_table
		
// Code for heterogeneity analysis in the text 

qui sum total_number_hh if !missing(total_number_hh)
local total_number_hh_avg = r(mean)
local total_number_hh_sd = r(sd)

qui sum number_kids_l6yo if !missing(number_kids_l6yo)
local number_kids_l6yo_avg = r(mean)
local number_kids_l6yo_sd = r(sd)

sum knowledge_metric if respondent_flag_knowledge == 1
local CV_knowledge = `r(sd)'/`r(mean)'

qui sum habit_metric if respondent_flag_habit == 1
local CV_habit = `r(sd)'/`r(mean)'

qui sum proenvi_metric if respondent_flag_proenvi == 1
local CV_proenvi = `r(sd)'/`r(mean)'

di "SD household size = " `total_number_hh_sd'
di "CV household size = " `total_number_hh_sd'/`total_number_hh_avg'

di "SD number of kids < 6 y.o. = " `number_kids_l6yo_sd'
di "CV number of kids < 6 y.o. = " `number_kids_l6yo_sd'/`number_kids_l6yo_avg'

di "CV understanding of flexibility-related concepts = " `CV_knowledge'
di "CV pro-environmental behavior = " `CV_proenvi'
di "CV energy-saving habits = " `CV_habit'
end
	
********************************************************************************
********************************************************************************
**                                                                            **
**                             SECTION 4: Results                             **
**              														      **
********************************************************************************
********************************************************************************	

********************************************************************************
* Experiment data preparation            									   *
********************************************************************************
capture program drop code_for_preparation
program define code_for_preparation
// Code for data preparation

    args minus_hours plus_hours excl_before_mins excl_after_mins max_after_end first_phase_event

    // Convert inputs into locals
	local window_elapsed_minus_hours `minus_hours'
    local window_elapsed_plus_hours `plus_hours'
    local exclude_from_CF_before_minutes `excl_before_mins'
    local exclude_from_CF_after_minutes `excl_after_mins'
    local max_time_after_int_end `max_after_end'
    local window_first_phase_event = `first_phase_event' * 60 * 60 * 1000 // in ms


// Additional time variables 

    // Variable that bins the time of day into categories of 5 mins: from 0 to 287 (288 categories in total)
    capture drop five_min_level_int
    gen five_min_level_int = int(hourofday * 12 + minofhour / 5)
    // Variable 'window_unique_index' that starts 6h before an intervention and ends 48h after (useful for plotting and excluding some observations for the counterfactual)

            // Sort by panel and time (main order)
            sort hh_id time

            // Loop over intervention starts
            capture drop intervention_start
            gen intervention_start = (intervention_dummy == 1) & (intervention_dummy[_n-1] == 0)

            capture drop time_diff_from_start
            capture drop time_diff_before_start
            capture drop temp_index
            capture drop window_unique_index

            gen time_diff_from_start = .
            gen time_diff_before_start = .
            gen temp_index = _n
            gen window_unique_index = .

            forvalues i = 1/`=_N' {
                if intervention_start[`i'] == 1 {
                    // Extract the time at which the intervention starts
                    local start_time = time_f[`i']
                    local start_obs = `i'
                    local hh = hh_id[`i']
                    local unique_index_value = unique_index[`i']

                    // Compute the margins
                    local start_minus_margin = `start_time' - `window_elapsed_minus_hours' * 3600000
                    local start_plus_margin = `start_time' + `window_elapsed_plus_hours' * 3600000

                    // Create a new temporary frame for sorting and calculations
                    frame put time_f hh_id temp_index, into(temp_frame)
                    frame change temp_frame
                    qui keep if hh_id == `hh'

                    // Create temporary variables for differences
                    gen double diff_minus = abs(time_f - `start_minus_margin')
                    gen double diff_plus = abs(time_f - `start_plus_margin')

                    // Sort and get the closest observation for minus margin
                    sort diff_minus
                    local obs_minus = temp_index[1]

                    // Sort and get the closest observation for plus margin
                    sort diff_plus
                    local obs_plus = temp_index[1]

                    // Drop the temporary frame after extracting the values
                    drop temp_index diff_minus diff_plus

                    frame change default

                    // Loop through observations between start_time and closest observation number for start_plus
                    forvalues j = `i'/`obs_plus' {
                        // Calculate time difference in minutes
                        qui replace time_diff_from_start = (time_f[`j'] - `start_time') / 60000 in `j' if hh_id == `hh'
                        qui replace window_unique_index = `unique_index_value'                  in `j' if hh_id == `hh'
                    }

                    forvalues k = `obs_minus'/`i' {
                        // Calculate time difference in minutes
                        qui replace time_diff_before_start = (time_f[`k'] - `start_time') / 60000 in `k' if hh_id == `hh'
                        qui replace window_unique_index = `unique_index_value'                    in `k' if hh_id == `hh'
                    }

                    // Drop the temporary frame
                    frame drop temp_frame
                }
            }

            drop temp_index

    // Variable that identifies the time after an intervention stop 

            // Sort by panel and time (main order)
            sort hh_id time

            // Detect intervention ends (1 -> 0 transition)
            capture drop intervention_end
            gen intervention_end = (intervention_dummy == 0) & (intervention_dummy[_n-1] == 1)

            // Create a new variable to store time difference from intervention end
            capture drop time_diff_from_end
            gen time_diff_from_end = .

            // Loop over intervention ends
            qui forvalues i = 1/`=_N' {
                if intervention_end[`i'] == 1 {
                    // Extract the time at which the intervention ends
                    local end_time = time_f[`i']
                    local hh = hh_id[`i']

                    local maximum_index_to_look_at = `i' + 1.5 * (`exclude_from_CF_after_minutes' / 5) // One observation every 5 minutes ; multiplied by 1.5 to allow for some margin. 

                    // Loop over observations from i onwards
                    forvalues j = `i'/`maximum_index_to_look_at' {
                        // Calculate time difference in minutes
                        local time_diff = (time_f[`j'] - `end_time') / 60000

                        // Replace time_diff_from_end if within 16 hours and hh_id matches
                        if `time_diff' <= `max_time_after_int_end' & hh_id[`j'] == `hh' {
                            replace time_diff_from_end = `time_diff' in `j'
                        }
                        else {
                            break
                        }
                    }
                }
            }

    // Exclude from the counterfactual calculation the observations that are too close to the start/end of an intervention
    capture drop excl_from_cf
    gen excl_from_cf = 0
    replace excl_from_cf = 1 if intervention_dummy == 1 // This is an intervention
    replace excl_from_cf = 1 if time_diff_before_start > -`exclude_from_CF_before_minutes' & time_diff_before_start <= 0 // This is too close to the start of an intervention.
    replace excl_from_cf = 1 if time_diff_from_end < `exclude_from_CF_after_minutes' // This is too close to the end of an intervention. 

    // Aggregating in one single variable the time before and after 
    capture drop elapsed_time_window
    egen elapsed_time_window = rowtotal(time_diff_before_start time_diff_from_start) // This variable starts 6 hours before and ends 16 hours after the start of an intervention. 

    // Rounding up this variable at the 5 min level as some intervention started at odd times, i.e. the following variable represents some bin categories for the time after an intervention is initiated at the 5 min level
    capture drop five_min_level_elapsed
    gen five_min_level_elapsed = ceil(elapsed_time_window/5)*5

    // Similarly: rounding up the variable after intervention end
    capture drop time_diff_from_end_5min
    gen time_diff_from_end_5min = round(time_diff_from_end/5) * 5

    // Dummy variables to identify if we're before or after a flexibility event start
    capture drop before 
    capture drop after

    gen before = 0 
    replace before = 1 if elapsed_time_window < 0 & elapsed_time_window > - `window_elapsed_minus_hours' * 60
    gen after = 0 
    replace after = 1 if elapsed_time_window > 0 & elapsed_time_window <= `window_elapsed_plus_hours' * 60

    // Converting the intervention duration from sec to hours
    capture drop total_duration_int_hour
    gen total_duration_int_hour = total_duration_int / 3600 
	
// Additional temperature variables 

	// Daily average - min - max - outdoor temperature 
	capture drop daily_avg_t_out
	capture drop daily_min_t_out
	capture drop daily_max_t_out
	egen daily_avg_t_out = mean(t_out), by(hh_id date)
	egen daily_min_t_out = min(t_out), by(hh_id date)
	egen daily_max_t_out = max(t_out), by(hh_id date)

    // Average temperature during an intervention
    capture drop avg_temp_during_int
    egen avg_temp_during_int = mean(t_out), by(hh_id unique_index) 
    replace avg_temp_during_int = round(avg_temp_during_int, 0.1)
    replace avg_temp_during_int = . if unique_index == 0 | missing(unique_index)

    // Monthly averages of outdoor temperature 
    capture drop monthly_avg_hs
    egen monthly_avg_hs = mean(daily_avg_t_out), by(monthofyear hs_index)

    // Identify the average temperature within 18 hours after an intervention is initiated

        sort hh_id time
        capture drop avg_temp_within_18h

        // Loop through each panel
        by hh_id: gen avg_temp_within_18h = .

        // Loop over the observations
        qui forvalues i = 1/`=_N' {
            // Check if current observation is the start of an intervention
            if intervention_start[`i'] == 1 {
                // Define the start time for the current intervention
                local start_time = time_f[`i']

                // Identify the window for the next 18 hours
                local end_time = `start_time' + `window_first_phase_event'

                // Calculate the mean of the temperature variable within the next 18 hours
                qui sum t_out if hh_id == hh_id[`i'] & time_f >= `start_time' & time_f <= `end_time'
                local mean_temp = r(mean)

                // Loop over the next 18 hours to replace avg_temp_within_18h with the calculated mean
                qui forvalues j = `i'/`=_N' {
                    if time_f[`j'] <= `end_time' & hh_id[`j'] == hh_id[`i'] {
                        replace avg_temp_within_18h = `mean_temp' in `j'
                    }
                    else {
                        continue, break
                    }
                }
            }
        }

		
// Categories of outdoor temperature for counterfactuals

gen temp_cf_bin = . 

replace temp_cf_bin = 1 if daily_avg_t_out <= 3 
replace temp_cf_bin = 2 if daily_avg_t_out > 3 & daily_avg_t_out <= 6 
replace temp_cf_bin = 3 if daily_avg_t_out > 6 & daily_avg_t_out <= 9 
replace temp_cf_bin = 4 if daily_avg_t_out > 9 

// Counterfactual HP power
capture drop avg_cf_hp_p_spec
capture drop sem_cf_hp_p_spec

    // Calculating the counterfactual power (specific to each HP and time of day, excluding observations that are too close to the start/end of an intervention)
    preserve
        collapse (mean) avg_cf_hp_p_spec = hp_p (semean) sem_cf_hp_p_spec = hp_p, by(hh_id five_min_level_int temp_cf_bin intervention_dummy excl_from_cf)

        drop if intervention_dummy == 1
        drop if excl_from_cf == 1 & intervention_dummy == 0

        gen ul_cf_hp_p_spec = avg_cf_hp_p_spec + 1.96 * sem_cf_hp_p_spec
        gen ll_cf_hp_p_spec = avg_cf_hp_p_spec - 1.96 * sem_cf_hp_p_spec

        tempfile counterfactuals
        save `counterfactuals', replace
    restore

    // Matching the counterfactual with the original dataset 
    merge m:1 hh_id five_min_level_int temp_cf_bin using `counterfactuals'
    drop _merge
		
sort hh_id time

sleep 10000
save data_prepared, replace


// Counterfactual indoor temperature
capture drop avg_cf_t_in_spec
capture drop sem_cf_t_in_spec

    // Calculating the counterfactual power (specific to each HP and time of day, excluding observations that are too close to the start/end of an intervention)
    preserve
        collapse (mean) avg_cf_t_in_spec = t_in (semean) sem_cf_t_in_spec = t_in, by(hh_id five_min_level_int temp_cf_bin intervention_dummy excl_from_cf)

        drop if intervention_dummy == 1
        drop if excl_from_cf == 1 & intervention_dummy == 0

        gen ul_cf_t_in_spec = avg_cf_t_in_spec + 1.96 * sem_cf_t_in_spec
        gen ll_cf_t_in_spec = avg_cf_t_in_spec - 1.96 * sem_cf_t_in_spec

        tempfile counterfactuals
        save `counterfactuals', replace
    restore

    // Matching the counterfactual with the original dataset 
    merge m:1 hh_id five_min_level_int temp_cf_bin using `counterfactuals'
    drop _merge
    
sort hh_id time

sleep 10000
save data_prepared, replace

end

capture program drop data_preparation
program define data_preparation
// This programs prepares the dataset from the field experiment.
// Necessary to run the rest of the program.
// Output: data_prepared.dta

use experiment_data, clear

code_for_preparation 6 48 20 960 1056 18 // 1056 is a 10% increase over 960 mins (= 16 hours). This extra margin is needed to stabilize the lpoly smoothing at the x-axis boundary. But we don't plot further than 16 hours.  

end

********************************************************************************
* Table 2: Duration of interventions and stopping scenarios					   *
********************************************************************************
capture program drop Table_2_duration_reason_stops
program define Table_2_duration_reason_stops
// This programs computes the quantities that enter Table 2.

use data_prepared, clear
sort hh_id time

// Reasons for intervention termination

    capture gen reason_label = ""
    qui replace reason_label = "Indoor temperature threshold" if reason_stop == -1
    qui replace reason_label = "DHW temperature threshold" if reason_stop == -2
    qui replace reason_label = "Manual overrule (all)" if reason_stop != 0 & reason_stop != -1 & reason_stop != -2
    qui replace reason_label = "Manual overrule (in advance)" if reason_stop != 0 & reason_stop != -1 & reason_stop != -2 & reason_stop != -3

// Threshold temperature for interventions that were automatically stopped because of the indoor temperature

    tab t_threshold_0 if reason_stop == -1

// Average indoor temperature for manually stopped interventions during the intervention

    ci means t_in if reason_stop == -3
	
// Table 2: duration 
    
    // Columns: N, Percent ; Min, Max
    tab reason_label if reason_stop != 0

    // Column: Average d
    sum total_duration_int_hour if reason_stop == -2
    sum total_duration_int_hour if reason_stop != 0 & reason_stop != -1 & reason_stop != -2
    sum total_duration_int_hour if reason_stop == -1
    sum total_duration_int_hour if reason_stop != 0
        local avg_duration_int = r(mean)

    // Column: 95% CI
    ci means total_duration_int_hour if reason_stop == -2
    ci means total_duration_int_hour if reason_stop != 0 & reason_stop != -1 & reason_stop != -2
    ci means total_duration_int_hour if reason_stop == -1
    ci means total_duration_int_hour if reason_stop != 0

    // Column: Median
    sum total_duration_int_hour if reason_stop == -2, d
    sum total_duration_int_hour if reason_stop != 0 & reason_stop != -1 & reason_stop != -2, d
    sum total_duration_int_hour if reason_stop == -1, d
    sum total_duration_int_hour if reason_stop != 0, d

// Text: t-tests comparisons of the duration by reason_stop 

capture drop reason_stop_group
capture drop group_* 
capture drop by_*

// Pooling manual and preemptive manual overrules
gen reason_stop_group = reason_stop if reason_stop != -1 & reason_stop != -2 & reason_stop != 0

* Manual overrules vs DHW temp threshold
gen group_1 = reason_stop != -1 & reason_stop != 0
gen by_1 = reason_stop == -2
ttest total_duration_int_hour if group_1, by(by_1) une

* Manual overrules vs Indoor temp threshold
gen group_2 = reason_stop != -2 & reason_stop != 0
gen by_2 = reason_stop == -1
ttest total_duration_int_hour if group_2, by(by_2) une

* DHW temp threshold vs Indoor temp threshold
gen group_3 = reason_stop == -1 | reason_stop == -2
gen by_3 = reason_stop == -1
ttest total_duration_int_hour if group_3, by(by_3) une
	
end

********************************************************************************
* Figure 1: Histogram of duration 											   *
********************************************************************************
capture program drop Fig_1_hist_duration
program define Fig_1_hist_duration
// This programs plots Figure 1.

use data_prepared, clear
sort hh_id time

// Text:

tab total_duration_int_hour if reason_stop != 0

// Figure preparation: 

qui sum total_duration_int_hour if reason_stop != 0
local avg_duration_int = r(mean)

// Fig. 1: Histogram of the total duration of all interventions in bins of 1h. 

twoway hist total_duration_int_hour if reason_stop != 0 & total_duration_int_hour < 50, aspectratio(1) width(1) xtitle("Intervention duration (h)") density color(blue%35) xline(`avg_duration_int', lcolor(edkblue) lwidth(1.5 pt)) //////
    graphregion(color(white) margin(zero))  xsize(8) ysize(8)  
	
graph export "Fig_1.pdf", replace width(8) height(8) 

end

********************************************************************************
* Table 3: Regression of intervention duration								   *
********************************************************************************
capture program drop Table_3_reg_duration
program define Table_3_reg_duration 
// This program estimates the regressions in Table 3. 

use data_prepared, clear
sort hh_id time

// Regression of the intervention duration 

capture drop constant 
capture drop t_dhw_0_notdec_geq_40
capture drop t_dhw_0_dec

gen constant = 1 

gen t_dhw_0_notdec_geq_40 = t_dhw_0 * (1 - decoupled) * (t_dhw_0 >= 40)
gen t_dhw_0_dec = t_dhw_0 * decoupled

// Adding the difference between max and min daily temperatures 

capture drop delta_daily_temp

gen delta_daily_temp = daily_max_t_out - daily_min_t_out

// Text:

pwcorr delta_daily_temp daily_max_t_out, sig star(0.05)
pwcorr delta_daily_temp daily_min_t_out, sig star(0.05)

ci means t_dhw_0_notdec_geq_40 if reason_stop != 0 & t_dhw_0_notdec_geq_40 != 0
ci means t_dhw_0_dec if reason_stop != 0 & t_dhw_0_dec != 0

// Regression: 

    // Without HH-FE

        // Model 1

        wildbootstrap reg total_duration_int_hour t_in_0 min_t_out_5h delta_daily_temp t_dhw_0_dec t_dhw_0_notdec_geq_40 constant if reason_stop != 0, hascons cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_1_d
        matrix list r(table)

        // Model 2

        wildbootstrap reg total_duration_int_hour i.notif_0 t_in_0 delta_daily_temp min_t_out_5h t_dhw_0_dec t_dhw_0_notdec_geq_40 constant if reason_stop != 0, hascons cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_2_d
        matrix list r(table)

    // With HH FE

        // Model 3

        wildbootstrap reg total_duration_int_hour i.notif_0 t_in_0 min_t_out_5h delta_daily_temp t_dhw_0 i.hh_id if reason_stop != 0, cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_3_d
        matrix list r(table)

        // Model 4

        wildbootstrap reg total_duration_int_hour i.notif_0 t_in_0 min_t_out_5h delta_daily_temp t_dhw_0 ib(14).hourofday_0 i.hh_id if reason_stop != 0, cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_4_d
        matrix list r(table)

// Table 3: 

estout Model_1_d Model_2_d Model_3_d Model_4_d, ///
  drop(_cons) cells(b(fmt(%9.3f)))  ///
  stats(r2_a N, labels("Adj. R-Square" "N"))
  di "! The p-values reported by estout do not correspond to the bootstrapped p-values but to the original unclustered OLS ones. p-values derived from Wild bootstrap have to be entered manually, from the wildboostrap output tables directly." 
  
end

********************************************************************************
* Figure 2: Power and temperature profiles during/outside interventions        *
********************************************************************************
capture program drop ATT_temperature_eq_7 
program define ATT_temperature_eq_7
// This program reports the ATT on indoor temperature from eq. 7

use data_prepared, clear
sort hh_id time

ttest t_in, by(intervention_dummy) une
wildbootstrap reg t_in intervention_dummy i.hh_id, cluster(hh_id) rseed(42) reps(100000) // Household-fixed effects
	
end

capture program drop ATT_power_eq_8
program define ATT_power_eq_8
// This program reports the ATT on HP power from eq. 8

use data_prepared, clear
sort hh_id time

ttest hp_p if !(excl_from_cf == 1 & intervention_dummy == 0), by(intervention_dummy) une
wildbootstrap reg hp_p intervention_dummy i.hh_id, cluster(hh_id) rseed(42) reps(100000) // Household-fixed effects

end

capture program drop Fig_2_pow_temp_profiles
program define Fig_2_pow_temp_profiles
// This program plots the indoor temperature and heat pump power profiles in Fig 2.
// Both panels.

use data_prepared, clear
sort hh_id time

* Indoor temperature

	preserve

		// Collapse of t_in on five_min_level_int, intervention_dummy and excl_from_cf (to exclude these observations from the counterfactual)
		collapse (mean) t_in (semean) sem_t_in = t_in, by(five_min_level_int intervention_dummy excl_from_cf) 
		sort intervention_dummy five_min_level_int

		// Exclude observations that are too close to the start/end of an intervention from the counterfactual calculation
		drop if excl_from_cf == 1 & intervention_dummy == 0

		// Generate the 95% CI
		capture drop ul
		capture drop ll 

		gen ul = t_in + 1.96 * sem_t_in
		gen ll = t_in - 1.96 * sem_t_in

		// Smoothing of the UL and LL (the BW comes from the local polynomial smoothing of the average)

			// Control: 

				capture drop ul_avg_t_in_5min_control_smooth
				capture drop ll_avg_t_in_5min_control_smooth

				lpoly ul five_min_level_int if intervention_dummy == 0, degree(0) gen(ul_avg_t_in_5min_control_smooth) at(five_min_level_int)
				lpoly ll five_min_level_int if intervention_dummy == 0, degree(0) gen(ll_avg_t_in_5min_control_smooth) at(five_min_level_int)

			// Intervention: 

				capture drop ul_avg_t_in_5min_inter_smooth
				capture drop ll_avg_t_in_5min_inter_smooth

				lpoly ul five_min_level_int if intervention_dummy == 1, degree(0) gen(ul_avg_t_in_5min_inter_smooth) at(five_min_level_int)
				lpoly ll five_min_level_int if intervention_dummy == 1, degree(0) gen(ll_avg_t_in_5min_inter_smooth) at(five_min_level_int)

		// Plot Fig. 2

			twoway lpoly t_in five_min_level_int if intervention_dummy == 0, clcolor(green) degree(0) ///
				|| rarea ul_avg_t_in_5min_control_smooth ll_avg_t_in_5min_control_smooth five_min_level_int, sort  fcolor(green%30) lcolor(green%0) ///
				|| lpoly t_in five_min_level_int if intervention_dummy == 1, clcolor(blue) degree(0) ///
				|| rarea ul_avg_t_in_5min_inter_smooth ll_avg_t_in_5min_inter_smooth five_min_level_int, sort fcolor(blue%30) lcolor(blue%0) ///
				aspectratio(1) xlabel(0 "0" 72 "6" 144 "12" 216 "18" 288 "24") xtitle("Time of day (h)") ///
				ylabel(19.8(0.2)21) ytitle("Average indoor temperature" "across the sample  (°C)") ///
				legend(order(1 "Non-intervention" 2 "95% CI" 3 "Intervention" 4 "95% CI") cols(2) pos(6) size(medsmall))  graphregion(color(white) margin(zero))  xsize(8) ysize(8) 

			graph export "Fig_2_left.pdf", width(8) height(8) replace

	restore

* Heat pump power
		
	// Plot Fig. 2
	
	preserve
	
		// Collapse of hp_p on five_min_level_int, intervention_dummy, decoupled and excl_from_cf (to exclude these observations from the counterfactual)
		collapse (mean) hp_p (semean) sem_hp_p = hp_p, by(five_min_level_int intervention_dummy excl_from_cf decoupled) 
		sort intervention_dummy five_min_level_int

		// Exclude observations that are too close to the start/end of an intervention from the counterfactual calculation
		drop if excl_from_cf == 1 & intervention_dummy == 0

		// Exclude observations from decoupled HPs
		drop if decoupled == 1

		// Generate the 95% CI
		capture drop ul
		capture drop ll 

		gen ul = hp_p + 1.96 * sem_hp_p
		gen ll = hp_p - 1.96 * sem_hp_p

		// Smoothing of the UL and LL (the BW comes from the local polynomial smoothing of the average)

			// Control: 

				capture drop ul_avg_hp_p_5min_control_smooth
				capture drop ll_avg_hp_p_5min_control_smooth

				lpoly ul five_min_level_int if intervention_dummy == 0, degree(0) gen(ul_avg_hp_p_5min_control_smooth) at(five_min_level_int)
				lpoly ll five_min_level_int if intervention_dummy == 0, degree(0) gen(ll_avg_hp_p_5min_control_smooth) at(five_min_level_int)

			// Intervention: 

				capture drop ul_avg_hp_p_5min_inter_smooth
				capture drop ll_avg_hp_p_5min_inter_smooth

				lpoly ul five_min_level_int if intervention_dummy == 1, degree(0) gen(ul_avg_hp_p_5min_inter_smooth) at(five_min_level_int)
				lpoly ll five_min_level_int if intervention_dummy == 1, degree(0) gen(ll_avg_hp_p_5min_inter_smooth) at(five_min_level_int)

		// Plot Fig. 2

			twoway lpoly hp_p five_min_level_int if intervention_dummy == 0, clcolor(green) degree(0) ///
				|| rarea ul_avg_hp_p_5min_control_smooth ll_avg_hp_p_5min_control_smooth five_min_level_int, sort  fcolor(green%30) lcolor(green%0) ///
				|| lpoly hp_p five_min_level_int if intervention_dummy == 1, clcolor(blue) degree(0) ///
				|| rarea ul_avg_hp_p_5min_inter_smooth ll_avg_hp_p_5min_inter_smooth five_min_level_int, sort fcolor(blue%30) lcolor(blue%0) ///
				aspectratio(1) xlabel(0 "0" 72 "6" 144 "12" 216 "18" 288 "24") xtitle("Time of day (h)") ///
				ylabel(0(100)600) ytitle("Average HP power consumption" "across non-decoupled HPs (W)") ///
				legend(order(1 "Non-intervention" 2 "95% CI" 3 "Intervention" 4 "95% CI") cols(2) pos(6) size(medsmall))  graphregion(color(white) margin(zero))  xsize(8) ysize(8) 

			graph export "Fig_2_right.pdf", width(8) height(8) replace

	restore
	
// Text: 

pwcorr hp_p t_out, sig star(.05)	
	
end

********************************************************************************
* Figure 3: Histogram of consumption saved during interventions (kWh)          *
********************************************************************************
capture program drop calculation_for_Fig_3
program define calculation_for_Fig_3
// Calculating the counterfactual energy consumption during interventions

    // Initiating variables
    capture drop energy_consumed_during_int 
    capture drop cf_energy_consumed_during_int_s  
    capture drop energy_saved_int

    gen energy_consumed_during_int = . 
    gen cf_energy_consumed_during_int_s = .  
    gen energy_saved_int = . 

    capture drop hp_p_filling
    capture drop cf_hp_p_filling_spec
    sort hh_id time

    gen hp_p_filling = hp_p if intervention_dummy == 1
    replace hp_p_filling = hp_p_filling[_n-1] if missing(hp_p_filling) & intervention_dummy == 1

    gen cf_hp_p_filling_spec = avg_cf_hp_p_spec if intervention_dummy == 1
    replace cf_hp_p_filling_spec = cf_hp_p_filling_spec[_n-1] if missing(cf_hp_p_filling_spec) & intervention_dummy == 1  

    // Computation of the counterfactual energy consumption during the intervention 
    sort hh_id time

    qui forval i = 2/`=_N' {

        if intervention_dummy[`i'] == 1 & intervention_dummy[`i' - 1] == 0 {
            replace energy_consumed_during_int = 0 in `i'
            replace cf_energy_consumed_during_int_s = 0 in `i' // this is the one to use
        }

        else if intervention_dummy[`i'] == 1 & intervention_dummy[`i' - 1] != 0 {
            qui replace energy_consumed_during_int = energy_consumed_during_int[`i' - 1] + 10^(-3) * hp_p_filling[`i'] * (1/3600) * (elapsed_time_inter[`i'] - elapsed_time_inter[`i' - 1]) in `i'
            qui replace cf_energy_consumed_during_int_s = cf_energy_consumed_during_int_s[`i' - 1] + 10^(-3) * cf_hp_p_filling_spec[`i'] * (1/3600) * (elapsed_time_inter[`i'] - elapsed_time_inter[`i' - 1]) in `i' 
        }
    }

    replace energy_saved_int = cf_energy_consumed_during_int_s - energy_consumed_during_int 

end

capture program drop Fig_3_hist_kWh_reduction
program define Fig_3_hist_kWh_reduction
// This program plots the histogram of Fig. 3
	
use data_prepared, clear
sort hh_id time

calculation_for_Fig_3	
	
// Analysis of the energy consumption saved during the intervention

ci means energy_saved_int if reason_stop != 0 // Represents only part of the variability, across the means. But ignores the variability on the CF, leading to variability in each mean. 
pwcorr energy_saved_int total_duration_int_hour if reason_stop != 0, obs sig star(0.05)

qui sum energy_saved_int if reason_stop != 0
local avg_energy_shift_spec = r(mean)

// Fig. 3: histogram of the consumption decrease

twoway hist energy_saved_int if reason_stop != 0 & energy_saved_int < 15, width(0.5) aspectratio(1) xtitle("Average electricity consumption reduction (kWh)" "during interventions") xlabel(0(2.5)15) color(blue%35) ///
	 graphregion(color(white) margin(zero))  xsize(5) ysize(5) xline(`avg_energy_shift_spec', lcolor(edkblue) lwidth(1.5 pt)) 

graph export "Fig_3.pdf", width(8) height(8) replace

end

********************************************************************************
* Figure 4: Rebound power (W) and consumption (kWh) after interventions        *
********************************************************************************
capture program drop calculation_for_Fig_4
program define calculation_for_Fig_4
// Calculating the counterfactual energy and power consumption within 16h after interventions

    // Initiating variables
    capture drop energy_consumed_after_int 
    capture drop cf_energy_consumed_after_int_s 
    capture drop energy_rebound_after_int // in kWh
    capture drop power_rebound_after_int // in W

    gen energy_consumed_after_int = . 
    gen cf_energy_consumed_after_int_s = .
    gen energy_rebound_after_int = .
    gen power_rebound_after_int = . 

    capture drop hp_p_filling_after
    capture drop cf_hp_p_filling_after_spec  
    sort hh_id time

    gen hp_p_filling_after = hp_p if time_diff_from_end_5min > 0 
    replace hp_p_filling_after = hp_p_filling_after[_n-1] if missing(hp_p_filling_after) & time_diff_from_end_5min > 0 

    gen cf_hp_p_filling_after_spec = avg_cf_hp_p_spec if time_diff_from_end_5min > 0  
    replace cf_hp_p_filling_after_spec = cf_hp_p_filling_after_spec[_n-1] if missing(cf_hp_p_filling_after_spec) & time_diff_from_end_5min > 0 

    // Computation of the counterfactual energy consumption during the intervention 
    sort hh_id time

    qui forval i = 2/`=_N' {
    
        if time_diff_from_end_5min[`i'] == 0 {
            replace energy_consumed_after_int = 0 in `i'
            replace cf_energy_consumed_after_int_s = 0 in `i' 
        }

        // HP_P is in W -> 10^(-3) * HP_P is in kW ; time_after_int_end is in mins -> (1/60) * time_after_int_end is in hours. 
        // Conversion factor is 10^(-3) * (1/60) to get the amount of energy in kWh. 
        else if time_diff_from_end_5min[`i'] > 0 {
            qui replace energy_consumed_after_int = energy_consumed_after_int[`i' - 1] + (10^(-3) * hp_p_filling_after[`i']) * (1/60) * (time_diff_from_end_5min[`i'] - time_diff_from_end_5min[`i' - 1]) in `i'
            qui replace cf_energy_consumed_after_int_s = cf_energy_consumed_after_int_s[`i' - 1] + (10^(-3) * cf_hp_p_filling_after_spec[`i']) * (1/60) * (time_diff_from_end_5min[`i'] - time_diff_from_end_5min[`i' - 1]) in `i' 
            }
    }
    
    replace energy_rebound_after_int = energy_consumed_after_int - cf_energy_consumed_after_int_s // Rebound electricity consumption in kWh
    replace power_rebound_after_int = hp_p - cf_hp_p_filling_after_spec // Rebound power in W

end

capture program drop preparation_plot_Fig_4_left
program define preparation_plot_Fig_4_left

    // Collapse of the rebound consumption on time_after_int_end_5min
    collapse (mean) power_rebound_after_int (semean) sem_power_rebound = power_rebound_after_int, by(time_diff_from_end_5min) 
    sort time_diff_from_end_5min

    // Generate the 95% CI
    capture drop ul
    capture drop ll 

    gen ul = power_rebound_after_int + 1.96 * sem_power_rebound
    gen ll = power_rebound_after_int - 1.96 * sem_power_rebound

    // Smoothing of the UL and LL

        capture drop ul_power_rebound_smooth
        capture drop ll_power_rebound_smooth

        lpoly ul time_diff_from_end_5min, degree(0) gen(ul_power_rebound_smooth) at(time_diff_from_end_5min)
        lpoly ll time_diff_from_end_5min, degree(0) gen(ll_power_rebound_smooth) at(time_diff_from_end_5min)
		
end

capture program drop preparation_plot_Fig_4_right
program define preparation_plot_Fig_4_right

    // Collapse of the rebound consumption on time_after_int_end_5min
    collapse (mean) energy_rebound_after_int (semean) sem_energy_rebound = energy_rebound_after_int, by(time_diff_from_end_5min) 
    sort time_diff_from_end_5min

    // Generate the 95% CI
    capture drop ul
    capture drop ll 

    gen ul = energy_rebound_after_int + 1.96 * sem_energy_rebound
    gen ll = energy_rebound_after_int - 1.96 * sem_energy_rebound

    // Smoothing of the UL and LL 

        capture drop ul_energy_rebound_smooth
        capture drop ll_energy_rebound_smooth

        lpoly ul time_diff_from_end_5min, degree(0) gen(ul_energy_rebound_smooth) at(time_diff_from_end_5min)
        lpoly ll time_diff_from_end_5min, degree(0) gen(ll_energy_rebound_smooth) at(time_diff_from_end_5min)

end

capture program drop Fig_4_rebound_post_inter
program define Fig_4_rebound_post_inter
// This program plots both panels of Fig. 4
// Standard errors are derived from the variability of the mean quantity at each bin for time after intervention stop (at the 5 min-level); i.e. does not fully account for the autocorrelation structure in the errors, nor the intra-household variability. 

use data_prepared, clear
sort hh_id time

calculation_for_Fig_4

// Generating a variable to capture the full rebound electricity consumption (kWh), at 16h after the intervention stop
capture drop energy_rebound_after_int_16h
gen energy_rebound_after_int_16h = energy_rebound_after_int if time_diff_from_end_5min == 960 // 16h in minutes

// Quantification of the rebound energy consumption (kWh)

di "***** Rebound energy consumption (in kWh, right panel):"

di "Within the first 8 hours:"
ci means energy_rebound_after_int if time_diff_from_end_5min == 480 // 8 hours
di "Within the first 16 hours:"
ci means energy_rebound_after_int_16h // 16 hours

// Quantification of the rebound power consumption (W)

di "***** Rebound power consumption (in W, left panel):"

di "Within the first 1/2 hour:"
ci means power_rebound_after_int if time_diff_from_end_5min <= 30 // 1/2 hour
di "Within the first 1 hour:"
ci means power_rebound_after_int if time_diff_from_end_5min <= 60 // 1 hours
di "Within the first 8 hours:"
ci means power_rebound_after_int if time_diff_from_end_5min <= 480 // 8 hours
di "Within the first 16 hours:"
ci means power_rebound_after_int if time_diff_from_end_5min <= 960 // 16 hours

// Plot Fig. 4 - right

preserve

preparation_plot_Fig_4_right
    
    // Plot Fig. 4 - right

    twoway lpoly energy_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 960, clcolor(orange) degree(0) ///
         || rarea ul_energy_rebound_smooth ll_energy_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 960, sort fcolor(orange%30) lcolor(orange%0) ///
        aspectratio(1) ytitle("Average post-intervention" "electricity consumption increase (kWh)") ylabel(0(0.5)3.5) ///
        xtitle("Time to intervention stop (h)") xlabel(0 "0" 120 "2" 240 "4" 360 "6" 480 "8" 600 "10" 720 "12" 840 "14" 960 "16") ///
        legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) graphregion(color(white) margin(zero))  xsize(8) ysize(8)  

    graph export "Fig_4_right.pdf", width(8) height(8) replace

restore

// Plot Fig. 4 - left

preserve

preparation_plot_Fig_4_left

    // Plot Fig. 4 - left

    twoway lpoly power_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 960, clcolor(orange) degree(0) ///
        || rarea ul_power_rebound_smooth ll_power_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 960, sort fcolor(orange%30) lcolor(orange%0)  ///
        aspectratio(1) xlabel(0 "0" 120 "2" 240 "4" 360 "6" 480 "8" 600 "10" 720 "12" 840 "14" 960 "16") xtitle("Time to intervention stop (h)") ///
        ylabel(-100(100)900) ytitle("Average post-intervention" "power consumption increase (W)") yline(0) ///
        legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) graphregion(color(white) margin(zero))  xsize(8) ysize(8)  

graph export "Fig_4_left.pdf", width(8) height(8) replace

restore

end

********************************************************************************
* Figures 5 and A.15: Power profile (Fig. 5 left),                             *
*				   Net power reduction (Fig. 5 right),                         *
*                  Net consumption reduction (Fig. A.15);                      *
* after a flexibility event is initiated                                       *
********************************************************************************
capture program drop calculation_for_Fig_5_left
program define calculation_for_Fig_5_left

use data_prepared, clear
sort hh_id time

    // Collapse of the observed and HP-specific counterfactual power consumption on five_min_level_elapsed (5 min of intervention)
    collapse (mean) hp_p (semean) sem_hp_p = hp_p (mean) avg_cf_hp_p_spec_fleet = avg_cf_hp_p_spec (semean) se_cf_hp_p_spec_fleet = avg_cf_hp_p_spec, by(five_min_level_elapsed before after)

    // Constructing the 95% CI: reflecting the variability over the different HPs
    capture drop ul 
    capture drop ll 
    capture drop ul_cf
    capture drop ll_cf

    gen ul = hp_p + 1.96 * sem_hp_p
    gen ll = hp_p - 1.96 * sem_hp_p
   
    gen ul_cf = avg_cf_hp_p_spec_fleet + 1.96 * se_cf_hp_p_spec_fleet
    gen ll_cf = avg_cf_hp_p_spec_fleet - 1.96 * se_cf_hp_p_spec_fleet
		
	// Calculate optimal BW for average intervention curve (hp_p)
    lpoly hp_p five_min_level_elapsed if (before == 1 | after == 1), degree(0)
    local bw_hp_p = r(bwidth)
	scalar bw_hp_p_scalar = `bw_hp_p' // Needed for later 

    // Calculate the optimal BW for average control curve (cf_avg_bin_spec)
    lpoly avg_cf_hp_p_spec_fleet five_min_level_elapsed if (before == 1 | after == 1), degree(0)
    local bw_cf = r(bwidth)
	scalar bw_cf_scalar = `bw_cf' // Needed for later 

    // Smooth the CIs for the control curve using the BW calculated above
    capture drop UL_cf_sm 
    capture drop LL_cf_sm
    capture drop at_values

    gen at_values = . 
    replace at_values = five_min_level_elapsed if (before == 1 | after == 1) 
        // UL
        lpoly ul_cf five_min_level_elapsed if !missing(at_values), at(at_values) gen(UL_cf_sm) degree(0) bw(`bw_cf')

        // LL
        lpoly ll_cf five_min_level_elapsed if !missing(at_values), at(at_values) gen(LL_cf_sm) degree(0) bw(`bw_cf')

    drop at_values
	
    // Smooth the CIs for the intervention curve using the BW calculated above
    capture drop UL_sm_before 
    capture drop LL_sm_before
    capture drop UL_sm_after 
    capture drop LL_sm_after

        // Before: 
        capture drop at_values

        gen at_values = . 
        replace at_values = five_min_level_elapsed if before == 1

                // UL 
                lpoly ul five_min_level_elapsed if !missing(at_values), at(at_values) gen(UL_sm_before) degree(0) bw(`bw_hp_p')

                // LL
                lpoly ll five_min_level_elapsed if !missing(at_values), at(at_values) gen(LL_sm_before) degree(0) bw(`bw_hp_p')

        drop at_values

        // After: 
        capture drop at_values

        gen at_values = . 
        replace at_values = five_min_level_elapsed if after == 1

                // UL 
                lpoly ul five_min_level_elapsed if !missing(at_values), at(at_values) gen(UL_sm_after) degree(0) bw(`bw_hp_p')

                // LL
                lpoly ll five_min_level_elapsed if !missing(at_values), at(at_values) gen(LL_sm_after) degree(0) bw(`bw_hp_p')

        drop at_values

end 

capture program drop calculation_for_Fig_5_right
program define calculation_for_Fig_5_right

    // Dropping all observations before 
    keep if after == 1

    // Computing the average power reduction (in W) and CIs assuming independence
    capture drop power_reduction
    capture drop se_power_reduction
    capture drop ul_power_reduction 
    capture drop ll_power_reduction 

    gen power_reduction = . 
    replace power_reduction = avg_cf_hp_p_spec_fleet - hp_p 

    gen se_power_reduction = . 
    replace se_power_reduction = sqrt(sem_hp_p^2 + se_cf_hp_p_spec_fleet^2)

    gen ul_power_reduction = . 
    replace ul_power_reduction = power_reduction + 1.96 * se_power_reduction

    gen ll_power_reduction = . 
    replace ll_power_reduction = power_reduction - 1.96 * se_power_reduction

    // Smooth the CIs for the control curve
    capture drop ul_power_reduction_sm
    capture drop ll_power_reduction_sm

    capture drop at_values

    gen at_values = . 
    replace at_values = five_min_level_elapsed

        // UL
        lpoly ul_power_reduction five_min_level_elapsed if !missing(at_values), gen(ul_power_reduction_sm) at(at_values) degree(0) 

        // LL
        lpoly ll_power_reduction five_min_level_elapsed if !missing(at_values), gen(ll_power_reduction_sm) at(at_values) degree(0)

    drop at_values

end

capture program drop calculation_for_Fig_A15 
program define calculation_for_Fig_A15

    // Additional time variables

        // Computing time difference
        sort five_min_level_elapsed

        // Time difference between two observations (expressed in hours)
        capture drop hour_level_elapsed
        gen hour_level_elapsed = 0
        replace hour_level_elapsed = (five_min_level_elapsed - five_min_level_elapsed[_n-1]) / 60 if !missing(five_min_level_elapsed[_n-1])

    // Computing the amount of electricity saved (expressed in kWh)...
    capture drop instant_net_energy_saved
    capture drop ul_instant_net_energy_saved
    capture drop ll_instant_net_energy_saved

    capture drop cumulative_net_energy_saved 
    capture drop ul_cumulative_net_energy_saved 
    capture drop ll_cumulative_net_energy_saved 

        // ...From one observation to the other (i.e. within 5 mins interval)
        gen instant_net_energy_saved = 0 
        gen ul_instant_net_energy_saved = 0 
        gen ll_instant_net_energy_saved = 0   

        replace instant_net_energy_saved = (power_reduction/1000) * hour_level_elapsed 
        replace ul_instant_net_energy_saved = (ul_power_reduction/1000) * hour_level_elapsed  
        replace ll_instant_net_energy_saved = (ll_power_reduction/1000) * hour_level_elapsed  

        // ...Cumulative since flexibility event start 
        gen cumulative_net_energy_saved = 0
        gen ul_cumulative_net_energy_saved = 0 
        gen ll_cumulative_net_energy_saved = 0

        replace cumulative_net_energy_saved = cumulative_net_energy_saved[_n-1] + instant_net_energy_saved if !missing(cumulative_net_energy_saved[_n-1])
        replace ul_cumulative_net_energy_saved = ul_cumulative_net_energy_saved[_n-1] + ul_instant_net_energy_saved if !missing(ul_cumulative_net_energy_saved[_n-1])
        replace ll_cumulative_net_energy_saved = ll_cumulative_net_energy_saved[_n-1] + ll_instant_net_energy_saved if !missing(ll_cumulative_net_energy_saved[_n-1])


    // Smooth the CIs for the control curve
    capture drop ul_cumul_net_energy_saved_sm 
    capture drop ll_cumul_net_energy_saved_sm

    capture drop at_values

    gen at_values = . 
    replace at_values = five_min_level_elapsed if after == 1

        // UL 
        lpoly ul_cumulative_net_energy_saved five_min_level_elapsed if !missing(at_values), at(at_values) gen(ul_cumul_net_energy_saved_sm) degree(0)

        // LL
        lpoly ll_cumulative_net_energy_saved five_min_level_elapsed if !missing(at_values), at(at_values) gen(ll_cumul_net_energy_saved_sm) degree(0)

    drop at_values

end

capture program drop Fig_5_A15_pow_cons_during_event
program define Fig_5_A15_pow_cons_during_event
// This program plots both panels of Fig. 5 and Fig. 6

preserve

calculation_for_Fig_5_left

// Plot Fig. 5 - left 

	local bw_hp_p = scalar(bw_hp_p_scalar)
	local bw_cf = scalar(bw_cf_scalar)
	
    twoway ///
        lpoly hp_p five_min_level_elapsed if before == 1, clcolor(blue)  bw(`bw_hp_p') ///
        || lpoly hp_p five_min_level_elapsed if after == 1, clcolor(blue)  bw(`bw_hp_p') ///
        || rarea UL_sm_before LL_sm_before five_min_level_elapsed if before == 1, sort fcolor(blue%30) lcolor(blue%0) ///
        || rarea UL_sm_after LL_sm_after five_min_level_elapsed if after == 1, sort fcolor(blue%30) lcolor(blue%0) ///
        || lpoly avg_cf_hp_p_spec_fleet five_min_level_elapsed if (before == 1 | after == 1), clcolor(green) bw(`bw_cf') ///
        || rarea UL_cf_sm LL_cf_sm five_min_level_elapsed if (before == 1 | after == 1), sort fcolor(green%30) lcolor(green%0) ///
        aspectratio(1) xline(0, lwidth(thin) lcolor(gray)) xlabel(-360 "-6" 0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ///
        ylabel(0(100)600) ytitle("Average HP power in the fleet (W)") ///
        legend(order(1 "Average across interventions" 3 "95% CI" 5 "Control" 6 "95% CI" ) cols(2) pos(6) size(small)) ///
        graphregion(color(white) margin(zero)) xsize(8) ysize(8) 	

    // Export the plot
    graph export "Fig_5_left.pdf", width(8) height(8) replace

// Plot Fig. 5 - right 

calculation_for_Fig_5_right

    //  Plot the graph
    twoway lpoly power_reduction five_min_level_elapsed, clcolor(orange) yline(0) ///
        || rarea ul_power_reduction_sm ll_power_reduction_sm five_min_level_elapsed, sort color(orange%30) lcolor(orange%0) ///
       xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") ylabel(-200(50)300) ///
        xtitle("Time to flexibility event start (h)") ytitle("Average HP power reduction in the fleet (W)") legend(order(1 "Average across interventions" 2 "95% CI" ) cols(2) pos(6) size(small)) ///
        graphregion(color(white) margin(zero)) xsize(8) ysize(8)

    // Export the plot
    graph export "Fig_5_right.pdf", replace

// Quantification of the power reduction

ci means power_reduction if five_min_level_elapsed <= 60 // 1 hours
ci means power_reduction if five_min_level_elapsed <= 1080 // 18 hours
ci means power_reduction if five_min_level_elapsed > 1080 & five_min_level_elapsed <= 2160 // From 18h to 36h (fleet-rebound period)

sum power_reduction if five_min_level_elapsed > 1080 & five_min_level_elapsed <= 2160 // From 18h to 36h (fleet-rebound period)

// Plot Fig. A.15 

calculation_for_Fig_A15

    //  Plot the graph
    twoway lpoly cumulative_net_energy_saved five_min_level_elapsed, lcolor(orange) degree(0) ///
         || rarea ul_cumul_net_energy_saved_sm ll_cumul_net_energy_saved_sm five_min_level_elapsed if five_min_level_elapsed > 0, sort fcolor(orange%30) lcolor(orange%0)  ///
        xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ///
        ytitle("Average electricity consumption" "reduction per HP in the fleet (kWh)") ylabel(-2.5(0.5)5) yline(0) legend(pos(6)) yline(0) xline(1080, lcolor(dkorange) lp(dash_dot)) xline(2160, lcolor(dkorange) lp(dash_dot)) ///
        legend(order(1 "Average across interventions" 2 "CI") cols(2) pos(6) size(small)) ////
        graphregion(color(white) margin(zero))  xsize(8) ysize(8) 

    // Export the plot
    graph export "Fig_A15.pdf", replace

restore

end

********************************************************************************
* Figures A.16: Power profile,                                                 *
*         A.17: Net power reduction,                                           *
*            6: Average electricity consumption reduction;                     *
* per outdoor temperature heterogeneity after a flexibility event is initiated *
********************************************************************************
capture program drop Fig_A16_event_power_profile
program Fig_A16_event_power_profile
// Program for the plot of the observed and counterfactual power profiles during a flexibility event 

	args bin_value

	// Calculate optimal BW for average intervention curve (hp_p)
	lpoly hp_p five_min_level_elapsed if (before == 1 | after == 1) & event_bin == `bin_value', degree(0)
	local bw_hp_p = r(bwidth)

	// Calculate the optimal BW for average control curve (cf_avg_bin_spec)
	lpoly cf_avg_bin_spec five_min_level_elapsed if (before == 1 | after == 1) & event_bin == `bin_value', degree(0)
	local bw_cf = r(bwidth)

	// Smooth the CIs for the control curve using the BW calculated above
	capture drop UL_cf_sm 
	capture drop LL_cf_sm
	capture drop at_values

	gen at_values = . 
	replace at_values = five_min_level_elapsed if (before == 1 | after == 1) & event_bin == `bin_value'

		// UL
		lpoly ul_cf five_min_level_elapsed if !missing(at_values), at(at_values) gen(UL_cf_sm) degree(0) bw(`bw_cf')

		// LL
		lpoly ll_cf five_min_level_elapsed if !missing(at_values), at(at_values) gen(LL_cf_sm) degree(0) bw(`bw_cf')

	drop at_values

	// Smooth the CIs for the intervention curve using the BW calculated above
	capture drop UL_sm_before 
	capture drop LL_sm_before
	capture drop UL_sm_after 
	capture drop LL_sm_after

	// Before: 
	capture drop at_values

	gen at_values = . 
	replace at_values = five_min_level_elapsed if before == 1 & event_bin == `bin_value'

			// UL 
			lpoly ul five_min_level_elapsed if !missing(at_values), at(at_values) gen(UL_sm_before) degree(0) bw(`bw_hp_p')

			// LL
			lpoly ll five_min_level_elapsed if !missing(at_values), at(at_values) gen(LL_sm_before) degree(0) bw(`bw_hp_p')

	drop at_values

	// After: 
	capture drop at_values

	gen at_values = . 
	replace at_values = five_min_level_elapsed if after == 1 & event_bin == `bin_value'

			// UL 
			lpoly ul five_min_level_elapsed if !missing(at_values), at(at_values) gen(UL_sm_after) degree(0) bw(`bw_hp_p')

			// LL
			lpoly ll five_min_level_elapsed if !missing(at_values), at(at_values) gen(LL_sm_after) degree(0) bw(`bw_hp_p')

	drop at_values
	
	// Plot the graph
	twoway ///
		lpoly hp_p five_min_level_elapsed if before == 1 & event_bin == `bin_value',  clcolor(blue)  bw(`bw_hp_p') ///
		|| lpoly hp_p five_min_level_elapsed if after == 1  & event_bin == `bin_value',  clcolor(blue)  bw(`bw_hp_p') ///
		|| rarea UL_sm_before LL_sm_before five_min_level_elapsed if before == 1 & event_bin == `bin_value', sort fcolor(blue%30) lcolor(blue%0) ///
		|| rarea UL_sm_after LL_sm_after five_min_level_elapsed if after == 1 & event_bin == `bin_value', sort fcolor(blue%30) lcolor(blue%0) ///
		|| lpoly cf_avg_bin_spec five_min_level_elapsed if (before == 1 | after == 1) & event_bin == `bin_value', clcolor(green) bw(`bw_cf') ///
		|| rarea UL_cf_sm LL_cf_sm five_min_level_elapsed if (before == 1 | after == 1) & event_bin == `bin_value', sort fcolor(green%30) lcolor(green%0) ///
		aspectratio(1) xline(0, lwidth(thin) lcolor(gray)) xlabel(-360 "-6" 0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48" ) ///
		xtitle("Time to flexibility event start (h)") ylabel(0(100)1500) ytitle("Average HP power in the fleet (W)") ///
		legend(off) ///
		graphregion(color(white) margin(zero)) xsize(8) ysize(8) 

	// Label the plot accordingly:
	if `bin_value' == 1 {
    local bin_label "top_left"
	}
	else if `bin_value' == 2 {
		local bin_label "top_right"
	}
	else if `bin_value' == 3 {
		local bin_label "bottom_left"
	}
	else if `bin_value' == 4 {
		local bin_label "bottom_right"
	}
		
	// Export the plot
	graph export "Fig_A16_`bin_label'.pdf", replace	height(8) width(8)

	// Clean up variables
	drop UL_cf_sm LL_cf_sm UL_sm_before LL_sm_before UL_sm_after LL_sm_after

end

capture program drop Fig_A17_event_power_reduction
program Fig_A17_event_power_reduction
// Program for the plot of the net power reduction during a flexibility event 

	args bin_value

	// Calculate optimal BW for average power_reduction curve (hp_p)
	lpoly power_reduction five_min_level_elapsed if event_bin == `bin_value', degree(0) 
	local bw_power = r(bwidth)

	// Smooth the CIs for the control curve using the BW calculated above
	capture drop ul_power_reduction_sm
	capture drop ll_power_reduction_sm

	capture drop at_values

	gen at_values = . 
	replace at_values = five_min_level_elapsed if event_bin == `bin_value'

		// UL
		lpoly ul_power_reduction five_min_level_elapsed if !missing(at_values), gen(ul_power_reduction_sm) at(at_values) degree(0) bw(`bw_power') 

		// LL
		lpoly ll_power_reduction five_min_level_elapsed if !missing(at_values), gen(ll_power_reduction_sm) at(at_values) degree(0) bw(`bw_power')

	drop at_values

	//  Plot the graph
	twoway lpoly power_reduction five_min_level_elapsed if event_bin == `bin_value', bw(`bw_power') clcolor(orange) yline(0) ///
		|| rarea ul_power_reduction_sm ll_power_reduction_sm five_min_level_elapsed if event_bin == `bin_value', sort color(orange%30) lcolor(orange%0) ///
		xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") ylabel(-900(100)900) ///
		xtitle("Time to flexibility event start (h)") ytitle("Average HP power reduction in the fleet (W)") legend(off) ///
		graphregion(color(white) margin(zero)) xsize(8) ysize(8)
	
	// Label the plot accordingly:
	if `bin_value' == 1 {
    local bin_label "top_left"
	}
	else if `bin_value' == 2 {
		local bin_label "top_right"
	}
	else if `bin_value' == 3 {
		local bin_label "bottom_left"
	}
	else if `bin_value' == 4 {
		local bin_label "bottom_right"
	}
		
	// Export the plot
	graph export "Fig_A17_`bin_label'.pdf", replace	height(8) width(8)

	// Clean up variables
	drop ul_power_reduction_sm ll_power_reduction_sm

end

capture program drop Fig_6_event_temp
program define Fig_6_event_temp
// This program plots all curves of Fig. 6

use data_prepared, clear
sort hh_id time

// Temperature heterogeneity: 

    // Classifying the flexibility events 
    capture drop event_bin
    
    gen event_bin = . 
    replace event_bin = 1 if avg_temp_within_18h <= 3 & !missing(avg_temp_within_18h)
    replace event_bin = 2 if avg_temp_within_18h > 3 & avg_temp_within_18h <= 6 & !missing(avg_temp_within_18h)
    replace event_bin = 3 if avg_temp_within_18h > 6 & avg_temp_within_18h <= 9 & !missing(avg_temp_within_18h)
    replace event_bin = 4 if avg_temp_within_18h > 9 & !missing(avg_temp_within_18h)

    // Expanding the bin indicator (for average outdoor temperature within 18h after flexibility event start) in the period before the event and 48h after event start
    capture drop bin_value
    bysort window_unique_index: egen bin_value = max(event_bin)
    replace event_bin = bin_value if window_unique_index != 0 & window_unique_index != .
    drop bin_value
    sort hh_id time
    
    // Classifying the power profiles for counterfactual 
    capture drop cf_bin 

    gen cf_bin = . 
    replace cf_bin = 1 if daily_avg_t_out <= 3
    replace cf_bin = 2 if daily_avg_t_out > 3 & daily_avg_t_out <= 6
    replace cf_bin = 3 if daily_avg_t_out > 6 & daily_avg_t_out <= 9
    replace cf_bin = 4 if daily_avg_t_out > 9

// Generating the temperature-specific counterfactual 

capture drop avg_cf_hp_p_spec_bin
capture drop sem_cf_hp_p_spec_bin

    // Calculating the counterfactual power (specific to each HP and time of day, excluding observations that are too close to the start/end of an intervention)
    preserve
        collapse (mean) avg_cf_hp_p_spec_bin = hp_p, by(hh_id five_min_level_int intervention_dummy excl_from_cf cf_bin)

        drop if intervention_dummy == 1
        drop if excl_from_cf == 1 & intervention_dummy == 0

        drop excl_from_cf intervention_dummy 

        sort hh_id cf_bin five_min_level_int 

        tempfile counterfactuals
        save `counterfactuals', replace
    
    restore

    // Matching the counterfactual with the original dataset 
    merge m:1 hh_id five_min_level_int cf_bin using `counterfactuals'
    drop _merge
    sort hh_id time

preserve

    // Collapsing the observed and counterfactual HP power at the 5 min of intervention level. 
    collapse (mean) hp_p (semean) sem_hp_p = hp_p (mean) cf_avg_bin_spec = avg_cf_hp_p_spec_bin (semean) cf_se_bin_spec = avg_cf_hp_p_spec_bin if !missing(event_bin), by(five_min_level_elapsed event_bin before after)

    // Constructing the 95% CI: reflecting the variability over the different HPs
    gen ul = hp_p + 1.96 * sem_hp_p
    gen ll = hp_p - 1.96 * sem_hp_p

    gen ul_cf = cf_avg_bin_spec + 1.96 * cf_se_bin_spec
    gen ll_cf = cf_avg_bin_spec - 1.96 * cf_se_bin_spec

    drop if after == 0 & before == 0 

    sort event_bin five_min_level_elapsed

    // Plot of the observed and counterfactual power profiles during a flexibility event

    Fig_A16_event_power_profile 1
    Fig_A16_event_power_profile 2
    Fig_A16_event_power_profile 3
    Fig_A16_event_power_profile 4

    // Additional variables for the plot of the net power reduction during a flexibility event

        keep if after == 1

        // Computing the average power reduction (in W) and CIs assuming independence

        capture drop power_reduction
        capture drop se_power_reduction
        capture drop ul_power_reduction 
        capture drop ll_power_reduction 

        gen power_reduction = . 
        replace power_reduction = cf_avg_bin_spec - hp_p 

        gen se_power_reduction = . 
        replace se_power_reduction = sqrt(sem_hp_p^2 + cf_se_bin_spec^2)

        gen ul_power_reduction = . 
        replace ul_power_reduction = power_reduction + 1.96 * se_power_reduction

        gen ll_power_reduction = . 
        replace ll_power_reduction = power_reduction - 1.96 * se_power_reduction

    // Plot of the net power reduction during a flexibility event 

    Fig_A17_event_power_reduction 1
    Fig_A17_event_power_reduction 2
    Fig_A17_event_power_reduction 3
    Fig_A17_event_power_reduction 4

    // Additional variables for the cumulative electricity consumption reduction (kWh) during a flexibility event

        // Computing time difference
        sort event_bin five_min_level_elapsed

        // Time difference between two observations (expressed in hours)
        capture drop hour_level_elapsed
        gen hour_level_elapsed = 0
        by event_bin: replace hour_level_elapsed = (five_min_level_elapsed - five_min_level_elapsed[_n-1]) / 60 if event_bin[_n] == event_bin[_n-1]

        // Time elapsed since intervention start (expressed in hours)
        capture drop hour_into_int
        gen hour_into_int = floor(five_min_level_elapsed/60)
        drop if hour_into_int == 48 // Boundary is irrelevant

        // Computing the amount of electricity saved (expressed in kWh)...
        capture drop instant_net_energy_saved
        capture drop cumulative_net_energy_saved 

        // ...From one observation to the other (i.e. within 5 mins interval)
        gen instant_net_energy_saved = 0 
        by event_bin: replace instant_net_energy_saved = (power_reduction/1000) * hour_level_elapsed  if event_bin[_n] == event_bin[_n-1]

        // ...Cumulative since flexibility event start 
        gen cumulative_net_energy_saved = .
        replace cumulative_net_energy_saved = 0 if _n == 1 | (event_bin[_n] != event_bin[_n-1])
        replace cumulative_net_energy_saved = cumulative_net_energy_saved[_n-1] + instant_net_energy_saved if missing(cumulative_net_energy_saved) 

    // Plot of the cumulative electricity consumption reduction (kWh)  during a flexibility event

    twoway lpoly cumulative_net_energy_saved five_min_level_elapsed if event_bin == 1, degree(0) lcolor("77 147 221") ///
        || lpoly cumulative_net_energy_saved five_min_level_elapsed if event_bin == 2, degree(0) lcolor("75 220 227") ///
        || lpoly cumulative_net_energy_saved five_min_level_elapsed if event_bin == 3, degree(0) lcolor("255 213 18") ///
        || lpoly cumulative_net_energy_saved five_min_level_elapsed if event_bin == 4, degree(0) lcolor("245 59 59")  ///
        legend(order(1 "< 3°C" 2 "3 - 6 °C" 3 "6 - 9 °C" 4 "> 9 °C") size(small) pos(6) cols(2) subtitle("Average outdoor temperature within 18 h" "after flexibility event start", size(small))) ///
        xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ///
        ylabel(0(0.5)5) ytitle("Average electricity consumption" "reduction per HP in the fleet (kWh)") yline(0) ///
        aspectratio(1) graphregion(color(white) margin(zero)) xsize(8) ysize(8)

    graph export "Fig_6.pdf", replace height(8) width(8)

    // Extracting the amount of electricity saved (in kWh) in each hour of the flexibility event for the price analysis

    collapse (sum) avg_hourly_energy_reduction = instant_net_energy_saved, by(hour_into_int event_bin)
    sort event_bin hour_into_int

    export delimited hour_into_int avg_hourly_energy_reduction if event_bin == 1 using "df_hourly_energy_reduction_bin_1", replace
    export delimited hour_into_int avg_hourly_energy_reduction if event_bin == 2 using "df_hourly_energy_reduction_bin_2", replace
    export delimited hour_into_int avg_hourly_energy_reduction if event_bin == 3 using "df_hourly_energy_reduction_bin_3", replace
    export delimited hour_into_int avg_hourly_energy_reduction if event_bin == 4 using "df_hourly_energy_reduction_bin_4", replace

restore

end

********************************************************************************
* Figure 7: average savings per HP and flexibility event in a fleet            *
********************************************************************************
capture program drop Fig_7_both_panels
program define Fig_7_both_panels
// This program plots all panels of Fig. 7

// Preamble

frame change default

capture frame drop monetary_valuation_heterogeneous
frame create monetary_valuation_heterogeneous
frame change monetary_valuation_heterogeneous

import delimited "money_shifted_heterogeneous.csv", clear // Output from 'Building_dataset_monetary_valuation_flex_event.py' (code attached)

drop if temp_heterogeneity_category == "nan"

drop if missing(phase2_avg_money) // Too far into the season, last observations do not even have 36h after the start.

// Text:

pwcorr dam_price temp, sig star(0.05)

ci means phase1_avg_money
ci means phase2_avg_money

pwcorr dam_price temp if temp_heterogeneity_category == "bel3", sig star(0.05)
pwcorr dam_price temp if temp_heterogeneity_category == "b36", sig star(0.05)
pwcorr dam_price temp if temp_heterogeneity_category == "b69", sig star(0.05)
pwcorr dam_price temp if temp_heterogeneity_category == "ab9", sig star(0.05)
	
// Figure 7 - right 

    preserve

    // Manually creating the bins for avg_dam_on_36h
    gen dam_bin = .

    // Define each bin manually
    replace dam_bin = 0.00 if avg_dam_on_36h >= -0.025 & avg_dam_on_36h < 0.025
    replace dam_bin = 0.05 if avg_dam_on_36h >= 0.025 & avg_dam_on_36h < 0.075
    replace dam_bin = 0.10 if avg_dam_on_36h >= 0.075 & avg_dam_on_36h < 0.125
    replace dam_bin = 0.15 if avg_dam_on_36h >= 0.125 & avg_dam_on_36h < 0.175
    replace dam_bin = 0.20 if avg_dam_on_36h >= 0.175 & avg_dam_on_36h < 0.225
    replace dam_bin = 0.25 if avg_dam_on_36h >= 0.225 & avg_dam_on_36h < 0.275
    replace dam_bin = 0.30 if avg_dam_on_36h >= 0.275 & avg_dam_on_36h < 0.325
    replace dam_bin = 0.35 if avg_dam_on_36h >= 0.325 & avg_dam_on_36h < 0.375
    replace dam_bin = 0.40 if avg_dam_on_36h >= 0.375 & avg_dam_on_36h < 0.425
    replace dam_bin = 0.45 if avg_dam_on_36h >= 0.425 & avg_dam_on_36h < 0.475
    replace dam_bin = 0.50 if avg_dam_on_36h >= 0.475 & avg_dam_on_36h <= 0.525
	
    ci means phase1_avg_money if dam_bin == 0.5
    ci means phase2_avg_money if dam_bin == 0.5

    // Generate SEs and CIs after collapsing
    collapse (mean) phase1_avg_money phase2_avg_money (sd) phase1_sd=phase1_avg_money phase2_sd=phase2_avg_money, by(dam_bin)

    // Calculate SEs
    gen phase1_se = phase1_sd / sqrt(_N)
    gen phase2_se = phase2_sd / sqrt(_N)

    // Calculate 95% CI for phase1 (18h) and phase2 (36h)
    gen phase1_ul = phase1_avg_money + 1.96 * phase1_se
    gen phase1_ll = phase1_avg_money - 1.96 * phase1_se  

    gen phase2_ul = phase2_avg_money + 1.96 * phase2_se  
    gen phase2_ll = phase2_avg_money - 1.96 * phase2_se  

    // Plot as bar chart with error bars
    twoway (bar phase1_avg_money dam_bin, barwidth(0.05) lcolor(blue%35) bfcolor(blue%35)) ///
        (bar phase2_avg_money dam_bin, barwidth(0.05) lcolor(orange%35) bfcolor(orange%35)) ///
        (rcap phase1_ll phase1_ul dam_bin, lcolor(blue)) ///
        (rcap phase2_ll phase2_ul dam_bin, lcolor(orange)) ///
        (scatter phase1_avg_money dam_bin, color(blue)) ///
        (scatter phase2_avg_money dam_bin, color(orange) ///
        ylabel(0(0.25)2.25) xlabel(0(0.05)0.5) ///
        legend(order(1 "18 h after flexibility event start" 2 "36 h after flexibility event start") pos(6) size(medsmall)) aspectratio(1) ///
        xtitle("Average day-ahead price within 36 h" "after flexibility event start (€/kWh)") ///
        ytitle("Average savings per event" "and HP in the fleet (€)") graphregion(color(white) margin(zero)) xsize(8) ysize(8))

    graph export "Fig_7_right.pdf", replace width(8) height(8)

    restore

// Figure 7 - left:

    capture drop rank*
    capture drop time_share*
	
	sum phase1_avg_money
    local phase1_avg_money_mean = r(mean)
    sum phase2_avg_money
    local phase2_avg_money_mean = r(mean)

    // Calculate percentiles for phase1_avg_money and phase2_avg_money
    egen rank1 = rank(phase1_avg_money), unique
    egen rank2 = rank(phase2_avg_money), unique

    // Convert ranks to percentiles (share of time)
    gen time_share1 = (rank1 / _N) * 100
    gen time_share2 = (rank2 / _N) * 100

    // Plot both phase1_avg_money and phase2_avg_money against their respective time shares
    twoway line phase1_avg_money time_share1, sort lcolor(blue) ///
        || line phase2_avg_money time_share2, sort lcolor(orange) ///
        xlabel(0(10)100) ylabel(-0.5(0.25)2.25) yline(0) ///
        xtitle("Share of time in HS1 and HS2 (%)") ytitle("Average savings" "per event and HP in the fleet (€)") ///
        legend(label(1 "18 h after flexibility event start") label(2 "36 h after flexibility event start") pos(6) size(medsmall) ) ///
        aspectratio(1) graphregion(color(white) margin(zero)) xsize(8) ysize(8) ///
		yline(`phase1_avg_money_mean', lcolor(blue) lwidth(1.5 pt)) ///
		yline(`phase2_avg_money_mean', lcolor(orange) lwidth(1.5 pt))

    graph export "Fig_7_left.pdf", replace width(8) height(8)
	
	// Text: 
	
	ci means phase2_avg_money if time_share2 >= 90
	ci means phase2_avg_money if time_share2 >= 95
	ci means phase2_avg_money if time_share2 >= 99
	sum phase2_avg_money
    sum phase2_avg_money if phase2_avg_money <= 0

	keep if time_share2 >= 95 // Mostly Nov - Dec 2022: energy crisis
	
	frame change default

end

********************************************************************************
* Figure 8: average payback period of installing a smart thermostat  -         *
********************************************************************************
capture program drop aggregator_optimal_allocation
program define aggregator_optimal_allocation
// This program performs the aggregator's optimal allocation explained in the text
// Must specify two arguments: the number of yearly events ; then the HS index
    args num_events hs_filter
    
    frame change default

    capture frame drop monetary_valuation_heterogeneous
    frame create monetary_valuation_heterogeneous
    frame change monetary_valuation_heterogeneous

    import delimited "money_shifted_heterogeneous.csv", clear // Import dataset

    drop if temp_heterogeneity_category == "nan"
    drop if missing(phase2_avg_money) // Remove observations without 36h worth of observations after the start

    // Convert time variable to Stata time format
    gen double event_time = clock(time, "YMDhms")
    format event_time %tc
    drop time
    rename event_time time

    // Assign heating season labels
    gen hs = 0
    replace hs = 1 if time >= clock("2022-11-14 00:00:00", "YMDhms") - 7 * 24 * 60 * 60 * 1000 ///
                      & time <= clock("2023-04-15 23:59:59", "YMDhms") + 7 * 24 * 60 * 60 * 1000

    replace hs = 2 if time >= clock("2023-10-30 00:00:00", "YMDhms") - 7 * 24 * 60 * 60 * 1000 ///
                      & time <= clock("2024-03-24 23:59:59", "YMDhms") + 7 * 24 * 60 * 60 * 1000

    // Apply filtering based on `hs_filter`
    if `hs_filter' == 1 {
        drop if hs == 2  // Keep only HS1
    }
    if `hs_filter' == 2 {
        drop if hs == 1  // Keep only HS2
    }

    // Define frame name dynamically
    local frame_name = "selected_events_`hs_filter'"

    // Drop and create the corresponding frame
    capture frame drop `frame_name'
    frame create `frame_name'
    frame `frame_name' { // Generate the frame with the correct number of observations
        clear
        set obs `num_events'
        gen n = .
        gen net_savings = .
    }
    
    preserve // preserve frame monetary_valuation_heterogeneous
    
    // Sort by descending phase2_avg_money
    gsort -phase2_avg_money time

    local k = 1
    while `k' <= `num_events' & _N > 0 {
        
        // Select the top event
        local top_event_time = time[1]
        local top_phase2 = phase2_avg_money[1]
        
        // Store in the selected frame
        frame `frame_name' {
            replace n = `k' in `k'
            replace net_savings = `top_phase2' in `k'
        }
        
        // Remove all observations within 48 hours of the selected event
        drop if abs(time - `top_event_time') < 48 * 3600000  // 48 hours in milliseconds
        
        // Re-sort to get the next highest value before starting the loop over
        gsort -phase2_avg_money time
        
        local ++k
    }
    
    restore
    frame change default
end

capture program drop merge_selected_events
program define merge_selected_events 
// This program merges the aggregator's optimal allocation into a single dataset for convenience

frame change default

capture frame drop merged_selected_events
frame create merged_selected_events
frame change merged_selected_events

frame selected_events_1 {
    rename net_savings net_savings_HS1
    tempfile f1
    save `f1'
}

frame selected_events_2 {
    rename net_savings net_savings_HS2
    tempfile f2
    save `f2'
}

// Load the first dataset into the new frame
use `f1', clear

// Merge other datasets based on "n"
merge 1:1 n using `f2', nogen

// Save the merged dataset
save "merged_selected_events.dta", replace

frame change merged_selected_events

// Load the merged dataset
use "merged_selected_events.dta", clear

end

capture program drop calculation_for_Fig_8
program define calculation_for_Fig_8
// This program works on a dataset of an optimal allocation of flexibility events and then calculates the cumulative savings and payback period. 
// Must specify two groups of arguments: first for thermostat costs, second for discount rates expressed in percentage points
    args tc_group r_group

    // Switch to the appropriate frame
    frame change merged_selected_events

    // Generate cumulative sums of economic gains from flex events (if not already done)
    capture drop C_n_HS1
    capture drop C_n_HS2
    gen C_n_HS1 = sum(net_savings_HS1)
    gen C_n_HS2 = sum(net_savings_HS2)

    // Loop over each thermostat cost in the first group
    foreach tc of local tc_group {
        // No discounting: calculate payback period variables for HS1 and HS2
        capture drop PP_r0_`tc'_HS1
        capture drop PP_r0_`tc'_HS2
        gen PP_r0_`tc'_HS1 = `tc' / C_n_HS1
        gen PP_r0_`tc'_HS2 = `tc' / C_n_HS2

        // Now loop over each discount rate in the second group
        foreach r of local r_group {
            // Calculate the discount factor ρ = 1/(1+r)
            local rho = 1 / (1 + (`r'/100))
            // Discounting case for HS1 and HS2
            capture drop PP_r`r'_`tc'_HS1
            capture drop PP_r`r'_`tc'_HS2
            gen PP_r`r'_`tc'_HS1 = (log((`tc' / C_n_HS1 ) * (`rho' - 1) + 1) / log(`rho')) - 1
            gen PP_r`r'_`tc'_HS2 = (log((`tc' / C_n_HS2 ) * (`rho' - 1) + 1) / log(`rho')) - 1
        }
    }
end

capture program drop interpolate_crossing_for_Fig_8
program define interpolate_crossing_for_Fig_8, rclass
// This function is purely 'cosmetic'. It interpolates the data for each curve to find the point where it crosses the y-axis = 100, as 
// we cut the plot at y = 100. Of course, if the curve already starts below y-axis = 100, because the logarithm is not defined for those
// points, then no interpolation is done. In practice it means: no interpolation for discounted plots. 

    syntax varname, thresh(real)
    
    local var "`varlist'"
    di "Interpolating crossing for variable `var' at threshold `thresh'"
	    
    * Create markers for transition:
    capture drop A_`var' 
	capture drop B_`var'
    gen A_`var' = 0
    replace A_`var' = 1 if `var' > `thresh' & `var'[_n+1] < `thresh' & !missing(`var') // This line means the dataset should not be sorted before fully finished with the program calls, otherwise the inserted observations interfere with the condition "`var'[_n+1] < `thresh'"...

    gen  B_`var' = 0
    replace  B_`var' = 1 if `var' < `thresh' & `var'[_n-1] > `thresh' & !missing(`var') // Same

    * Extract values from the observation with A==1 (last above threshold)
    su `var' if A_`var'==1
    local yA = r(mean)
    su n if A_`var'==1
    local nA = r(mean)
    
    * Extract values from the observation with B==1 (first below threshold)
    su `var' if B_`var'==1
    local yB = r(mean)
    su n if B_`var'==1
    local nB = r(mean)
    
    * Calculate the slope and intercept between the two points
    local m = (`yB' - `yA') / (`nB' - `nA')
    local p = `yA' - `m' * `nA'
    
    * Solve for the x-value (n) where `var' equals the threshold
    local xthresh = (`thresh' - `p') / `m'
    di "The interpolated crossing occurs at n = " `xthresh' " with yA = " `yA' " and yB = " `yB' " and m = " `m' " and p = " `p'
    
    * Create the indicator variable if it doesn't already exist
    capture drop pl_`var'
	gen pl_`var' = .
 
	insobs 1
    
    * Replace the newly inserted observation (last obs) with the interpolated values
    replace n = `xthresh' in L
    replace `var' = `thresh' in L
    replace pl_`var' = 1 in L
	    	
	replace pl_`var' = 1 if missing(pl_`var') & (n > `xthresh' & !missing(`var'))
	
end

capture program drop Fig_8_both_panels
program define Fig_8_both_panels
// This program plots all panels of Fig. 8 (with and without discounting)

// First we perform the optimal allocation of 50 events per HS 
	aggregator_optimal_allocation 50 1
	aggregator_optimal_allocation 50 2

// Second we merge these events into a single dataset
	merge_selected_events

// Third we clean this dataset and compute the cumulative yearly savings and the payback period
	// Assuming a "vector" of smart thermostat prices and a vector of discount rates expressed in percentage points

	calculation_for_Fig_8 "120 160 200" "3 5 7"

// Fourth we have to interpolate the starting points of the curves when the graph is 'cut' at y_threshold = 100 
// We only do that for non-discounted curves, as discounted curves already start below the threshold. 
// See the explanation in the program interpolate_crossing_for_Fig_8.

local threshold = 100
sort n 

// r = 0%
	// HS1: 
	interpolate_crossing_for_Fig_8 PP_r0_120_HS1, thresh(`threshold')
	interpolate_crossing_for_Fig_8 PP_r0_160_HS1, thresh(`threshold')
	interpolate_crossing_for_Fig_8 PP_r0_200_HS1, thresh(`threshold')

	// HS2: 

	interpolate_crossing_for_Fig_8 PP_r0_120_HS2, thresh(`threshold')
	interpolate_crossing_for_Fig_8 PP_r0_160_HS2, thresh(`threshold')
	interpolate_crossing_for_Fig_8 PP_r0_200_HS2, thresh(`threshold')
	
// Fifth: plots

	// r = 0%:

		twoway ///
		(line PP_r0_120_HS1 n if pl_PP_r0_120_HS1 == 1, lcolor(blue%35) lwidth(medium) lp(shortdash) sort) ///
		(line PP_r0_160_HS1 n if pl_PP_r0_160_HS1 == 1, lcolor(blue) lwidth(medium) sort) ///
		(line PP_r0_200_HS1 n if pl_PP_r0_200_HS1 == 1, lcolor(blue%35) lwidth(medium) lp(dash)  sort) ///
		(line PP_r0_120_HS2 n if pl_PP_r0_120_HS2 == 1, lcolor(orange%35) lwidth(medium) lp(shortdash) sort) ///
		(line PP_r0_160_HS2 n if pl_PP_r0_160_HS2 == 1, lcolor(orange) lwidth(medium) sort) ///
		(line PP_r0_200_HS2 n if pl_PP_r0_200_HS2 == 1, lcolor(orange%35) lwidth(medium) lp(dash)  sort), ///
		xlabel(0(5)50) ylabel(0 10 20 30 40 50 60 70 80 90 100) yline(0)  ///
		yscale(range(0 100) noextend ) ///
		xtitle("Number of flexibility events per heating season") ///
		ytitle("Payback period of making a HP flexible (years)") ///
		legend(order(- "HS1" - "Investment cost for" "making HP flexible:" 1  "             €120             " 2 "             €160             " 3 "             €200             " - "HS2" - " "  4 " " 5 " " 6 " ") pos(6) col(2) rows(5) colfirst   size(medsmall) symxsize(18)  keygap(0) ) ///
		graphregion(color(white)) xsize(8) ysize(11)
		
		graph save "Graph" "Fig_8_left_legend_non_edited.gph", replace
		// Then a bit of work with Stata's graph editor is needed to align the legend labels and add text "r=0%" top right corner. 
		graph export "Fig_8_left_legend_non_edited.pdf", replace 
		
	// r = 5%:

		twoway ///
		(line PP_r5_120_HS1 n , lcolor(blue%35) lwidth(medium) lp(shortdash) sort) ///
		(line PP_r5_160_HS1 n , lcolor(blue) lwidth(medium) sort) ///
		(line PP_r5_200_HS1 n, lcolor(blue%35) lwidth(medium) lp(dash)  sort) ///
		(line PP_r5_120_HS2 n , lcolor(orange%35) lwidth(medium) lp(shortdash) sort) ///
		(line PP_r5_160_HS2 n , lcolor(orange) lwidth(medium) sort) ///
		(line PP_r5_200_HS2 n , lcolor(orange%35) lwidth(medium) lp(dash)  sort), ///
		xlabel(0(5)50) ylabel(0 10 20 30 40 50 60 70 80 90 100) yline(0)  ///
		yscale(range(0 100) noextend ) ///
		xtitle("Number of flexibility events per heating season") ///
		ytitle("Payback period of making a HP flexible (years)") ///
		legend(order(- "HS1" - "Investment cost for" "making HP flexible:" 1  "             €120             " 2 "             €160             " 3 "             €200             " - "HS2" - " "  4 " " 5 " " 6 " ") pos(6) col(2) rows(5) colfirst   size(medsmall) symxsize(18)  keygap(0) ) ///
		graphregion(color(white)) xsize(8) ysize(11)
	 
		graph save "Graph" "Fig_8_right_legend_non_edited.gph", replace
		// Then a bit of work with Stata's graph editor is needed to align the legend labels and add text "r=5%" top right corner. 
		graph export "Fig_8_right_legend_non_edited.pdf", replace 
		 
		 
// Figure A.18: cumulative savings: 

	// We add an observation for the zero of the graph: 0 event = 0 savings. 
		
	insobs 1
	replace n = 0 in L
	replace C_n_HS1 = 0 in L
	replace C_n_HS2 = 0 in L	    	
		
	// Plot:

	twoway ///
	(line C_n_HS1 n, lcolor(blue) lwidth(medium) sort) ///
	(line C_n_HS2 n, lcolor(orange) lwidth(medium) sort), ///
	xlabel(0(5)50) ylabel(0(2)18) yline(0)  ///
		xtitle("Number of flexibility events per heating season") ///
		ytitle("Cumulative savings per heating season" "and HP from flexibility events (€)") ///
		legend(order(1 "HS1" 2 "HS2") pos(6) col(2) colfirst   size(medsmall) ) ///
		graphregion(color(white)) xsize(8) ysize(8)
		
	graph export "Fig_A18.pdf", replace 
	
erase merged_selected_events.dta

// Text:

sum C_n_HS1 if n == 50
sum C_n_HS2 if n == 50

end

********************************************************************************
* Section 4.3.1: statements in the text with respect to overrules	           *
********************************************************************************
capture program drop overrules_temperatures
program overrules_temperatures

use data_prepared, clear 
ci means t_in if reason_stop != 0 & reason_stop != -1 & reason_stop != -2

use presurvey_data, clear
sum Q13_1
tab hh_id Q13_1

use data_prepared, clear
di "Indoor temperature at overrule (non-preemptive) ; household 9:"
sum t_in if reason_stop != 0 & reason_stop != -1 & reason_stop != -2 & reason_stop != -3.1 & hh_id == 9
di "Indoor temperature at overrule (non-preemptive) ; households 2, 3, 5, 6:"
sum t_in if reason_stop != 0 & reason_stop != -1 & reason_stop != -2 & reason_stop != -3.1 & (hh_id == 2 | hh_id == 3 | hh_id == 5 | hh_id == 6)

end

********************************************************************************
* Figure 9: Histogram of temperature drop							           *
********************************************************************************
capture program drop F9_hist_temp_drop
program F9_hist_temp_drop 
// This program plots Figure 9.

use data_prepared, clear
sort hh_id time

frame change default

// Identify interventions that were manually overruled 

capture drop manually_overruled_during_int
gen manually_overruled_during_int = 0 if reason_stop != 0 & reason_stop != -3
replace manually_overruled_during_int = 1 if reason_stop == -3

// Temperature drop by the intervention as a proxy for discomfort 

capture drop temperature_drop 
gen temperature_drop = t_in_0 - t_in

// Correlations: 

pwcorr temperature_drop t_in_0 total_duration_int_hour avg_temp_during_int if reason_stop == -1 | reason_stop == -2, sig star(0.05) obs

ci means temperature_drop if reason_stop != 0 

wildbootstrap reg temperature_drop manually_overruled_during_int i.hh_id if reason_stop != 0 & hh_id != 1 & hh_id != 2 & hh_id != 8 , cluster(hh_id) rseed(42) reps(100000) // Household-fixed effects


// Testing whether temperature drop is higher for manually overruled interventions 

ttest temperature_drop if reason_stop != 0 , by(manually_overruled_during_int) une

ttest t_in, by(intervention_dummy) une // for comparison 

// Testing whether participants consistently overrule higher temperature drop 

pwcorr manually_overruled_during_int temperature_drop if reason_stop != 0, sig star(0.05) o

// Figure 9: histogram 

sum temperature_drop if manually_overruled_during_int == 0
local avg_drop_auto = r(mean)

sum temperature_drop if manually_overruled_during_int == 1
local avg_drop_manu = r(mean)

twoway (hist temperature_drop if manually_overruled_during_int == 0 & temperature_drop > -1 & temperature_drop < 3.5, density width(0.25) start(-1) color(blue%35)) ///        
       (hist temperature_drop if manually_overruled_during_int == 1 & temperature_drop > -1 & temperature_drop < 3.5, density width(0.25) start(-1) color(orange%35)), ///   
       legend(order(1 "Automatically stopped interventions (n = 240)" 2 "Manually overruled interventions (n = 46)") ///
       size(small) cols(1) pos(6)) xtitle("Temperature drop per intervention (°C)") xlabel(-1(0.5)3) ///
       xline(`avg_drop_auto', lwidth(medthin) lcolor(blue)) xline(`avg_drop_manu', lwidth(medthin) lcolor(orange)) ///
       aspectratio(1) xsize(8) ysize(8) graphregion(color(white) margin(zero))

graph export "Fig_9.pdf", replace width(8) height(8)

end

********************************************************************************
* Section 4.3.3: post-experiment survey  							           *
********************************************************************************
capture program drop postexperiment_survey
program postexperiment_survey

use postsurvey_data, clear 
sort hh_id 

sum comfort_t_in 
sum comfort_t_dhw

sum importance_notification
sum importance_override

tab strategy_discomfort

end

********************************************************************************
********************************************************************************
**                                                                            **
**                                 APPENDICES                                 **
**              														      **
********************************************************************************
********************************************************************************

********************************************************************************
* Appendix A: Additional figures and tables			     			           *
********************************************************************************

* Table A.4: Average monthly temperatures during the experimental period
capture program drop App_A1_Table_A4
program define App_A1_Table_A4

use data_prepared, clear
sort hh_id time

local months 10 11 12 1 2 3 4

foreach month of local months {
    qui sum monthly_avg_hs if monthofyear == `month' & hs_index == 1
    local mean_hs1 = round(r(mean), 0.1)
    quietly summarize monthly_avg_hs if monthofyear == `month' & hs_index == 2
    local mean_hs2 = round(r(mean), 0.1)

    di "Average monthly mean temperature for month `month' is `mean_hs1' (HS1) ; `mean_hs2' (HS2)"

}

capture drop hs_mean
egen hs_mean = mean(daily_avg_t_out) if hs1_window == 1 | hs2_window == 1, by(hs_index)

end

* Table A.5: Sample composition
capture program drop App_A2_Table_A5
program define App_A2_Table_A5

use data_prepared, clear
sort hh_id time

// Who is decoupled? 

tab hh_id decoupled

// How many interventions for each HH? 

qui levelsof hh_id, local(hh)

local total_unique = 0

foreach label of local hh {
    qui distinct unique_index if hh_id == `label' & unique_index != 0 & reason_stop != 0 
    local unique_count = r(ndistinct)
    di "`label' has " `unique_count' " unique values of unique_index (i.e. interventions)"
    
    local total_unique = `total_unique' + `unique_count'
}

di "Total unique values of unique_index (i.e. interventions) across all HHs: " `total_unique'

// How many manual overrules for each HH?

qui levelsof hh_id, local(hh)

local total_unique = 0

foreach label of local hh {
    qui distinct unique_index if hh_id == `label' & unique_index != 0 & reason_stop != 0 & reason_stop != -1 & reason_stop != -2
    local unique_count = r(ndistinct)
    di "`label' has " `unique_count' " unique values of manual overrules"
    
    local total_unique = `total_unique' + `unique_count'
}

di "Total manual overrules across all HHs: " `total_unique'

// How many in HS1? 

preserve

keep if hs_index == 1

qui levelsof hh_id, local(hh)

local total_unique = 0

qui foreach label of local hh {
    qui distinct unique_index if hh_id == `label' & unique_index != 0 & reason_stop != 0 
    local unique_count = r(ndistinct)
    di "`label' has " `unique_count' " unique values of unique_index (i.e. interventions)"
    
    local total_unique = `total_unique' + `unique_count'
}

di "Total unique values of unique_index (i.e. interventions) across all HHs in HS1: " `total_unique'

restore 

// How many in HS2? 

preserve

keep if hs_index == 2

qui levelsof hh_id, local(hh)

local total_unique = 0

qui foreach label of local hh {
    qui distinct unique_index if hh_id == `label' & unique_index != 0 & reason_stop != 0 
    local unique_count = r(ndistinct)
    di "`label' has " `unique_count' " unique values of unique_index (i.e. interventions)"
    
    local total_unique = `total_unique' + `unique_count'
}

di "Total unique values of unique_index (i.e. interventions) across all HHs in HS2: " `total_unique'

restore 

end

* Fig. A.10: Histograms of indoor temperature and heat pump power in non-intervention period
capture program drop App_A3_Fig_A10
program define App_A3_Fig_A10

use data_prepared, clear
sort hh_id time

// Right panel: histogram of heat pump power

sum hp_p if excl_from_cf == 0
local avg_hp_p = r(mean)

hist hp_p if intervention_dummy == 0 & hp_p <= 1500, width(50) xtitle("Heat pump power (W)")  note("In non-intervention and non-rebound periods.") xline(`avg_hp_p', lcolor(edkblue) lwidth(1.5 pt)) ///
 graphregion(color(white) margin(zero))  xsize(5) ysize(5) color(blue%35) xlabel(0(250)1500)

graph export "Fig_A10_left.pdf", width(8) height(8) replace

// Right panel: histogram of indoor temperature

sum t_in if excl_from_cf == 0
local avg_t_in = r(mean)

hist t_in if intervention_dummy == 0 & (hs1_window == 1 | hs2_window == 1) & t_in > 16 & t_in <= 26, width(.5) xtitle("Indoor temperature (°C)") note("In non-intervention and non-rebound periods.") xline(`avg_t_in', lcolor(edkblue) lwidth(1.5 pt)) ///
 graphregion(color(white) margin(zero))  xsize(5) ysize(5) color(blue%35) xlabel(16(1)26)

graph export "Fig_A10_right.pdf", width(8) height(8) replace

end

* Fig. A.11: Average heat pump daily profile (entire heat pump sample)
capture program drop App_A4_Fig_A11
program define App_A4_Fig_A11

use data_prepared, clear
sort hh_id time

preserve

    // Collapse of hp_p on five_min_level_int, intervention_dummy and excl_from_cf (to exclude these observations from the counterfactual)
    collapse (mean) hp_p (semean) sem_hp_p = hp_p, by(five_min_level_int intervention_dummy excl_from_cf ) 
    sort intervention_dummy five_min_level_int

    // Exclude observations that are too close to the start/end of an intervention from the counterfactual calculation
    drop if excl_from_cf == 1 & intervention_dummy == 0

    // Generate the 95% CI
    capture drop ul
    capture drop ll 

    gen ul = hp_p + 1.96 * sem_hp_p
    gen ll = hp_p - 1.96 * sem_hp_p

    // Smoothing of the UL and LL (the BW comes from the local polynomial smoothing of the average)

        // Control: 

            capture drop ul_avg_hp_p_5min_control_smooth
            capture drop ll_avg_hp_p_5min_control_smooth

            lpoly ul five_min_level_int if intervention_dummy == 0, degree(0) gen(ul_avg_hp_p_5min_control_smooth) at(five_min_level_int)
            lpoly ll five_min_level_int if intervention_dummy == 0, degree(0) gen(ll_avg_hp_p_5min_control_smooth) at(five_min_level_int)

        // Intervention: 

            capture drop ul_avg_hp_p_5min_inter_smooth
            capture drop ll_avg_hp_p_5min_inter_smooth

            lpoly ul five_min_level_int if intervention_dummy == 1, degree(0) gen(ul_avg_hp_p_5min_inter_smooth) at(five_min_level_int)
            lpoly ll five_min_level_int if intervention_dummy == 1, degree(0) gen(ll_avg_hp_p_5min_inter_smooth) at(five_min_level_int)

    // Plot Fig. 2

        twoway lpoly hp_p five_min_level_int if intervention_dummy == 0, clcolor(green) degree(0) ///
            || rarea ul_avg_hp_p_5min_control_smooth ll_avg_hp_p_5min_control_smooth five_min_level_int, sort  fcolor(green%30) lcolor(green%0) ///
            || lpoly hp_p five_min_level_int if intervention_dummy == 1, clcolor(blue) degree(0) ///
            || rarea ul_avg_hp_p_5min_inter_smooth ll_avg_hp_p_5min_inter_smooth five_min_level_int, sort fcolor(blue%30) lcolor(blue%0) ///
            aspectratio(1) xlabel(0 "0" 72 "6" 144 "12" 216 "18" 288 "24") xtitle("Time of day (h)") ///
            ylabel(0(100)600) ytitle("Average HP power consumption (W)") ///
            legend(order(1 "Non-intervention" 2 "95% CI" 3 "Intervention" 4 "95% CI") cols(2) pos(6) size(medsmall))  graphregion(color(white) margin(zero))  xsize(8) ysize(8) 

        graph export "Fig_A11.pdf", width(8) height(8) replace

restore

end

* Fig. A.12: Comparison of average heat pump daily profiles across different outdoor temperature ranges
capture program drop App_A5_Fig_A12
program define App_A5_Fig_A12

use data_prepared, clear
sort hh_id time

// Temperature heterogeneity: 

    // Classifying the power profiles for counterfactual 
    capture drop cf_bin 

    gen cf_bin = . 
    replace cf_bin = 1 if daily_avg_t_out <= 3
    replace cf_bin = 2 if daily_avg_t_out > 3 & daily_avg_t_out <= 6
    replace cf_bin = 3 if daily_avg_t_out > 6 & daily_avg_t_out <= 9
    replace cf_bin = 4 if daily_avg_t_out > 9


preserve

    // Collapse of hp_p on five_min_level_int, intervention_dummy and excl_from_cf (to exclude these observations from the counterfactual)
    collapse (mean) hp_p (semean) sem_hp_p = hp_p, by(five_min_level_int intervention_dummy excl_from_cf cf_bin) 
    sort intervention_dummy five_min_level_int

    // Exclude observations during interventions or those that are too close to the start/end of an intervention from the counterfactual calculation
    drop if excl_from_cf == 1 & intervention_dummy == 0
    drop if intervention_dummy == 1 

    // Generate the 95% CI
    capture drop ul
    capture drop ll 

    gen ul = hp_p + 1.96 * sem_hp_p
    gen ll = hp_p - 1.96 * sem_hp_p

        // Loop over each cf_bin value to smooth UL and LL for control and intervention groups
        forvalues bin_value = 1/4 {
            // Control group smoothing
            capture drop ul_cont_sm_bin`bin_value'
            capture drop ll_cont_sm_bin`bin_value'
            capture drop at_values

            gen at_values = .
            replace at_values = five_min_level_int if intervention_dummy == 0 & cf_bin == `bin_value'

            lpoly ul five_min_level_int if !missing(at_values), at(at_values) gen(ul_cont_sm_bin`bin_value') degree(0)
            lpoly ll five_min_level_int if !missing(at_values), at(at_values) gen(ll_cont_sm_bin`bin_value') degree(0)

            drop at_values
        }

    // Plot Fig. 12

    twoway lpoly hp_p five_min_level_int if cf_bin == 1, lcolor("77 147 221") degree(0) bw(`selected_BW_HP_P_bel3') ///
        || rarea ul_cont_sm_bin1 ll_cont_sm_bin1 five_min_level_int, sort fcolor("77 147 221%30") lcolor("77 147 221%0") ///
        || lpoly hp_p five_min_level_int if cf_bin == 2, lcolor("75 220 227") degree(0) bw(`selected_BW_HP_P_b36') ///
        || rarea ul_cont_sm_bin2 ll_cont_sm_bin2 five_min_level_int, sort fcolor("75 220 227%30") lcolor("75 220 227%0") ///
        || lpoly hp_p five_min_level_int if cf_bin == 3, lcolor("255 213 18") degree(0) bw(`selected_BW_HP_P_b69') ///
        || rarea ul_cont_sm_bin3 ll_cont_sm_bin3 five_min_level_int, sort fcolor("255 213 18%30") lcolor("255 213 18%0") ///
        || lpoly hp_p five_min_level_int if cf_bin == 4, lcolor("245 59 59") degree(0) bw(`selected_BW_HP_P_ab9') ///
        || rarea ul_cont_sm_bin4 ll_cont_sm_bin4 five_min_level_int, sort fcolor("245 59 59%30") lcolor("245 59 59%30") ///
        xlabel(0 "0" 72 "6" 144 "12" 216 "18" 288 "24") xtitle("Time of day (h)") aspectratio(1) ///
        ylabel(0(200)1200) ytitle("Average HP power consumption (W)") ///
        legend(order(1 "< 3°C" 3 "3 to 6 °C" 5 "6 to 9 °C" 7 "> 9 °C") cols(2) pos(6) subtitle("Daily average outdoor temperature", size(medsmall)) size(medsmall))  graphregion(color(white) margin(zero))  xsize(8) ysize(8) 

graph export "Fig_A12.pdf", width(8) height(8) replace

restore

end

* Fig. A.13: Intervention rebound period: extended duration plots
capture program drop App_A6_Fig_A13
program define App_A6_Fig_A13

use experiment_data, clear

code_for_preparation 6 48 20 2400 2640 18 // 2640 is a 10% increase over 2400 mins (= 40 hours). Useful to stabilize boundary effects of the lpoly. But we don't plot further than 40 hours. 

calculation_for_Fig_4

preserve

preparation_plot_Fig_4_right
    
    // Plot Fig. 4 - right

    twoway lpoly energy_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 2400, clcolor(orange) degree(0) ///
         || rarea ul_energy_rebound_smooth ll_energy_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 2400, sort fcolor(orange%30) lcolor(orange%0) ///
        aspectratio(1) ytitle("Average post-intervention" "electricity consumption increase (kWh)") ylabel(0(0.5)3.5) ///
        xtitle("Time to intervention stop (h)") ///
		xlabel(0 "0" 240 "4" 480 "8" 720 "12" 960 "16" 1200 "20" 1440 "24" 1680 "28" 1920 "32" 2160 "36" 2400 "40") ///
        legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) graphregion(color(white) margin(zero))  xsize(8) ysize(8)  

    graph export "Fig_A13_right.pdf", width(8) height(8) replace
	
restore

preserve

preparation_plot_Fig_4_left

    // Plot Fig. 4 - left

    twoway lpoly power_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 2400, clcolor(orange) degree(0) ///
        || rarea ul_power_rebound_smooth ll_power_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 2400, sort fcolor(orange%30) lcolor(orange%0)  ///
        aspectratio(1) xtitle("Time to intervention stop (h)") ///
     	xlabel(0 "0" 240 "4" 480 "8" 720 "12" 960 "16" 1200 "20" 1440 "24" 1680 "28" 1920 "32" 2160 "36" 2400 "40") ///
        ylabel(-100(100)900) ytitle("Average post-intervention" "power consumption increase (W)") yline(0) ///
        legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) graphregion(color(white) margin(zero))  xsize(8) ysize(8)  

graph export "Fig_A13_left.pdf", width(8) height(8) replace

restore

end

* Fig. A.14: Rebound consumption of heat pumps resuming normal operation at the fleet level
capture program drop App_A7_Fig_A14
program define App_A7_Fig_A14

use data_prepared, clear
sort hh_id time
	
preserve

keep if after == 1

gen diff = hp_p - avg_cf_hp_p_spec

collapse (mean) diff (semean) sem_diff = diff, by(five_min_level_elapsed intervention_dummy)

gen ul_diff = diff + 1.96 * sem_diff
gen ll_diff = diff - 1.96 * sem_diff

// Smoothing the CI: 

capture drop ul_diff_sm_block ll_diff_sm_block
capture drop ul_diff_sm_unblock ll_diff_sm_unblock 

//// Blocked:

    // UL:

    lpoly ul_diff five_min_level_elapsed if intervention_dummy == 1, gen(ul_diff_sm_block) at(five_min_level_elapsed) degree(0)
    save temp_dataset, replace
    merge m:m five_min_level_elapsed using temp_dataset, keepusing(ul_diff_sm_block)
    drop _merge

    // LL:
 
    lpoly ll_diff five_min_level_elapsed if intervention_dummy == 1, gen(ll_diff_sm_block) at(five_min_level_elapsed) degree(0)
    save temp_dataset, replace
    merge m:m five_min_level_elapsed using temp_dataset, keepusing(ll_diff_sm_block)
    drop _merge

//// Unblocked:

    // UL:

    lpoly ul_diff five_min_level_elapsed if intervention_dummy == 0, gen(ul_diff_sm_unblock) at(five_min_level_elapsed) degree(0)
    save temp_dataset, replace
    merge m:m five_min_level_elapsed using temp_dataset, keepusing(ul_diff_sm_unblock)
    drop _merge

    // LL:
 
    lpoly ll_diff five_min_level_elapsed if intervention_dummy == 0, gen(ll_diff_sm_unblock) at(five_min_level_elapsed) degree(0)
    save temp_dataset, replace
    merge m:m five_min_level_elapsed using temp_dataset, keepusing(ll_diff_sm_unblock)
    drop _merge


// Plot: 

// Just the unblocked ones: 

twoway lpoly diff five_min_level_elapsed if intervention_dummy == 0, clcolor(green) ///
    || rarea ul_diff_sm_unblock ll_diff_sm_unblock five_min_level_elapsed if intervention_dummy == 0, sort fcolor(green%30) lcolor(green%0) ///
    aspectratio(1) xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ylabel(-300(100)450) yline(0, lwidth(thin) lcolor(gray))  ///
    ytitle("Average energy consumption" "per event and HP in the fleet (W)") graphregion(color(white) margin(zero))  xsize(8) ysize(8) legend(order(1 "Average across unblocked heat pumps" "(all interventions)" ) cols(2) pos(6) size(medsmall))

graph export "Fig_A14.pdf", replace


// Intensity of rebound 
di "Rebound (resp. first 18h, first 36h, between 18-36h)"
ci means diff if intervention_dummy == 0 & five_min_level_elapsed < 1080 // First 18 hours 
ci means diff if intervention_dummy == 0 & five_min_level_elapsed < 2160 // First 36 hours 
ci means diff if intervention_dummy == 0 & five_min_level_elapsed > 1080 & five_min_level_elapsed < 2160 // Between 18 - 36 hours 

restore

erase temp_dataset.dta
	
end

* Fig. A.15: Illustration of the two phases of flexibility events
// Is a side output of the program 'F5_6_pow_cons_during_event' defined above

* Fig. A.16: Fleet-level power consumption profiles during flexibility events: heterogeneity across average outdoor temperature
// Is a side output of the program 'Fig_A16_event_power_profile' defined above

* Fig. A.17: Fleet-level net power consumption reduction during flexibility events: heterogeneity across average outdoor temperature
// Is a side output of the program 'Fig_A17_event_power_reduction' defined above

* Fig. A.18: Back-of-the-envelope calculation of yearly savings through a smart allocation of flexibility events
// Is a side output of the program 'Fig_8_both_panels' defined above

********************************************************************************
* Appendix C: Distribution of the interventions per start time,                *
*             indoor temperature threshold value and day of the week	       *
********************************************************************************
capture program drop App_C_Fig_C19
program define App_C_Fig_C19

use data_prepared, clear
sort hh_id time

// Hour of day
twoway hist hourofday if intervention_dummy == 1 & intervention_dummy[_n-1] == 0 , frequency discrete xlabel(2 "2 am" 8 "8 am" 14 "2 pm" 20 "8 pm") ///
    xtitle("Hour of the day", size(medsmall)) color(blue%35) ///
    graphregion(color(white) margin(zero))  xsize(5) ysize(5) ylabel(0(10)80)

graph export "Fig_C19_top_left.pdf", replace

// Day of week
twoway hist dow if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, frequency discrete xlabel(0 "Mon" 1 "Tue" 2 "Wed" 3 "Thu" 4 "Fri" 5 "Sat" 6 "Sun") ///
    xtitle("Day of the week", size(medsmall)) color(blue%35) ///
    graphregion(color(white) margin(zero))  xsize(5) ysize(5) ylabel(0(10)80)    

graph export "Fig_C19_top_right.pdf", replace

// Indoor temperature threshold
twoway hist t_threshold_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, frequency discrete xtitle("Indoor temperature threshold (°C)", size(medsmall)) /// 
    start(16) color(blue%35) ///
    graphregion(color(white) margin(zero))  xsize(5) ysize(5) ylabel(0(10)80)

graph export "Fig_C19_bottom.pdf", replace

// Correlation coefficients 
pwcorr t_threshold_0 hourofday if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr t_threshold_0 dow if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr hourofday dow if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o

pwcorr t_threshold_0 notif_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr dow notif_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr hourofday notif_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o

end

********************************************************************************
* Appendix D: Cross-season comparison of key results    			           *
********************************************************************************
capture program drop calculating_results_per_HS
program define calculating_results_per_HS
// This program computes all key experimental results within a HS. It redefines the counterfactual to be heating-season-specific as well. (*)
// (*: done via filtering out all interventions that do not belong to the considered HS /before/ running the data preparation code.)
    args hs_value 

    // Data filtering:
    use experiment_data, clear

    if `hs_value' == 0 {
        // Keep all data (HS1 and HS2)
        keep if hs_index == 1 | hs_index == 2
    }
    else {
        // Keep only the selected HS
        keep if hs_index == `hs_value'
    }
	
	di "***** Heating season `hs_value' (0 = whole sample) *****"
	
	qui	code_for_preparation 6 48 20 960 1056 18 // 1056 is a 10% increase over 960 mins (= 16 hours). This extra margin is needed to stabilize the lpoly smoothing at the x-axis boundary. But we don't plot further than 16 hours.  
	
	
	sleep 10000

    // Run the computations:

    // 1. Breakdown of termination scenarios
    qui count if reason_stop != 0 
    scalar total_inter_`hs_value' = r(N)

    qui count if reason_stop == -2
    scalar DHW_stop_`hs_value' = round(100 * r(N) / total_inter_`hs_value', 0.1)

    qui count if reason_stop == -1
    scalar temp_stop_`hs_value' = round(100 * r(N) / total_inter_`hs_value', 0.1)

    qui count if reason_stop != 0 & reason_stop != -1 & reason_stop != -2
    scalar manual_stop_`hs_value' = round(100 * r(N) / total_inter_`hs_value', 0.1)

    di "* Stops: DHW = " DHW_stop_`hs_value' "%; indoor temp = " temp_stop_`hs_value' "%; manual stop = " manual_stop_`hs_value' "%; Total interventions = " total_inter_`hs_value'

    // 2. Average intervention duration (in hours)
    quietly ci means total_duration_int_hour if reason_stop != 0

    scalar mean_duration_`hs_value' = round(r(mean), 0.1)
    scalar LL_duration_`hs_value' = round(r(lb), 0.1)
    scalar UL_duration_`hs_value' = round(r(ub), 0.1)

    scalar r_mean_duration_`hs_value' = r(mean)
    scalar SE_duration_`hs_value' = r(se)
    scalar n_duration_`hs_value' = r(N)

    di "* Intervention duration: mean = " mean_duration_`hs_value' " h (95% CI: " LL_duration_`hs_value' ", " UL_duration_`hs_value' " h)"
	
	// 3. ATT indoor temperature reduction (°C)
    quietly wildbootstrap reg t_in intervention_dummy i.hh_id, cluster(hh_id) rseed(42) reps(100000)
    
    scalar mean_ATT_t_in_`hs_value' = round(e(wboot)[1,1], 0.01)
    scalar LL_t_in_`hs_value' = round(e(wboot)[1,4], 0.01)
    scalar UL_t_in_`hs_value' = round(e(wboot)[1,5], 0.01)

    di "* ATT on indoor temperature: mean = " mean_ATT_t_in_`hs_value' " °C (95% CI: " LL_t_in_`hs_value' ", " UL_t_in_`hs_value' " °C)"

    // 4. ATT power reduction (W)
    quietly wildbootstrap reg hp_p intervention_dummy i.hh_id, cluster(hh_id) rseed(42) reps(100000)
    
    scalar mean_ATT_hp_p_`hs_value' = round(e(wboot)[1,1], 1)
    scalar LL_hp_p_`hs_value' = round(e(wboot)[1,4], 1)
    scalar UL_hp_p_`hs_value' = round(e(wboot)[1,5], 1)

    di "* ATT on power: mean = " mean_ATT_hp_p_`hs_value' " W (95% CI: " LL_hp_p_`hs_value' ", " UL_hp_p_`hs_value' " W)"

    // 5. Average consumption reduction during intervention (kWh)
    quietly calculation_for_Fig_3
    quietly ci means energy_saved_int if reason_stop != 0

    scalar mean_energy_during_`hs_value' = round(r(mean), 0.01)
    scalar LL_energy_during_`hs_value' = round(r(lb), 0.01)
    scalar UL_energy_during_`hs_value' = round(r(ub), 0.01)

    scalar r_mean_energy_during_`hs_value' = r(mean)
    scalar SE_energy_during_`hs_value' = r(se)
    scalar n_energy_during_`hs_value' = r(N)

    di "* Energy consumption reduction during the intervention: mean = " mean_energy_during_`hs_value' " kWh (95% CI: " LL_energy_during_`hs_value' ", " UL_energy_during_`hs_value' " kWh)"
	
    // 6. Average consumption increase after intervention (kWh)
    quietly calculation_for_Fig_4
		// Generating a variable to capture the full rebound electricity consumption (kWh), at 16h after the intervention stop
		capture drop energy_rebound_after_int_16h
		gen energy_rebound_after_int_16h = energy_rebound_after_int if time_diff_from_end_5min == 960 // 16h in minutes

    quietly ci means energy_rebound_after_int_16h // 16 hours

    scalar mean_energy_after_`hs_value' = round(r(mean), 0.01)
    scalar LL_energy_after_`hs_value' = round(r(lb), 0.01)
    scalar UL_energy_after_`hs_value' = round(r(ub), 0.01)

    scalar r_mean_energy_after_`hs_value' = r(mean)
    scalar SE_energy_after_`hs_value' = r(se)
    scalar n_energy_after_`hs_value' = r(N)

    di "* Energy consumption increase within 16h post-intervention: mean = " mean_energy_after_`hs_value' " kWh (95% CI: " LL_energy_after_`hs_value' ", " UL_energy_after_`hs_value' " kWh)"
	
		// Plot
		preserve
		
		qui preparation_plot_Fig_4_right
		
		twoway lpoly energy_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 960, clcolor(orange) degree(0) ///
			 || rarea ul_energy_rebound_smooth ll_energy_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 960, sort ///
				fcolor(orange%30) lcolor(orange%0) aspectratio(1) ytitle("Average post-intervention" "electricity consumption increase (kWh)") ///
				ylabel(0(0.5)3.5) xtitle("Time to intervention stop (h)") ///
				xlabel(0 "0" 120 "2" 240 "4" 360 "6" 480 "8" 600 "10" 720 "12" 840 "14" 960 "16") ///
				legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) ///
				graphregion(color(white) margin(zero))  xsize(8) ysize(8)  
	   //graph export "App_D_Fig_like_4_left_`hs_value'.pdf", width(8) height(8) replace
	   restore

    // 7. Power rebound
    quietly ci means power_rebound_after_int if time_diff_from_end_5min <= 60

    scalar mean_power_after_`hs_value' = round(r(mean), 1)
    scalar LL_power_after_`hs_value' = round(r(lb), 1)
    scalar UL_power_after_`hs_value' = round(r(ub), 1)

    scalar r_mean_power_after_`hs_value' = r(mean)
    scalar SE_power_after_`hs_value' = r(se)
    scalar n_power_after_`hs_value' = r(N)

    di "* Power consumption rebound (increase) within 1h post-intervention: mean = " mean_power_after_`hs_value' " W (95% CI: " LL_power_after_`hs_value' ", " UL_power_after_`hs_value' " W)"
	
			// Plot
			preserve
			
			qui preparation_plot_Fig_4_left

			twoway lpoly power_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 960, clcolor(orange) degree(0) ///
				|| rarea ul_power_rebound_smooth ll_power_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 960, sort ///
				   fcolor(orange%30) lcolor(orange%0)  aspectratio(1) ///
				   xlabel(0 "0" 120 "2" 240 "4" 360 "6" 480 "8" 600 "10" 720 "12" 840 "14" 960 "16") ///
				   xtitle("Time to intervention stop (h)") ylabel(-100(100)900) ///
				   ytitle("Average post-intervention" "power consumption increase (W)") yline(0) ///
				   legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) ///
				   graphregion(color(white) margin(zero))  xsize(8) ysize(8)  
			//graph export "App_D_Fig_like_4_left_`hs_value'.pdf", replace
			restore
	
	// 8. Fleet-level profile 
	
		// Full profile
		qui calculation_for_Fig_5_left
		
		local bw_hp_p = scalar(bw_hp_p_scalar)
		local bw_cf = scalar(bw_cf_scalar)
		
		twoway ///
			lpoly hp_p five_min_level_elapsed if before == 1, clcolor(blue)  bw(`bw_hp_p') ///
			|| lpoly hp_p five_min_level_elapsed if after == 1, clcolor(blue)  bw(`bw_hp_p') ///
			|| rarea UL_sm_before LL_sm_before five_min_level_elapsed if before == 1, sort fcolor(blue%30) lcolor(blue%0) ///
			|| rarea UL_sm_after LL_sm_after five_min_level_elapsed if after == 1, sort fcolor(blue%30) lcolor(blue%0) ///
			|| lpoly avg_cf_hp_p_spec_fleet five_min_level_elapsed if (before == 1 | after == 1), clcolor(green) bw(`bw_cf') ///
			|| rarea UL_cf_sm LL_cf_sm five_min_level_elapsed if (before == 1 | after == 1), sort fcolor(green%30) lcolor(green%0) ///
			aspectratio(1) xline(0, lwidth(thin) lcolor(gray)) ///
			xlabel(-360 "-6" 0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") ///
			xtitle("Time to flexibility event start (h)") ylabel(0(100)600) ytitle("Average HP power in the fleet (W)") ///
			legend(order(1 "Average across interventions" 3 "95% CI" 5 "Control" 6 "95% CI" ) cols(2) pos(6) size(small)) ///
			graphregion(color(white) margin(zero)) xsize(8) ysize(8) 
		//graph export "App_D_Fig_like_5_left_`hs_value'.pdf", width(8) height(8) replace

		// Net profile
		qui calculation_for_Fig_5_right
		
		twoway lpoly power_reduction five_min_level_elapsed, clcolor(orange) yline(0) ///
			|| rarea ul_power_reduction_sm ll_power_reduction_sm five_min_level_elapsed, sort color(orange%30) lcolor(orange%0) ///
		    xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") ylabel(-200(50)300) ///
			xtitle("Time to flexibility event start (h)") ytitle("Average HP power reduction in the fleet (W)") ///
			legend(order(1 "Average across interventions" 2 "95% CI" ) cols(2) pos(6) size(small)) ///
			graphregion(color(white) margin(zero)) xsize(8) ysize(8)
		graph export "App_D_Fig_like_5_right_`hs_value'.pdf", replace

	qui ci means power_reduction if five_min_level_elapsed <= 60 // 1 hours
			
	scalar mean_fleet_pow_red_`hs_value' = round(r(mean), 1)
	scalar LL_fleet_pow_red_`hs_value' = round(r(lb), 1)
	scalar UL_fleet_pow_red_`hs_value' = round(r(ub), 1)
	
    scalar r_mean_fleet_pow_red_`hs_value' = r(mean)
    scalar SE_fleet_pow_red_`hs_value' = r(se)
    scalar n_fleet_pow_red_`hs_value' = r(N)

	di "* Fleet-level power reduction within 1h after event start per HP in a fleet: mean = " scalar(mean_fleet_pow_red_`hs_value') " W (95% CI: " scalar(LL_fleet_pow_red_`hs_value') ", " scalar(UL_fleet_pow_red_`hs_value') " W)"
	
    // 9. Temperature drop comparison HS1/HS2 and manual/automatic stops
    use data_prepared, clear
    sort hh_id time
		
		// 1. Comparison HS1/HS2
		
		    quietly {		
			capture drop manually_overruled_during_int
			gen manually_overruled_during_int = 0 if reason_stop != 0 & reason_stop != -3
			replace manually_overruled_during_int = 1 if reason_stop == -3

			capture drop temperature_drop
			gen temperature_drop = t_in_0 - t_in

			ci means temperature_drop if reason_stop != 0 

			scalar mean_temp_drop_`hs_value' = round(r(mean), 0.01)
			scalar LL_temp_drop_`hs_value' = round(r(lb), 0.01)
			scalar UL_temp_drop_`hs_value' = round(r(ub), 0.01)

			scalar r_mean_temp_drop_`hs_value' = r(mean)
			scalar SE_temp_drop_`hs_value' = r(se)
			scalar n_temp_drop_`hs_value' = r(N)
			}
			
			di "* Temperature drop between start and end of intervention: mean = " mean_temp_drop_`hs_value' " °C (95% CI: " LL_temp_drop_`hs_value' ", " UL_temp_drop_`hs_value' " °C)"

		// 2. Comparison manual vs automatic stops HS1/HS2
		
			quietly{
			ttest temperature_drop if reason_stop != 0 , by(manually_overruled_during_int) unequal

			scalar mean_diff_temp_drop_`hs_value' = round(r(mu_1)-r(mu_2), 0.01)
			scalar LL_diff_temp_drop_`hs_value' = round(r(mu_1)-r(mu_2) - invttail(r(df_t), 0.05/2)*r(se), 0.01)
			scalar UL_diff_temp_drop_`hs_value' = round(r(mu_1)-r(mu_2) + invttail(r(df_t), 0.05/2)*r(se), 0.01)
			}
			
			di "* Excess drop when interventions are manually overruled (°C): mean = " mean_diff_temp_drop_`hs_value' " °C (95% CI: " LL_diff_temp_drop_`hs_value' ", " UL_diff_temp_drop_`hs_value' " °C)"
		  
end

capture program drop App_D_Table_D6
program define App_D_Table_D6

    // Run the program 'calculating_results_per_HS' for each dataset
    calculating_results_per_HS 1 // Heating season 1 only
    calculating_results_per_HS 2 // Heating season 2 only
	calculating_results_per_HS 0 // Whole sample
	
	capture drop cons 
	gen cons = 1 

    di "***** Comparison HS1 and HS2 *****"
	
	// 1. Breakdown of the termination scenarios
	
		// N/A

    // 2. Average intervention duration (in hours)
		scalar t_stat_duration = (scalar(r_mean_duration_1) - scalar(r_mean_duration_2)) / sqrt(scalar(SE_duration_1)^2 + scalar(SE_duration_2)^2)
		scalar dof_duration = (scalar(SE_duration_1)^2 + scalar(SE_duration_2)^2)^2 / ( (scalar(SE_duration_1)^4 / (scalar(n_duration_1) - 1)) + (scalar(SE_duration_2)^4 / (scalar(n_duration_2) - 1)) )
		scalar p_value_duration = round(2 * ttail(dof_duration, abs(t_stat_duration)), 0.01)
		
		if p_value_duration < 0.05 {
			local significance_duration "Statistically significant at the 5% level"
		}
		else {
			local significance_duration "Not statistically significant at the 5% level"
		}
		di "Intervention duration: t-stat = " scalar(t_stat_duration) ", df = " scalar(dof_duration) ", p-value = " scalar(p_value_duration) " → Conclusion: `significance_duration'"

	// 3. ATT indoor temperature reduction (°C)
		qui wildbootstrap reg t_in intervention_dummy##hs_index cons, hascons cluster(hh_id) rseed(42) reps(100000) // No FE -> constant term included
		
		scalar diff_ATT_t_in = round(e(wboot)[3,1], 0.01)
		scalar p_value_ATT_t_in = round(e(wboot)[3,3], 0.01)

		if scalar(p_value_ATT_t_in) < 0.05 {
			scalar significance_ATT_t_in = "Statistically significant at the 5% level"
		}
		else {
			scalar significance_ATT_t_in = "Not statistically significant at the 5% level"
		}

		di "Difference in ATTs on T_in: mean = " scalar(diff_ATT_t_in) ", p-value = " scalar(p_value_ATT_t_in) " → Conclusion: " significance_ATT_t_in

    // 4. ATT power reduction (W)
		qui wildbootstrap reg hp_p intervention_dummy##hs_index cons, hascons cluster(hh_id) rseed(42) reps(100000) // No FE -> constant term included

		matrix wboot_matrix = e(wboot)
		scalar diff_ATT_hp_p = round(wboot_matrix[3,1], 0.01)
		scalar p_value_ATT_hp_p = round(wboot_matrix[3,3], 0.01)

		if scalar(p_value_ATT_hp_p) < 0.05 {
			local significance_ATT_hp_p "Statistically significant at the 5% level"
		}
		else {
			local significance_ATT_hp_p "Not statistically significant at the 5% level"
		}

		di "Difference in ATTs on HP_P: mean = " scalar(diff_ATT_hp_p) ", p-value = " scalar(p_value_ATT_hp_p) " → Conclusion: `significance_ATT_hp_p'"

    // 5. Average consumption reduction during the intervention (kWh)
		scalar t_stat_energy_during = (scalar(r_mean_energy_during_1) - scalar(r_mean_energy_during_2)) / sqrt(scalar(SE_energy_during_1)^2 + scalar(SE_energy_during_2)^2)
		scalar dof_energy_during = (scalar(SE_energy_during_1)^2 + scalar(SE_energy_during_2)^2)^2 / ( (scalar(SE_energy_during_1)^4 / (scalar(n_energy_during_1) - 1)) + (scalar(SE_energy_during_2)^4 / (scalar(n_energy_during_2) - 1)) )
		scalar p_value_energy_during = round(2 * ttail(scalar(dof_energy_during), abs(scalar(t_stat_energy_during))), 0.01)

		if scalar(p_value_energy_during) < 0.05 {
			local significance_energy_during "Statistically significant at the 5% level"
		}
		else {
			local significance_energy_during "Not statistically significant at the 5% level"
		}

		di "Energy consumption reduction during an intervention: t-stat = " scalar(t_stat_energy_during) ", df = " scalar(dof_energy_during) ", p-value = " scalar(p_value_energy_during) " → Conclusion: `significance_energy_during'"

    // 6. Average consumption increase after intervention (kWh)
		scalar t_stat_energy_after = (scalar(r_mean_energy_after_1) - scalar(r_mean_energy_after_2)) / sqrt(scalar(SE_energy_after_1)^2 + scalar(SE_energy_after_2)^2)
		scalar dof_energy_after = (scalar(SE_energy_after_1)^2 + scalar(SE_energy_after_2)^2)^2 / ( (scalar(SE_energy_after_1)^4 / (scalar(n_energy_after_1) - 1)) + (scalar(SE_energy_after_2)^4 / (scalar(n_energy_after_2) - 1)) )
		scalar p_value_energy_after = round(2 * ttail(scalar(dof_energy_after), abs(scalar(t_stat_energy_after))), 0.01)

		if scalar(p_value_energy_after) < 0.05 {
			local significance_energy_after "Statistically significant at the 5% level"
		}
		else {
			local significance_energy_after "Not statistically significant at the 5% level"
		}

		di "Energy consumption increase within 16h post-intervention: t-stat = " scalar(t_stat_energy_after) ", df = " scalar(dof_energy_after) ", p-value = " scalar(p_value_energy_after) " → Conclusion: `significance_energy_after'"

    // 7. Power rebound
		scalar t_stat_power_after = (scalar(r_mean_power_after_1) - scalar(r_mean_power_after_2)) / sqrt(scalar(SE_power_after_1)^2 + scalar(SE_power_after_2)^2)
		scalar dof_power_after = (scalar(SE_power_after_1)^2 + scalar(SE_power_after_2)^2)^2 / ( (scalar(SE_power_after_1)^4 / (scalar(n_power_after_1) - 1)) + (scalar(SE_power_after_2)^4 / (scalar(n_power_after_2) - 1)) )
		scalar p_value_power_after = round(2 * ttail(scalar(dof_power_after), abs(scalar(t_stat_power_after))), 0.01)

		if scalar(p_value_power_after) < 0.05 {
			scalar significance_power_after = "Statistically significant at the 5% level"
		}
		else {
			scalar significance_power_after = "Not statistically significant at the 5% level"
		}

		di "Power consumption rebound (increase) within 1h post-intervention: t-stat = " scalar(t_stat_power_after) ", df = " scalar(dof_power_after) ", p-value = " scalar(p_value_power_after) " → Conclusion: " significance_power_after

    // 8. Fleet-level profile
	
		// 1. Fleet-level maximum reduction within 1 hour
			scalar t_stat_fleet_pow_red = (scalar(r_mean_fleet_pow_red_1) - scalar(r_mean_fleet_pow_red_2)) / sqrt(scalar(SE_fleet_pow_red_1)^2 + scalar(SE_fleet_pow_red_2)^2)
			scalar dof_fleet_pow_red = (scalar(SE_fleet_pow_red_1)^2 + scalar(SE_fleet_pow_red_2)^2)^2 / ( (scalar(SE_fleet_pow_red_1)^4 / (scalar(n_fleet_pow_red_1) - 1)) + (scalar(SE_fleet_pow_red_2)^4 / (scalar(n_fleet_pow_red_2) - 1)) )
			scalar p_value_fleet_pow_red = round(2 * ttail(scalar(dof_fleet_pow_red), abs(scalar(t_stat_fleet_pow_red))), 0.01)

			if scalar(p_value_fleet_pow_red) < 0.05 {
				local significance_fleet_pow_red "Statistically significant at the 5% level"
			}
			else {
				local significance_fleet_pow_red "Not statistically significant at the 5% level"
			}

			di "Fleet-level power reduction within 1h after event start per HP in a fleet: t-stat = " scalar(t_stat_fleet_pow_red) ", df = " scalar(dof_fleet_pow_red) ", p-value = " scalar(p_value_fleet_pow_red) " → Conclusion: `significance_fleet_pow_red'"
			
		// 2. Mean time until fleet-level rebound (hours)
	
			di "Mean time until fleet-level rebound (hours): Visually derived from Figures: App_D_Fig_like_5_right_1.pdf (approx. 17 h) and App_D_Fig_like_5_right_2.pdf (approx. 21 h)"

    // 9. Temperature drop comparison HS1/HS2 and manual/automatic stops
	
		// 1. Comparison HS1/HS2
			scalar t_stat_temp_drop = (scalar(r_mean_temp_drop_1) - scalar(r_mean_temp_drop_2)) / sqrt(scalar(SE_temp_drop_1)^2 + scalar(SE_temp_drop_2)^2)
			scalar dof_temp_drop = (scalar(SE_temp_drop_1)^2 + scalar(SE_temp_drop_2)^2)^2 / ( (scalar(SE_temp_drop_1)^4 / (scalar(n_temp_drop_1) - 1)) + (scalar(SE_temp_drop_2)^4 / (scalar(n_temp_drop_2) - 1)) )
			scalar p_value_temp_drop = round(2 * ttail(scalar(dof_temp_drop), abs(scalar(t_stat_temp_drop))), 0.01)

			if scalar(p_value_temp_drop) < 0.05 {
				local significance_temp_drop "Statistically significant at the 5% level"
			}
			else {
				local significance_temp_drop "Not statistically significant at the 5% level"
			}

			di "Temperature drop between start and end of intervention: t-stat = " scalar(t_stat_temp_drop) ", df = " scalar(dof_temp_drop) ", p-value = " scalar(p_value_temp_drop) " → Conclusion: `significance_temp_drop'"
			
	// 2. Comparison manual vs automatic stops HS1/HS2
	
		qui wildbootstrap reg temperature_drop manually_overruled_during_int##hs_index cons if reason_stop != 0, hascons cluster(hh_id) rseed(42) reps(100000) // No FE -> constant term included
			
		scalar additional_effect_hs2 = round(e(wboot)[3,1], 0.01)
		scalar p_value_add_effect_hs2 = round(e(wboot)[3,3], 0.01)

		if scalar(p_value_add_effect_hs2) < 0.05 {
			scalar sig_add_effect_temp_drop = "Statistically significant at the 5% level"
		}
		else {
			scalar sig_add_effect_temp_drop = "Not statistically significant at the 5% level"
		}

		di "Additional effect (of manual vs automatic) on temperature drop in HS2: mean = " scalar(additional_effect_hs2) ", p-value = " scalar(p_value_add_effect_hs2) " → Conclusion: " sig_add_effect_temp_drop		
		
// Clear previous postfile utility
postutil clear
capture frame drop summary_results_merged

// Create a new frame to store the merged results
frame create summary_results_merged
frame change summary_results_merged

// Define a tempfile to store the merged results
tempfile summary_table_merged
postfile summary_results_merged str50 variable_name str15 mean_all str20 ci_all str15 mean_hs1 str20 ci_hs1 str15 mean_hs2 str20 ci_hs2 str10 p_value_diff using `summary_table_merged'

// Define variables and directly assign their values from scalars
local variables "Total_nr_inter DHW_stop_share Manual_stop_share Indoor_temp_share Intervention_duration ATT_temperature_reduction ATT_power_reduction  Elec_consumption_reduction Elec_consumption_rebound Power_consumption_rebound Fleet_power_reduction_1hr Fleet_time_till_rebound Temperature_drop Add_effect_temp_drop_manual_HS2"

foreach var in `variables' {

    // Assign mean and CI values using scalars from TX_both_HS

    if "`var'" == "Total_nr_inter" {
        local mean_all = scalar(total_inter_0)
        local ci_all = "-"
        local mean_hs1 = scalar(total_inter_1)
        local ci_hs1 = "-"
        local mean_hs2 = scalar(total_inter_2)
        local ci_hs2 = "-"
        local p_value_diff = "-"
    }
    if "`var'" == "DHW_stop_share" {
        local mean_all = scalar(DHW_stop_0)
        local ci_all = "-"
        local mean_hs1 = scalar(DHW_stop_1)
        local ci_hs1 = "-"
        local mean_hs2 = scalar(DHW_stop_2)
        local ci_hs2 = "-"
        local p_value_diff = "-"
    }
	
    if "`var'" == "Manual_stop_share" {
        local mean_all = scalar(temp_stop_0)
        local ci_all = "-"
        local mean_hs1 = scalar(temp_stop_1)
        local ci_hs1 = "-"
        local mean_hs2 = scalar(temp_stop_2)
        local ci_hs2 = "-"
        local p_value_diff = "-"
    }
	
    if "`var'" == "Indoor_temp_share" {
        local mean_all = scalar(manual_stop_0)
        local ci_all = "-"
        local mean_hs1 = scalar(mean_ATT_t_in_1)
        local ci_hs1 = "-"
        local mean_hs2 = scalar(mean_ATT_t_in_2)
        local ci_hs2 = "-"
        local p_value_diff = "-"
    }
    if "`var'" == "Fleet_time_till_rebound" {
        local mean_all = "cf Figure *"
        local ci_all = "-"
        local mean_hs1 = "cf Figure **"
        local ci_hs1 = "-"
        local mean_hs2 = "cf Figure ***"
        local ci_hs2 = "-"
        local p_value_diff = "-"
    }	
    if "`var'" == "ATT_temperature_reduction" {
        local mean_all = scalar(mean_ATT_t_in_0)
        local ci_all = "(" + string(scalar(LL_t_in_0), "%6.2f") + ", " + string(scalar(UL_t_in_0), "%6.2f") + ")"
        local mean_hs1 = scalar(mean_ATT_t_in_1)
        local ci_hs1 = "(" + string(scalar(LL_t_in_1), "%6.2f") + ", " + string(scalar(UL_t_in_1), "%6.2f") + ")"
        local mean_hs2 = scalar(mean_ATT_t_in_2)
        local ci_hs2 = "(" + string(scalar(LL_t_in_2), "%6.2f") + ", " + string(scalar(UL_t_in_2), "%6.2f") + ")"
        local p_value_diff = scalar(p_value_ATT_t_in)
    }
    else if "`var'" == "ATT_power_reduction" {
        local mean_all = scalar(mean_ATT_hp_p_0)
        local ci_all = "(" + string(scalar(LL_hp_p_0), "%6.1f") + ", " + string(scalar(UL_hp_p_0), "%6.1f") + ")"
        local mean_hs1 = scalar(mean_ATT_hp_p_1)
        local ci_hs1 = "(" + string(scalar(LL_hp_p_1), "%6.1f") + ", " + string(scalar(UL_hp_p_1), "%6.1f") + ")"
        local mean_hs2 = scalar(mean_ATT_hp_p_2)
        local ci_hs2 = "(" + string(scalar(LL_hp_p_2), "%6.1f") + ", " + string(scalar(UL_hp_p_2), "%6.1f") + ")"
        local p_value_diff = scalar(p_value_ATT_hp_p)
    }
    else if "`var'" == "Intervention_duration" {
        local mean_all = scalar(mean_duration_0)
        local ci_all = "(" + string(scalar(LL_duration_0), "%6.1f") + ", " + string(scalar(UL_duration_0), "%6.1f") + ")"
        local mean_hs1 = scalar(mean_duration_1)
        local ci_hs1 = "(" + string(scalar(LL_duration_1), "%6.1f") + ", " + string(scalar(UL_duration_1), "%6.1f") + ")"
        local mean_hs2 = scalar(mean_duration_2)
        local ci_hs2 = "(" + string(scalar(LL_duration_2), "%6.1f") + ", " + string(scalar(UL_duration_2), "%6.1f") + ")"
        local p_value_diff = scalar(p_value_duration)
    }
    else if "`var'" == "Elec_consumption_reduction" {
        local mean_all = scalar(mean_energy_during_0)
        local ci_all = "(" + string(scalar(LL_energy_during_0), "%6.2f") + ", " + string(scalar(UL_energy_during_0), "%6.2f") + ")"
        local mean_hs1 = scalar(mean_energy_during_1)
        local ci_hs1 = "(" + string(scalar(LL_energy_during_1), "%6.2f") + ", " + string(scalar(UL_energy_during_1), "%6.2f") + ")"
        local mean_hs2 = scalar(mean_energy_during_2)
        local ci_hs2 = "(" + string(scalar(LL_energy_during_2), "%6.2f") + ", " + string(scalar(UL_energy_during_2), "%6.2f") + ")"
        local p_value_diff = scalar(p_value_energy_during)
    }
    else if "`var'" == "Elec_consumption_rebound" {
        local mean_all = scalar(mean_energy_after_0)
        local ci_all = "(" + string(scalar(LL_energy_after_0), "%6.2f") + ", " + string(scalar(UL_energy_after_0), "%6.2f") + ")"
        local mean_hs1 = scalar(mean_energy_after_1)
        local ci_hs1 = "(" + string(scalar(LL_energy_after_1), "%6.2f") + ", " + string(scalar(UL_energy_after_1), "%6.2f") + ")"
        local mean_hs2 = scalar(mean_energy_after_2)
        local ci_hs2 = "(" + string(scalar(LL_energy_after_2), "%6.2f") + ", " + string(scalar(UL_energy_after_2), "%6.2f") + ")"
        local p_value_diff = scalar(p_value_energy_after)
    }
    else if "`var'" == "Power_consumption_rebound" {
        local mean_all = scalar(mean_power_after_0)
        local ci_all = "(" + string(scalar(LL_power_after_0), "%6.1f") + ", " + string(scalar(UL_power_after_0), "%6.1f") + ")"
        local mean_hs1 = scalar(mean_power_after_1)
        local ci_hs1 = "(" + string(scalar(LL_power_after_1), "%6.1f") + ", " + string(scalar(UL_power_after_1), "%6.1f") + ")"
        local mean_hs2 = scalar(mean_power_after_2)
        local ci_hs2 = "(" + string(scalar(LL_power_after_2), "%6.1f") + ", " + string(scalar(UL_power_after_2), "%6.1f") + ")"
        local p_value_diff = scalar(p_value_power_after)
    }
    else if "`var'" == "Fleet_power_reduction_1hr" {
        local mean_all = scalar(mean_fleet_pow_red_0)
        local ci_all = "(" + string(scalar(LL_fleet_pow_red_0), "%6.1f") + ", " + string(scalar(UL_fleet_pow_red_0), "%6.1f") + ")"
        local mean_hs1 = scalar(mean_fleet_pow_red_1)
        local ci_hs1 = "(" + string(scalar(LL_fleet_pow_red_1), "%6.1f") + ", " + string(scalar(UL_fleet_pow_red_1), "%6.1f") + ")"
        local mean_hs2 = scalar(mean_fleet_pow_red_2)
        local ci_hs2 = "(" + string(scalar(LL_fleet_pow_red_2), "%6.1f") + ", " + string(scalar(UL_fleet_pow_red_2), "%6.1f") + ")"
        local p_value_diff = scalar(p_value_fleet_pow_red)
    }
    else if "`var'" == "Temperature_drop" {
        local mean_all = scalar(mean_temp_drop_0)
        local ci_all = "(" + string(scalar(LL_temp_drop_0), "%6.1f") + ", " + string(scalar(UL_temp_drop_0), "%6.1f") + ")"
        local mean_hs1 = scalar(mean_temp_drop_1)
        local ci_hs1 = "(" + string(scalar(LL_temp_drop_1), "%6.1f") + ", " + string(scalar(UL_temp_drop_1), "%6.1f") + ")"
        local mean_hs2 = scalar(mean_temp_drop_2)
        local ci_hs2 = "(" + string(scalar(LL_temp_drop_2), "%6.1f") + ", " + string(scalar(UL_temp_drop_2), "%6.1f") + ")"
        local p_value_diff = scalar(p_value_temp_drop)
    }
    else if "`var'" == "Add_effect_temp_drop_manual_HS2" {
        local mean_all = scalar(mean_diff_temp_drop_0)
        local ci_all = "(" + string(scalar(LL_diff_temp_drop_0), "%6.1f") + ", " + string(scalar(UL_diff_temp_drop_0), "%6.1f") + ")"
        local mean_hs1 = scalar(mean_diff_temp_drop_1)
        local ci_hs1 = "(" + string(scalar(LL_diff_temp_drop_1), "%6.1f") + ", " + string(scalar(UL_diff_temp_drop_1), "%6.1f") + ")"
        local mean_hs2 = scalar(mean_diff_temp_drop_2)
        local ci_hs2 = "(" + string(scalar(LL_diff_temp_drop_2), "%6.1f") + ", " + string(scalar(UL_diff_temp_drop_2), "%6.1f") + ")"
        local p_value_diff = scalar(p_value_add_effect_hs2)
    }	
    // Store merged results
    post summary_results_merged ("`var'") ("`mean_all'") ("`ci_all'") ("`mean_hs1'") ("`ci_hs1'") ("`mean_hs2'") ("`ci_hs2'") ("`p_value_diff'")
}

// Close postfile
postclose summary_results_merged

di "Figure *: App_D_Fig_like_5_right_0.pdf ; Figure **: App_D_Fig_like_5_right_1.pdf ; Figure ***: App_D_Fig_like_5_right_2.pdf"

// Load and display the final merged summary table
use `summary_table_merged', clear
list, separator(0)

// Export merged results to CSV
// export delimited "robustness_check_summary_merged.csv", replace

// Restore main frame
frame change default

end

********************************************************************************
* Appendix F: Counterfactual power consumption accuracy and bias diagnosis     *
********************************************************************************
capture program drop App_F_Fig_F20
program define App_F_Fig_F20, rclass

    frame change default 
    
    use data_prepared, clear
    
    drop if intervention_dummy == 1
    drop if excl_from_cf == 1 & intervention_dummy == 0
	
	sum hp_p, meanonly
	local mean_hp_p = r(mean)
	di "Mean of hp_p excluding interventions and observations too close to the start/end of an intervention (training dataset) = " `mean_hp_p' " W"
	
    gen minutes_of_day = hourofday * 60 + minofhour

    capture frame drop rmse_results
    frame create rmse_results bin rmse_best rmse_global rmse_hh rmse_hh_time
	
	
    local bin_sizes 5 10 15 20 30 45 60 75 90 120 150 180 210 240 270 300 330 360 390 420 450 480 510 540 570 600 630 660 720

	quietly foreach bin in `bin_sizes' {
        preserve

        * Create time bin
        gen minutes_bin = floor(minutes_of_day / `bin') * `bin'

        * Collapse to time bin level
        collapse (mean) hp_p avg_cf_hp_p_spec t_in t_set t_dhw t_out temp_cf_bin daily_avg_t_out daily_min_t_out, ///
            by(hh_id minutes_bin date)

        * Model 1: Super naive — global mean
        su hp_p, meanonly
        gen hp_p_naive_global = r(mean)
        gen pred_error_global = hp_p - hp_p_naive_global
        gen diffsq_global = pred_error_global^2
        egen sumdiffsq_global = total(diffsq_global)
        count if !missing(diffsq_global)
        local n_global = r(N)
        local rmse_global = sqrt(sumdiffsq_global / `n_global')

        * Model 2: hh_id-specific mean
        egen hp_p_naive_hh = mean(hp_p), by(hh_id)
        gen pred_error_hh = hp_p - hp_p_naive_hh
        gen diffsq_hh = pred_error_hh^2
        egen sumdiffsq_hh = total(diffsq_hh)
        count if !missing(diffsq_hh)
        local n_hh = r(N)
        local rmse_hh = sqrt(sumdiffsq_hh / `n_hh')

        * Model 3: hh_id × minutes_bin mean
        egen hp_p_naive_hh_time = mean(hp_p), by(hh_id minutes_bin)
        gen pred_error_hh_time = hp_p - hp_p_naive_hh_time
        gen diffsq_hh_time = pred_error_hh_time^2
        egen sumdiffsq_hh_time = total(diffsq_hh_time)
        count if !missing(diffsq_hh_time)
        local n_hh_time = r(N)
        local rmse_hh_time = sqrt(sumdiffsq_hh_time / `n_hh_time')

        * Model 4: paper model — avg_cf_hp_p_spec
        gen pred_error_best = hp_p - avg_cf_hp_p_spec
        gen diffsq_best = pred_error_best^2
        egen sumdiffsq_best = total(diffsq_best)
        count if !missing(diffsq_best)
        local n_best = r(N)
        local rmse_best = sqrt(sumdiffsq_best / `n_best')


        * Post to results frame
        frame post rmse_results (`bin') (`rmse_best') (`rmse_global') (`rmse_hh') (`rmse_hh_time')

        restore
    }
	
	frame rmse_results {
	
	capture drop yline_*
	
	gen yline_mean_hp_p = `mean_hp_p' 
	
	capture drop gain_*

    * Compute efficiency gains as percentage RMSE reduction
    gen gain_vs_global  = 100 * (rmse_global - rmse_best) / rmse_global
    gen gain_vs_hh      = 100 * (rmse_hh     - rmse_best) / rmse_hh
    gen gain_vs_hh_time = 100 * (rmse_hh_time - rmse_best) / rmse_hh_time

    * Display efficiency gain at bin == 360 (6-hour bin)
    summarize gain_vs_global if bin == 360, meanonly
    display "Efficiency gain of selected over global avg at bin 6h: " r(mean) "%"

    summarize gain_vs_hh if bin == 360, meanonly
    display "Efficiency gain of selected over hh_id avg at bin 6h: " r(mean) "%"

    summarize gain_vs_hh_time if bin == 360, meanonly
    display "Efficiency gain of selected over hh_id × time avg at bin 6h: " r(mean) "%"
	}

    // Plot
    frame rmse_results {
        twoway ///
            (line rmse_global bin, lcolor(blue%75) lpattern(shortdash)) ///
            (line rmse_hh bin, lcolor(blue%75) lpattern(dash_dot)) ///
            (line rmse_hh_time bin, lcolor(blue%75) lpattern(_)) ///
            (line rmse_best bin, lcolor(blue) lpattern(solid)) ///
            (line gain_vs_global bin, lcolor(orange) lpattern(solid) lwidth(thin) yaxis(2)), ///
            xlabel(0 "0" 60 "1" 120 "2" 180 "3" 240 "4" 300 "5" 360 "6" 420 "7" 480 "8" 540 "9" 600 "10" 660 "11" 720 "12") ///
            ylabel(, grid) ylabel(0(5)30, axis(2)) ///
            xtitle("Time bin size (hours)")  ///
            ytitle("RMSE (W)" " " " ") ytitle("Relative improvement (%)", axis(2)) ///
            legend(order(1 "Model 1" ///
                         2 "Model 2" ///
                         3 "Model 3" 4 "Selected" /// 
						 5 "Improvement: selected vs. Model 1") ///
                   pos(6) col(1) size(medsmall)) ///
            xsize(11) ysize(12)

        graph export "Fig_F20.pdf", replace     
	
	qui sum rmse_best if bin == 720
	local rmse_best_value_12h = r(mean)
	
	di "At 12h, Model 4's RMSE is: " 100*(1 - (`rmse_best_value_12h'/`mean_hp_p')) " % below the mean"
	
	}	
	
end

capture program drop App_F_Table_F8
program define App_F_Table_F8

use data_prepared, clear
    
drop if intervention_dummy == 1
drop if excl_from_cf == 1 & intervention_dummy == 0

// No time binning
					
	gen pred_error = hp_p - avg_cf_hp_p_spec

	// Wildboostrap regressions to get corrected p-values
				
		wildbootstrap reg pred_error t_in t_dhw t_out daily_min_t_out i.hs_index i.dow i.hourofday i.hh_id, cluster(hh_id) rseed(42) reps(100000)
		estimates store Model_1_5min

// Time binning 

	preserve

	local time_binning_hour = 4
	
	capture drop hour_bin
		
	gen hour_bin = floor(hourofday / `time_binning_hour') * `time_binning_hour'
					  
	collapse (mean) hp_p avg_cf_hp_p_spec t_in t_dhw t_out daily_avg_t_out daily_min_t_out, by(hh_id hour_bin date dow hs_index)

	gen pred_error = hp_p - avg_cf_hp_p_spec

	// Wildboostrap regressions to get corrected p-values

		wildbootstrap reg pred_error t_in t_dhw t_out daily_min_t_out i.hs_index i.dow i.hour_bin i.hh_id, cluster(hh_id) rseed(42) reps(100000)
		estimates store Model_2_4h
		
	restore

// Time binning 

	preserve

	local time_binning_hour = 8
	
		capture drop hour_bin

		
	gen hour_bin = floor(hourofday / `time_binning_hour') * `time_binning_hour'
					  
	collapse (mean) hp_p avg_cf_hp_p_spec t_in t_dhw t_out daily_avg_t_out daily_min_t_out, by(hh_id hour_bin date dow hs_index)

	gen pred_error = hp_p - avg_cf_hp_p_spec

		
	// Wildboostrap regressions to get corrected p-values

		wildbootstrap reg pred_error t_in t_dhw t_out daily_min_t_out i.hs_index i.dow i.hour_bin i.hh_id, cluster(hh_id) rseed(42) reps(100000)
		estimates store Model_3_8h
		
	restore	
	
// Time binning 

	preserve

	local time_binning_hour = 12
		
	capture drop hour_bin
		
	gen hour_bin = floor(hourofday / `time_binning_hour') * `time_binning_hour'
					  
	collapse (mean) hp_p avg_cf_hp_p_spec t_in t_dhw t_out daily_avg_t_out daily_min_t_out, by(hh_id hour_bin date dow hs_index)

	gen pred_error = hp_p - avg_cf_hp_p_spec

	// Wildboostrap regressions to get corrected p-values

		wildbootstrap reg pred_error t_in t_dhw t_out daily_min_t_out i.hs_index i.dow i.hour_bin i.hh_id, cluster(hh_id) rseed(42) reps(100000)
		estimates store Model_4_12h
		
	restore
		
// Output table

estout Model_1_5min Model_2_4h Model_3_8h  Model_4_12h, ///
  drop(_cons) cells(b(fmt(%9.3f)))  ///
  stats(r2_a N, labels("Adj. R-Square" "N"))
  di "! The p-values reported by estout do not correspond to the bootstrapped p-values but to the original unclustered OLS ones. p-values derived from Wild bootstrap have to be entered manually, from the wildboostrap output tables directly." 

		
end

********************************************************************************
* Appendix G: Regression analysis of the rebound energy consumption            *
*             in the post-intervention period                                  *
********************************************************************************
capture program drop App_G_Table_G9
program define App_G_Table_G9

// First we need the study of the rebound, i.e. we need to run: 

Fig_4_rebound_post_inter

// Generating the explanatory variables

		capture drop constant
		gen constant = 1

    // Temperature difference between the setpoint decided by the user and the observed value 
        capture drop diff_set
        gen diff_set = t_set - t_in

    // Repeating the final conditions until 16h after the end of the intervention 
        sort hh_id time

        capture drop T_in_f 
        capture drop T_DHW_f
        capture drop hourofday_f
        capture drop diff_set_f

        gen T_in_f = t_in if time_diff_from_end_5min == 0
        replace T_in_f = T_in_f[_n-1] if missing(T_in_f) & !missing(time_diff_from_end_5min)

        gen T_DHW_f = t_dhw if time_diff_from_end_5min == 0
        replace T_DHW_f = T_DHW_f[_n-1] if missing(T_DHW_f) & !missing(time_diff_from_end_5min)

        gen hourofday_f = hourofday if time_diff_from_end_5min == 0
        replace hourofday_f = hourofday_f[_n-1] if missing(hourofday_f) & !missing(time_diff_from_end_5min)

        gen diff_set_f = diff_set if time_diff_from_end_5min == 0
        replace diff_set_f = diff_set_f[_n-1] if missing(diff_set_f) & !missing(time_diff_from_end_5min)

    // TOD categories for the moment of the day the intervention ended
        capture drop morning_f 
        capture drop afternoon_f evening_f night_f

        gen morning_f = 0 
        replace morning_f = 1 if hourofday_f > 6 & hourofday_f <= 12

        gen afternoon_f = 0 
        replace afternoon_f = 1 if hourofday_f > 12 & hourofday_f <= 18

        gen evening_f = 0
        replace evening_f = 1 if (hourofday_f > 18 & hourofday_f <= 23) | hourofday_f == 0 

        gen night_f = 0 
        replace night_f = 1 if hourofday_f > 0 & hourofday_f <= 6

    // Minimum - or average - outdoor temperature within 16h after the intervention stop 
        sort hh_id time

        capture drop min_t_out_within_16h
        capture drop avg_t_out_within_16h

        gen min_t_out_within_16h = .
        gen avg_t_out_within_16h = .

        qui {
            forvalues i = 1/`=_N' {
                if time_diff_from_end_5min[`i'] == 0 {
                    local start = `i'
                    local end = `i'
                    while (time_diff_from_end_5min[`end'] < 16*60 & time_diff_from_end_5min[`end'] >= 0) {
                        local end = `end' + 1
                    }

                    local min_t = t_out[`start']
                    local avg_t = 0
                    local count = 0

                    forvalues j = `start'/`end' {
                        local min_t = min(`min_t', t_out[`j'])
                        local avg_t = `avg_t' + t_out[`j']
                        local count = `count' + 1
                    }
                    local avg_t = `avg_t' / `count'

                    forvalues j = `start'/`end' {
                        replace min_t_out_within_16h = `min_t' in `j'
                        replace avg_t_out_within_16h = `avg_t' in `j'
                    }
                }
            }
        }
		
// Without HH-FE

    // Model 1

    wildbootstrap reg energy_rebound_after_int_16h T_in_f avg_t_out_within_16h constant if time_diff_from_end_5min == 960, hascons cluster(hh_id) rseed(42) reps(100000)
    estimates store Model_1_e

    // Model 2

    wildbootstrap reg energy_rebound_after_int_16h diff_set_f avg_t_out_within_16h constant if time_diff_from_end_5min == 960, hascons cluster(hh_id) rseed(42) reps(100000)
    estimates store Model_2_e

// With FE

    // Model 3

    wildbootstrap reg energy_rebound_after_int_16h diff_set_f avg_t_out_within_16h i.hh_id if time_diff_from_end_5min == 960, cluster(hh_id) rseed(42) reps(100000)
    estimates store Model_3_e

    // Model 4

    wildbootstrap reg energy_rebound_after_int_16h diff_set_f avg_t_out_within_16h morning_f evening_f night_f i.hh_id if time_diff_from_end_5min == 960, cluster(hh_id) rseed(42) reps(100000)
    estimates store Model_4_e

// Table 8

    estout Model_1_e Model_2_e Model_3_e Model_4_e, ///
      drop(_cons) cells(b(fmt(%9.3f)))  ///
      stats(r2_a N, labels("Adj. R-Square" "N obs"))
      di "! The p-values reported by estout do not correspond to the bootstrapped p-values but to the original unclustered OLS ones. p-values derived from Wild bootstrap have to be entered manually, from the wildboostrap output tables directly."

// Other parametrization mentioned in the text:

di "Other parametrizations mentioned in the text:"

	// No HH-FE:

	capture drop T_DHW_f_dec 
	capture drop T_DHW_f_non_dec 

	gen T_DHW_f_dec = T_DHW_f * decoupled
	gen T_DHW_f_non_dec = T_DHW_f * (1-decoupled)

	wildbootstrap reg energy_rebound_after_int_16h diff_set_f T_DHW_f_dec T_DHW_f_non_dec avg_t_out_within_16h morning_f evening_f night_f constant if time_diff_from_end_5min == 960, cluster(hh_id) rseed(42) reps(100000) hascons

	ci means T_DHW_f_non_dec if decoupled == 0 & time_diff_from_end_5min == 960 // Little variability

	// FE: 

	wildbootstrap reg energy_rebound_after_int_16h diff_set_f T_DHW_f avg_t_out_within_16h morning_f evening_f night_f i.hh_id if time_diff_from_end_5min == 960, cluster(hh_id) rseed(42) reps(100000)

	  
end

********************************************************************************
* Appendix H: Correlation analysis of intervention habituation over time       *
********************************************************************************
capture program drop App_H_sequencing_interventions
program define App_H_sequencing_interventions

use data_prepared, clear
sort hh_id time

// Identification of the successive order in which interventions were experienced by households...
capture drop intervention_consecutive_order*

    // ... throughout the whole experiment
        sort hh_id time

        // Generate a variable to count interventions in order, initializing it with missing values for now
        gen intervention_consecutive_order = .

        // Loop through each household
        levelsof hh_id, local(households)

        foreach hh in `households' {
            local int_count = 0

            // Loop over all observations for the current household
            quietly forvalues i = 1/`=_N' {
                // If the household matches and reason_stop is not 0, update the count
                if hh_id[`i'] == `hh' & reason_stop[`i'] != 0 {
                    // Increment the intervention count
                    local ++int_count
                    // Replace intervention_consecutive_order for the specific observation using the row number `i'
                    replace intervention_consecutive_order = `int_count' in `i'
                }
            }
        }

    // ... for HS1 and HS2 separately
        sort hh_id hs_index time

        // Generate variables to count interventions in order for each heating season
        gen intervention_consecutive_order_1 = .
        gen intervention_consecutive_order_2 = .

        // Loop through each household
        levelsof hh_id, local(households)

        foreach hh in `households' {
            local int_count_HS1 = 0
            local int_count_HS2 = 0

            quietly forvalues i = 1/`=_N' {
                // HS1:
                if hh_id[`i'] == `hh' & hs_index[`i'] == 1 & reason_stop[`i'] != 0 {
                    local ++int_count_HS1
                    replace intervention_consecutive_order_1 = `int_count_HS1' in `i'
                }

                // HS2:
                if hh_id[`i'] == `hh' & hs_index[`i'] == 2 & reason_stop[`i'] != 0 {
                    local ++int_count_HS2
                    replace intervention_consecutive_order_2 = `int_count_HS2' in `i'
                }
            }
        }
	
// Variable for manual overrule

capture drop manual_overrule
gen manual_overrule = 0 
replace manual_overrule = 1 if reason_stop != 0 & reason_stop != -1 & reason_stop != -2	

end
	
capture program drop App_H_Table_H10
program define App_H_Table_H10

	App_H_sequencing_interventions

	frame change default
	capture frame drop corr_results_frame

    postutil clear

    // Work in a new frame for results
    frame create corr_results_frame
    frame change corr_results_frame

    // Create an empty results matrix
tempfile results
    postfile corr_results str12 hh_id str12 corr_hs1 str12 pval_hs1 str12 nobs_hs1 str12 corr_hs2 str12 pval_hs2 str12 nobs_hs2 str12 corr_pooled str12 pval_pooled str12 nobs_pooled using `results'

    // Return to default frame for calculations
    frame change default

    levelsof hh_id, local(hhids)
    foreach id of local hhids {
        // ===== CHECK PARTICIPATION =====
        quietly count if hh_id == `id' & !missing(intervention_consecutive_order_1)
        local has_hs1 = r(N) > 0

        quietly count if hh_id == `id' & !missing(intervention_consecutive_order_2)
        local has_hs2 = r(N) > 0

        quietly count if hh_id == `id' & !missing(intervention_consecutive_order)
        local has_pooled = r(N) > 0

        // ===== CHECK OVERRULES =====
        quietly count if hh_id == `id' & manual_overrule == 1
        local has_overrule = r(N) > 0

        // ======== HS1 CORRELATION ========
        if `has_hs1' {
            if `has_overrule' {
                quietly pwcorr manual_overrule intervention_consecutive_order_1 if hh_id == `id', sig
                if r(N) < 2 | missing(r(rho)) {
                    local corr_hs1 "-"
					local pval_hs1 "-"
					local nobs_hs1 "0"
                }
                else {
                    local corr_hs1 = string(r(rho), "%5.2f")
					local pval_hs1 = string(r(sig)[1,2], "%5.2f")		
					quietly count if manual_overrule == 1 & hs_index == 1 & hh_id == `id'
					local nobs_hs1 = string(r(N))
                }
            }
            else {
                local corr_hs1 "-"
				local pval_hs1 "-"
				local nobs_hs1 "0"
            }
        }
        else {
            local corr_hs1 "X"
     		local pval_hs1 ""
     		local nobs_hs1 ""
        }

        // ======== HS2 CORRELATION ========
        if `has_hs2' {
            if `has_overrule' {
                quietly pwcorr manual_overrule intervention_consecutive_order_2 if hh_id == `id', sig
                if r(N) < 2 | missing(r(rho)) {
                    local corr_hs2 "-"
					local pval_hs2 "-"
					local nobs_hs2 "0"
                }
                else {
                    local corr_hs2 = string(r(rho), "%5.2f")
					local pval_hs2 = string(r(sig)[1,2], "%5.2f")
					quietly count if manual_overrule == 1 & hs_index == 2 & hh_id == `id'
					local nobs_hs2 = string(r(N))				
                }
            }
            else {
                local corr_hs2 "-"
				local pval_hs2 "-"
				local nobs_hs2 "0"
            }
        }
        else {
            local corr_hs2 "X"
     		local pval_hs2 ""
     		local nobs_hs2 ""
        }

        // ======== POOLED CORRELATION ========
        if `has_pooled' {
            if `has_overrule' {
                quietly pwcorr manual_overrule intervention_consecutive_order if hh_id == `id', sig
                if r(N) < 2 | missing(r(rho)) {
                    local corr_pooled "-"
					local pval_pooled "-"
            		local nobs_pooled "0"
                }
                else {
                    local corr_pooled = string(r(rho), "%5.2f")
					local pval_pooled = string(r(sig)[1,2], "%5.2f")
					quietly count if manual_overrule == 1 & hh_id == `id'
					local nobs_pooled = string(r(N))				
                }
            }
            else {
                local corr_pooled "-"
				local pval_pooled = "-"
         		local nobs_pooled "0"
            }
        }
        else {
            local corr_pooled "X"
     		local pval_pooled ""
     		local nobs_pooled ""
        }

        // Store results
        frame change corr_results_frame
        post corr_results ("`id'") ("`corr_hs1'") ("`pval_hs1'") ("`nobs_hs1'") ("`corr_hs2'") ("`pval_hs2'") ("`nobs_hs2'") ("`corr_pooled'") ("`pval_pooled'") ("`nobs_pooled'")
        frame change default
    }

	// ======== ADD OVERALL SAMPLE CORRELATIONS ========
	frame change default 
	
    quietly pwcorr manual_overrule intervention_consecutive_order_1, sig
    local overall_corr_hs1 = string(r(rho), "%5.2f")
    local overall_pval_hs1 = string(r(sig)[1,2], "%5.2f")
	quietly count if manual_overrule == 1 & hs_index == 1
	local overall_nobs_hs1 = string(r(N))
	
    quietly pwcorr manual_overrule intervention_consecutive_order_2, sig
    local overall_corr_hs2 = string(r(rho), "%5.2f")
    local overall_pval_hs2 = string(r(sig)[1,2], "%5.2f")
	quietly count if manual_overrule == 1 & hs_index == 2
	local overall_nobs_hs2 = string(r(N))
					
    quietly pwcorr manual_overrule intervention_consecutive_order, sig
    local overall_corr_pooled = string(r(rho), "%5.2f")
    local overall_pval_pooled = string(r(sig)[1,2], "%5.2f")
	quietly count if manual_overrule == 1 
	local overall_nobs_pooled = string(r(N))			

    frame change corr_results_frame
    post corr_results ("All sample") ("`overall_corr_hs1'") ("`overall_pval_hs1'") ("`overall_nobs_hs1'") ("`overall_corr_hs2'") ("`overall_pval_hs2'") ("`overall_nobs_hs2'") ("`overall_corr_pooled'") ("`overall_pval_pooled'") ("`overall_nobs_pooled'")
    frame change default
	
    // Close postfile and display results
    frame change corr_results_frame
    postclose corr_results

    use `results', clear
    list, separator(0)

    // Save results to CSV
    export delimited "App_H_Habituation_analysis.csv", replace

    frame change default
	
	// Other checks in the text:
	
		// 1. Temperature drop across households that (never) manually overruled:
		
			di "Difference in temperature drop across households 1, 2, 8 and the others:"
			
			qui gen indicator_test = 0
			qui replace indicator_test = 1 if hh_id == 1 | hh_id == 2 | hh_id == 8

			capture drop temperature_drop 
			gen temperature_drop = t_in_0 - t_in
			
			ttest temperature_drop if reason_stop != 0 , by(indicator_test) une
			
		// 2. Does temperature drop correlation with intervention sequence number: 
		
			di "Correlation between temperature and intervention sequence number within a single heating season:"
			
			pwcorr temperature_drop intervention_consecutive_order_1, obs sig star(0.05)
			pwcorr temperature_drop intervention_consecutive_order_2, obs sig star(0.05)
	
end

// End of file