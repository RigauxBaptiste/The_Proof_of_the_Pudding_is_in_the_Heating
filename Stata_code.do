********************************************************************************
*               The Proof of the Pudding is in the Heating:                    *
*    a Field Experiment on Household Engagement with Heat Pump Flexibility     *
*                      December 2024 - Updated January 2025    				   *
*            Baptiste Rigaux°, Sam Hamels° and Marten Ovaere°                  *
*         ° Department of Economics, Ghent University (Belgium)                *
********************************************************************************

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
* Note that the program 'experiment_data_preparation' is necessary for all other programs below it. 
* The code is structured around Tables and Figures but also presents the commands used to interpret the results in the text (e.g. t-tests).

program define run_all
// Section 2:
T1_participants_characteristics // Table 1
Data_experiment_data_preparation // Data preparation (prerequisite for other Tables/Figures) - output: data_prepared.dta
// Section 4:
T2_data_duration_reason_stops // (Data for) Table 2
F1_histogram_duration // Figure 1
T3_regression_duration // Table 3
F2_pow_temp_profiles // Figure 2 (both panels)
F3_histogram_kWh_saved // Figure 3
F4_rebound_post_inter // Figure 4 (both panels)
F5_6_pow_cons_during_event // Figure 5 (both panels) and Figure 6
F7_flex_event_temp // Figure 7 (all panels) and Figure 8 
F8_both_panels // Figure 8 (both panels) ; using the dataset outputted by the Python code (but already included in the archive for convenience)
F9_hist_temp_drop // Figure 9
Study_manual_overrules // Comment in the text: timing of manual overrules + evidence of fewer manual overrules later in the heating season
// Appendices: 
App_F10_hist_pow_temp 
App_F11_pow
App_F12_pow_profile_temp
App_F13_share_of_HPs
App_T4_HS_temp
App_T5_sample_composition
App_F16_random_inter 
App_T6_reg_rebound_kWh
end

// run_all // uncomment this line to run the whole program 

********************************************************************************
* Table 1: Participants' characteristics									   *
********************************************************************************

program define T1_participants_characteristics
// This programs returns as an output three .tex files for each panel of Table 1:
// Table1_1.tex, Table1_2.tex, Table1_3.tex

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

    file open latex_table using "Table1_1.tex", write text replace

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

    file open latex_table using "Table1_2.tex", write text replace

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

    file open latex_table using "Table1_3.tex", write text replace

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
	
end
	
********************************************************************************
* Experiment data preparation            									   *
********************************************************************************

program define Data_experiment_data_preparation
// This programs prepares the dataset from the field experiment.
// Necessary to run the rest of the program.
// Output: data_prepared.dta

use experiment_data, clear

// Additional time variables 

    // Variable that bins the time of day into categories of 5 mins: from 0 to 287 (288 categories in total)
    capture drop five_min_level_int
    gen five_min_level_int = int(hourofday * 12 + minofhour / 5)
    // Variable 'window_unique_index' that starts 6h before an intervention and ends 48h after (useful for plotting and excluding some observations for the counterfactual)
    local window_elapsed_minus_hours 6
    local window_elapsed_plus_hours 48
    local exclude_from_CF_before_minutes 20
    local exclude_from_CF_after_minutes 16*60 // 16 hours

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
    local max_time_after_int_end 16.1*60 // 16.1 hours : in practice we won't look further than 16 hours. But the .1 allows for extra observations at time_diff_from_end_5min == 960 after rounding up. 

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

    // Average temperature during an intervention
    capture drop avg_temp_during_int
    egen avg_temp_during_int = mean(t_out), by(hh_id unique_index) 
    replace avg_temp_during_int = round(avg_temp_during_int, 0.1)
    replace avg_temp_during_int = . if unique_index == 0 | missing(unique_index)

    // Monthly averages of outdoor temperature 
    capture drop monthly_avg_hs
    egen monthly_avg_hs = mean(daily_avg_t_out), by(monthofyear hs_index)

    // Identify the average temperature within 18 hours after an intervention is initiated
    local window_first_phase_event 18*60*60*1000 // 18 hours

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

// Counterfactual HP power
capture drop avg_cf_hp_p_spec
capture drop sem_cf_hp_p_spec

    // Calculating the counterfactual power (specific to each HP and time of day, excluding observations that are too close to the start/end of an intervention)
    preserve
        collapse (mean) avg_cf_hp_p_spec = hp_p (semean) sem_cf_hp_p_spec = hp_p, by(hh_id five_min_level_int intervention_dummy excl_from_cf)

        drop if intervention_dummy == 1
        drop if excl_from_cf == 1 & intervention_dummy == 0

        gen ul_cf_hp_p_spec = avg_cf_hp_p_spec + 1.96 * sem_cf_hp_p_spec
        gen ll_cf_hp_p_spec = avg_cf_hp_p_spec - 1.96 * sem_cf_hp_p_spec

        tempfile counterfactuals
        save `counterfactuals', replace
    restore

    // Matching the counterfactual with the original dataset 
    merge m:1 hh_id five_min_level_int using `counterfactuals'
    drop _merge
		
sort hh_id time
save data_prepared, replace


// Counterfactual indoor temperature
capture drop avg_cf_t_in_spec
capture drop sem_cf_t_in_spec

    // Calculating the counterfactual power (specific to each HP and time of day, excluding observations that are too close to the start/end of an intervention)
    preserve
        collapse (mean) avg_cf_t_in_spec = t_in (semean) sem_cf_t_in_spec = t_in, by(hh_id five_min_level_int intervention_dummy excl_from_cf)

        drop if intervention_dummy == 1
        drop if excl_from_cf == 1 & intervention_dummy == 0

        gen ul_cf_t_in_spec = avg_cf_t_in_spec + 1.96 * sem_cf_t_in_spec
        gen ll_cf_t_in_spec = avg_cf_t_in_spec - 1.96 * sem_cf_t_in_spec

        tempfile counterfactuals
        save `counterfactuals', replace
    restore

    // Matching the counterfactual with the original dataset 
    merge m:1 hh_id five_min_level_int using `counterfactuals'
    drop _merge
    
sort hh_id time

save data_prepared, replace

end

********************************************************************************
* Table 2: Duration of interventions and stopping scenarios					   *
********************************************************************************

program define T2_data_duration_reason_stops
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

program define F1_histogram_duration
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
    graphregion(color(white) margin(zero))  xsize(5) ysize(5)  

graph export "Figure1.pdf", replace

end

********************************************************************************
* Table 3: Regression of intervention duration								   *
********************************************************************************

program define T3_regression_duration 
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

// Text:

ci means t_dhw_0_notdec_geq_40 if reason_stop != 0 & t_dhw_0_notdec_geq_40 != 0
ci means t_dhw_0_dec if reason_stop != 0 & t_dhw_0_dec != 0

// Regression: 

    // Without HH-FE

        // Model 1

        wildbootstrap reg total_duration_int_hour t_in_0 min_t_out_5h t_dhw_0_dec t_dhw_0_notdec_geq_40 constant if reason_stop != 0, hascons cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_1_d
        matrix list r(table)

        // Model 2

        wildbootstrap reg total_duration_int_hour i.notif_0 t_in_0 min_t_out_5h t_dhw_0_dec t_dhw_0_notdec_geq_40 constant if reason_stop != 0, hascons cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_2_d
        matrix list r(table)

    // With HH FE

        // Model 3

        wildbootstrap reg total_duration_int_hour i.notif_0 t_in_0 min_t_out_5h t_dhw_0 i.hh_id if reason_stop != 0, cluster(hh_id) rseed(42) reps(100000)
        estimates store Model_3_d
        matrix list r(table)

        // Model 4

        wildbootstrap reg total_duration_int_hour i.notif_0 t_in_0 min_t_out_5h t_dhw_0 ib(14).hourofday_0 i.hh_id if reason_stop != 0, cluster(hh_id) rseed(42) reps(100000)
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

program define F2_pow_temp_profiles
// This program plots the indoor temperature and heat pump power profiles in Fig 2.
// Both panels.

use data_prepared, clear
sort hh_id time

* Indoor temperature

	// Quantitative effect of an intervention on indoor temperature

	ttest t_in, by(intervention_dummy) une
	wildbootstrap reg t_in intervention_dummy i.hh_id, cluster(hh_id) rseed(42) reps(100000) // Household-fixed effects

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

			graph export "Figure2_left.pdf", width(8) height(8) replace

	restore

* Heat pump power
		
	// Quantitative effect of an intervention on HP power

	ttest hp_p, by(intervention_dummy) une
	wildbootstrap reg hp_p intervention_dummy i.hh_id, cluster(hh_id) rseed(42) reps(100000) // Household-fixed effects

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

			graph export "Figure2_right.pdf", replace

	restore
	
end

********************************************************************************
* Figure 3: Histogram of consumption saved during interventions (kWh)          *
********************************************************************************

program define F3_histogram_kWh_saved
// This program plots the histogram of Fig. 3

use data_prepared, clear
sort hh_id time

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
	
// Analysis of the energy consumption saved during the intervention

ci means energy_saved_int if reason_stop != 0 // Represents only part of the variability, across the means. But ignores the variability on the CF, leading to variability in each mean. 
pwcorr energy_saved_int total_duration_int_hour if reason_stop != 0, obs sig star(0.05)

qui sum energy_saved_int if reason_stop != 0
local avg_energy_shift_spec = r(mean)

// Fig. 3: histogram of the consumption decrease

twoway hist energy_saved_int if reason_stop != 0 & energy_saved_int < 15, width(0.5) aspectratio(1) xtitle("Average electricity consumption reduction (kWh)" "during interventions") xlabel(0(2.5)15) color(blue%35) ///
	 graphregion(color(white) margin(zero))  xsize(5) ysize(5) xline(`avg_energy_shift_spec', lcolor(edkblue) lwidth(1.5 pt)) 

graph export "Figure3.pdf", replace

end

********************************************************************************
* Figure 4: Rebound power (W) and consumption (kWh) after interventions        *
********************************************************************************

program define F4_rebound_post_inter
// This program plots both panels of Fig. 4
// Standard errors are derived from the variability of the mean quantity at each bin for time after intervention stop (at the 5 min-level); i.e. does not fully account for the autocorrelation structure in the errors, nor the intra-household variability. 

use data_prepared, clear
sort hh_id time

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
    
    // Plot Fig. 4 - right

    twoway lpoly energy_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 960, clcolor(orange) degree(0) ///
         || rarea ul_energy_rebound_smooth ll_energy_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 960, sort fcolor(orange%30) lcolor(orange%0) ///
        aspectratio(1) ytitle("Average post-intervention" "electricity consumption increase (kWh)") ylabel(0(0.5)3.5) ///
        xtitle("Time to intervention stop (h)") xlabel(0 "0" 120 "2" 240 "4" 360 "6" 480 "8" 600 "10" 720 "12" 840 "14" 960 "16") ///
        legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) graphregion(color(white) margin(zero))  xsize(8) ysize(8)  

    graph export "Figure4_right.pdf", width(8) height(8) replace

restore

// Plot Fig. 4 - left

preserve

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
    
    // Plot Fig. 4 - left

    twoway lpoly power_rebound_after_int time_diff_from_end_5min if time_diff_from_end_5min <= 960, clcolor(orange) degree(0) ///
        || rarea ul_power_rebound_smooth ll_power_rebound_smooth time_diff_from_end_5min if time_diff_from_end_5min <= 960, sort fcolor(orange%30) lcolor(orange%0)  ///
        aspectratio(1) xlabel(0 "0" 120 "2" 240 "4" 360 "6" 480 "8" 600 "10" 720 "12" 840 "14" 960 "16") xtitle("Time to intervention stop (h)") ///
        ylabel(-100(100)900) ytitle("Average post-intervention" "power consumption increase (W)") yline(0) ///
        legend(order(1 "Average (across interventions)" 2 "95% CI") cols(2) pos(6) size(small)) graphregion(color(white) margin(zero))  xsize(8) ysize(8)  

graph export "Figure4_left.pdf", replace

restore

end

********************************************************************************
* Figures 5 and 6: Power profile (Fig. 5 left),                                *
*				   Net power reduction (Fig. 5 right),                         *
*                  Net consumption reduction (Fig. 6);                         *
* after a flexibility event is initiated                                       *
********************************************************************************

program define F5_6_pow_cons_during_event
// This program plots both panels of Fig. 5 and Fig. 6

use data_prepared, clear
sort hh_id time

preserve

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

    // Calculate the optimal BW for average control curve (cf_avg_bin_spec)
    lpoly avg_cf_hp_p_spec_fleet five_min_level_elapsed if (before == 1 | after == 1), degree(0)
    local bw_cf = r(bwidth)

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

// Plot Fig. 5 - left 

    twoway ///
        lpoly hp_p five_min_level_elapsed if before == 1,  clcolor(blue)  bw(`bw_hp_p') ///
        || lpoly hp_p five_min_level_elapsed if after == 1,  clcolor(blue)  bw(`bw_hp_p') ///
        || rarea UL_sm_before LL_sm_before five_min_level_elapsed if before == 1, sort fcolor(blue%30) lcolor(blue%0) ///
        || rarea UL_sm_after LL_sm_after five_min_level_elapsed if after == 1, sort fcolor(blue%30) lcolor(blue%0) ///
        || lpoly avg_cf_hp_p_spec_fleet five_min_level_elapsed if (before == 1 | after == 1), clcolor(green) bw(`bw_cf') ///
        || rarea UL_cf_sm LL_cf_sm five_min_level_elapsed if (before == 1 | after == 1), sort fcolor(green%30) lcolor(green%0) ///
        aspectratio(1) xline(0, lwidth(thin) lcolor(gray)) xlabel(-360 "-6" 0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ///
        ylabel(0(100)600) ytitle("Average HP power in the fleet (W)") ///
        legend(order(1 "Average across interventions" 3 "95% CI" 5 "Control" 6 "95% CI" ) cols(2) pos(6) size(small)) ///
        graphregion(color(white) margin(zero)) xsize(8) ysize(8) 

    // Export the plot
    graph export "Figure5_left.pdf", width(8) height(8) replace

// Plot Fig. 5 - right 

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

    //  Plot the graph
    twoway lpoly power_reduction five_min_level_elapsed, clcolor(orange) yline(0) ///
        || rarea ul_power_reduction_sm ll_power_reduction_sm five_min_level_elapsed, sort color(orange%30) lcolor(orange%0) ///
       xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") ylabel(-200(50)300) ///
        xtitle("Time to flexibility event start (h)") ytitle("Average HP power reduction in the fleet (W)") legend(order(1 "Average across interventions" 2 "95% CI" ) cols(2) pos(6) size(small)) ///
        graphregion(color(white) margin(zero)) xsize(8) ysize(8)

    // Export the plot
    graph export "Figure5_right.pdf", replace

// Quantification of the power reduction

ci means power_reduction if five_min_level_elapsed <= 60 // 1 hours
ci means power_reduction if five_min_level_elapsed <= 1080 // 18 hours
ci means power_reduction if five_min_level_elapsed > 1080 & five_min_level_elapsed <= 2160 // From 18h to 36h (fleet-rebound period)

sum power_reduction if five_min_level_elapsed > 1080 & five_min_level_elapsed <= 2160 // From 18h to 36h (fleet-rebound period)

// Plot Fig. 6 

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

    //  Plot the graph
    twoway lpoly cumulative_net_energy_saved five_min_level_elapsed, lcolor(orange) degree(0) ///
         || rarea ul_cumul_net_energy_saved_sm ll_cumul_net_energy_saved_sm five_min_level_elapsed if five_min_level_elapsed > 0, sort fcolor(orange%30) lcolor(orange%0)  ///
        xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ///
        ytitle("Average electricity consumption" "reduction per HP in the fleet (kWh)") ylabel(-2.5(0.5)5) yline(0) legend(pos(6)) yline(0) xline(1080, lcolor(dkorange) lp(dash_dot)) xline(2160, lcolor(dkorange) lp(dash_dot)) ///
        legend(order(1 "Average across interventions" 2 "CI") cols(2) pos(6) size(small)) ////
        graphregion(color(white) margin(zero))  xsize(8) ysize(8) 

    // Export the plot
    graph export "Figure6.pdf", replace

restore

end

********************************************************************************
* Figure 7                   										           *
********************************************************************************

program plot_flex_event_power_profile
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

	// Export the plot
	graph export "FigureA14_`bin_value'.pdf", replace

	// Clean up variables
	drop UL_cf_sm LL_cf_sm UL_sm_before LL_sm_before UL_sm_after LL_sm_after

end

program plot_flex_event_power_reduction
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

	// Export the plot
	graph export "FigureA15_`bin_value'.pdf", replace

	// Clean up variables
	drop ul_power_reduction_sm ll_power_reduction_sm

end

program define F7_flex_event_temp
// This program plots all panels of Fig. 7

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

    plot_flex_event_power_profile 1
    plot_flex_event_power_profile 2
    plot_flex_event_power_profile 3
    plot_flex_event_power_profile 4

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

    plot_flex_event_power_reduction 1
    plot_flex_event_power_reduction 2
    plot_flex_event_power_reduction 3
    plot_flex_event_power_reduction 4

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

    graph export "Figure7.pdf", replace

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
* Figure 8										                               *
********************************************************************************

program define F8_both_panels
// This program plots all panels of Fig. 8

// Preamble

frame change default

capture frame drop monetary_valuation_heterogeneous
frame create monetary_valuation_heterogeneous
frame change monetary_valuation_heterogeneous

import delimited "money_shifted_heterogeneous.csv", clear // Output from 'Building_dataset_monetary_valuation_flex_event.py' (code attached)

drop if temp_heterogeneity_category == "nan"

drop if missing(phase2_avg_money) // Too far into the season, last observations do not even have 36h after the start.

// Text:

ci means phase1_avg_money
ci means phase2_avg_money

pwcorr dam_price temp if temp_heterogeneity_category == "bel3", sig star(0.05)
pwcorr dam_price temp if temp_heterogeneity_category == "b36", sig star(0.05)
pwcorr dam_price temp if temp_heterogeneity_category == "b69", sig star(0.05)
pwcorr dam_price temp if temp_heterogeneity_category == "ab9", sig star(0.05)
	
// Figure 8 - right 

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

    graph export "Figure8_right.pdf", replace

    restore

// Figure 8 - left:

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

    graph export "Figure8_left.pdf", replace
	
	// Text: 
	
	ci means phase2_avg_money if time_share2 >= 90
	ci means phase2_avg_money if time_share2 >= 95
	ci means phase2_avg_money if time_share2 >= 99
	sum phase2_avg_money
    sum phase2_avg_money if phase2_avg_money <= 0

	keep if time_share2 >= 95 // Mostly Nov - Dec 2022: peak of energy crisis
	
	frame change default

end

********************************************************************************
* Figure 9: Histogram of temperature drop							           *
********************************************************************************

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

graph export "Figure9.pdf", replace

end

* Study of manual overrules frequency throughout the experiment 

program define Study_manual_overrules

use data_prepared, clear
sort hh_id time

// Timing of manual overrules

capture drop period_of_day_f

gen period_of_day_f = 0 
replace period_of_day_f = 1 if hourofday > 6 & hourofday <= 12
replace period_of_day_f = 2 if hourofday > 12 & hourofday <= 18
replace period_of_day_f = 3 if (hourofday > 18 & hourofday <= 23) | hourofday == 0 
replace period_of_day_f = 4 if hourofday > 0 & hourofday <= 6 

tab period_of_day_f if reason_stop == -3

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

// Binning the interventions in groups of 5 successives interventions on each household
    local bin_group = 5

    capture drop order_group
    capture drop order_group_1 
    capture drop order_group_2

    gen order_group = floor((intervention_consecutive_order - 1) /`bin_group') + 1 if intervention_consecutive_order >= 0
    gen order_group_1 = floor((intervention_consecutive_order_1 - 1) /`bin_group') + 1 if intervention_consecutive_order_1 >= 0
    gen order_group_2 = floor((intervention_consecutive_order_2 - 1) /`bin_group') + 1 if intervention_consecutive_order_2 >= 0

    qui sum order_group
    local max_group = r(max)
	
// Level 1: is there correlation between a dummy for manual overrule and the order in which the intervention is experienced...

    capture drop manual_overrule
    gen manual_overrule = 0 
    replace manual_overrule = 1 if reason_stop != 0 & reason_stop != -1 & reason_stop != -2

    // ... over the whole sample
        pwcorr manual_overrule intervention_consecutive_order if hs_index == 2, sig star(0.05) // Significant, negligible

    // ... within each HS separately 
        pwcorr manual_overrule intervention_consecutive_order_1 if hs_index == 1, sig star(0.05) o // Significant, negligible
        pwcorr manual_overrule intervention_consecutive_order_2 if hs_index == 2, sig star(0.05) o // Not significant

// Level 2: is there correlation between the share of manually overruled interventions within bins and the bin indicator, indicating in which order ('batch') the intervention is experienced...

    // Work in another frame
    frame change default
    capture frame drop manual_overrule_habituation
    frame put intervention_consecutive_order intervention_consecutive_order_1 intervention_consecutive_order_2 manual_overrule hs_index reason_stop order_group order_group_1 order_group_2, into(manual_overrule_habituation)

    frame change manual_overrule_habituation
    keep if !missing(intervention_consecutive_order)
    sort intervention_consecutive_order_1 intervention_consecutive_order_2
    tab manual_overrule

    // ... over the whole sample
        capture drop total_interventions
        capture drop manual_overrules
        capture drop percent_overruled

        egen total_interventions = count(intervention_consecutive_order), by(order_group)
        egen manual_overrules = total(manual_overrule), by(order_group)
        gen percent_overruled = (manual_overrules / total_interventions) * 100

    // ... within each HS separately

        // HS 1
            capture drop total_interventions_1
            capture drop manual_overrules_1
            capture drop percent_overruled_1

            egen total_interventions_1 = count(intervention_consecutive_order_1), by(order_group_1)
            egen manual_overrules_1 = total(manual_overrule), by(order_group_1)
            gen percent_overruled_1 = (manual_overrules_1 / total_interventions_1) * 100

        // HS 2
            capture drop total_interventions_2
            capture drop manual_overrules_2
            capture drop percent_overruled_2

            egen total_interventions_2 = count(intervention_consecutive_order_2), by(order_group_2)
            egen manual_overrules_2 = total(manual_overrule), by(order_group_2)
            gen percent_overruled_2 = (manual_overrules_2 / total_interventions_2) * 100

    // Results: 
        // Whole sample:
            pwcorr manual_overrule  intervention_consecutive_order, sig star(0.05) o // Non significant
            pwcorr percent_overruled  order_group, sig star(0.05) o // Significant, weak 

        // Throughout HS1: 
            pwcorr manual_overrule  intervention_consecutive_order_1, sig star(0.05) o // Significant, weak
            pwcorr percent_overruled_1  order_group_1, sig star(0.05) o // Significant, strong

        // Throughout HS2: 
            pwcorr manual_overrule  intervention_consecutive_order_2, sig star(0.05) o // Non significant
            pwcorr percent_overruled_2  order_group_2, sig star(0.05) o // Significant, moderate

    // Robustness check: is this correlated with a higher discomfort potentially happening by the end of the HS (proxy: temperature_drop)?
        frame change default
				// Temperature drop by the intervention as a proxy for discomfort 
				capture drop temperature_drop 
				gen temperature_drop = t_in_0 - t_in
        pwcorr temperature_drop  intervention_consecutive_order_1, sig star(0.05) // Non significant
        pwcorr temperature_drop  intervention_consecutive_order_2, sig star(0.05) // Non significant

        pwcorr temperature_drop  order_group_1, sig star(0.05) // Non significant
        pwcorr temperature_drop  order_group_2, sig star(0.05) // Non significant
end

********************************************************************************
* Section 4.3.3: post-experiment survey  							           *
********************************************************************************

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
* Appendices														           *
********************************************************************************

* Fig. 10

program define App_F10_hist_pow_temp

use data_prepared, clear
sort hh_id time

// Right panel: histogram of heat pump power

sum hp_p if excl_from_cf == 0
local avg_hp_p = r(mean)

hist hp_p if intervention_dummy == 0 & hp_p <= 1500, width(50) xtitle("Heat pump power (W)")  note("In non-intervention and non-rebound periods.") xline(`avg_hp_p', lcolor(edkblue) lwidth(1.5 pt)) ///
 graphregion(color(white) margin(zero))  xsize(5) ysize(5) color(blue%35) xlabel(0(250)1500)

graph export "FigureA10_left.pdf", replace

// Right panel: histogram of indoor temperature

sum t_in if excl_from_cf == 0
local avg_t_in = r(mean)

hist t_in if intervention_dummy == 0 & (hs1_window == 1 | hs2_window == 1) & t_in > 16 & t_in <= 26, width(.5) xtitle("Indoor temperature (°C)") note("In non-intervention and non-rebound periods.") xline(`avg_t_in', lcolor(edkblue) lwidth(1.5 pt)) ///
 graphregion(color(white) margin(zero))  xsize(5) ysize(5) color(blue%35) xlabel(16(1)26)

graph export "FigureA10_right.pdf", replace

end

* Fig. 11

program define App_F11_pow

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

        graph export "FigureA11.pdf", replace

restore

end

* Fig. 12

program define App_F12_pow_profile_temp

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

graph export "FigureA12.pdf", replace

restore

end

* Fig. 13

program define App_F13_share_of_HPs
// This program plots Fig. 13

use data_prepared, clear
sort hh_id time

// Share of HPs in each state (blocked/unblocked) after a flexibility event is initiated

    preserve

        keep if five_min_level_elapsed > 0 | after == 1

        collapse (sum) intervention_dummy, by(five_min_level_elapsed)

        sum intervention_dummy
        local max = r(max)

        replace intervention_dummy = intervention_dummy/`max'

        gen normal_operation = 1 - intervention_dummy

        twoway line intervention_dummy five_min_level_elapsed if five_min_level_elapsed < 2880 , sort lcolor(blue) ///
            || line normal_operation five_min_level_elapsed if five_min_level_elapsed < 2880, sort lcolor(green) ///
            aspectratio(1) xlabel(0 "0" 360 "6" 720 "12" 1080 "18" 1440 "24" 1800 "30" 2160 "36" 2520 "42" 2880 "48") xtitle("Time to flexibility event start (h)") ///
            ytitle("Average share of HPs") graphregion(color(white) margin(zero))  xsize(8) ysize(8) legend(order(1 "Blocked" 2 "Unblocked" ) cols(2) pos(6) size(medsmall))

        //graph export "Share_blocked_unblocked.pdf", replace

    restore
	
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

graph export "FigureA13.pdf", replace


// Intensity of rebound 
di "Rebound (resp. first 18h, first 36h, between 18-36h)"
ci means diff if intervention_dummy == 0 & five_min_level_elapsed < 1080 // First 18 hours 
ci means diff if intervention_dummy == 0 & five_min_level_elapsed < 2160 // First 36 hours 
ci means diff if intervention_dummy == 0 & five_min_level_elapsed > 1080 & five_min_level_elapsed < 2160 // Between 18 - 36 hours 

restore
	
end

* Fig 14

// Comes from program 'plot_flex_event_power_profile' (see Fig. 7's program)

* Fig 15

// Comes from program 'plot_flex_event_power_reduction' (see Fig. 7's program)

* Data for Table 4

program define App_T4_HS_temp

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

* Data for Table 5 

program define App_T5_sample_composition

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

* Fig. 16 

program define App_F16_random_inter

use data_prepared, clear
sort hh_id time

// Hour of day
twoway hist hourofday if intervention_dummy == 1 & intervention_dummy[_n-1] == 0 , frequency discrete xlabel(2 "2 am" 8 "8 am" 14 "2 pm" 20 "8 pm") ///
    xtitle("Hour of the day", size(medsmall)) color(blue%35) ///
    graphregion(color(white) margin(zero))  xsize(5) ysize(5) ylabel(0(10)80)

graph export "FigureA16_a.pdf", replace

// Day of week
twoway hist dow if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, frequency discrete xlabel(0 "Mon" 1 "Tue" 2 "Wed" 3 "Thu" 4 "Fri" 5 "Sat" 6 "Sun") ///
    xtitle("Day of the week", size(medsmall)) color(blue%35) ///
    graphregion(color(white) margin(zero))  xsize(5) ysize(5) ylabel(0(10)80)    

graph export "FigureA16_b.pdf", replace

// Indoor temperature threshold
twoway hist t_threshold_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, frequency discrete xtitle("Indoor temperature threshold (°C)", size(medsmall)) /// 
    start(16) color(blue%35) ///
    graphregion(color(white) margin(zero))  xsize(5) ysize(5) ylabel(0(10)80)

graph export "FigureA16_c.pdf", replace

// Correlation coefficients 
pwcorr t_threshold_0 hourofday if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr t_threshold_0 dow if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr hourofday dow if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o

pwcorr t_threshold_0 notif_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr dow notif_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o
pwcorr hourofday notif_0 if intervention_dummy == 1 & intervention_dummy[_n-1] == 0, sig star(0.05) o

end

* Data for Table 6

program define App_T6_reg_rebound_kWh

// First we need the study of the rebound, i.e. we need to run: 

F4_rebound_post_inter

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

// End of file