# Proof_of_the_Pudding_Heating
Repository for data and code for Rigaux, Hamels and Ovaere (2024). "The Proof of the Pudding is in the Heating: a Field Experiment on Household Engagement with Heat Pump Flexibility" (*)

December 2024

(*) Baptiste Rigaux & Sam Hamels & Marten Ovaere, 2024. "The Proof of the Pudding is in the Heating: A Field Experiment on Household Engagement with Heat Pump Flexibility," Working Papers of Faculty of Economics and Business Administration, Ghent University, Belgium 24/1101, Ghent University, Faculty of Economics and Business Administration. Accessible at: https://ideas.repec.org/p/rug/rugwps/24-1101.html 

Contact: baptiste.rigaux@ugent.be

## Data:
- 'experiment_data.zip': ZIP archive of the heat pump data recorded throughout the field experiment. Extract to obtain 'experiment_data.dta' file in a Stata format. 
- 'presurvey_data.dta': Stata formatted file containing the presurvey data on participating households. 
- 'postsurvey_data.dta': Stata formatted file containing the postsurvey data on participating households.
- 'synop_data.zip': ZIP archive of the weather data corresponding to the experimental period and collected from Royal Meteorological Institute of Belgium (**). Extract to obtain 'synop_data.csv'. See '.ReadMe_synop_data.txt' for more info.
- 'DAM_prices.csv': CSV file containing the day-ahead electricity prices for Belgium and across the experimental period, collected from ENTSO-E Transparency Platform  (***). See '.ReadMe_DAM_prices.txt' for more info.

## Code: 
- 'Stata_code.do': a Stata '.do' file preparing the data and plotting the figures and tables of the paper.
- 'Building_dataset_monetary_valuation_flex_event.py': a Python '.py' file taking four datasets ('df_hourly_energy_reduction_bin_*.csv') outputted by 'Stata_code.do' as an input. It returns 'money_shifted_heterogeneous.csv' as an output. In turns, 'money_shifted_heterogeneous.csv' is used in 'Stata_code.do' for plotting the tables relative to the monetary valuation of flexibility events. For convenience, 'money_shifted_heterogeneous.csv' is already included in the repository. That way, the whole analysis can be conducted just using the 'Stata_code.do' file.

## Output: 
- Three .tex files corresponding to the three panels of Table 1 (further formatted in the paper).
- The paper figures (incl. appendices) as PDF files.
- Command results, corresponding to elements explained in the text (e.g., t-test results), are displayed directly in the console when they appear in 'Stata_code.do'.

## How to reproduce the paper results?

1. Download the (GitHub) archive.
2. Extract it and extract the ZIP files 'experiment_data.zip' and 'synop_data.zip' in the archive.
3. Relocate the extracted files 'experiment_data.dta' and 'synop_data.csv' in the main directory. 
4. Open the Stata_code.do file, change the directory and compile the programs (lines 12-18 first and 54-2897 second).
5. Run each program separately, or alternatively compile and use the 'run_all' program to reproduce the whole paper in one command.
6. Optional: run the Building_dataset_monetary_valuation_flex_event.py file after the program 'F7_flex_event_temp' and before the program 'F8_both_panels' to build the dataset 'money_shifted_heterogeneous.csv' used in 'F8_both_panels' (already included in the archive for convenience).

## Subject eligibility and selection: 

Cf. the manuscript: "The experiment was carried out in collaboration with Energent, a Ghent-based local energy cooperative with around 2,000 members, developing renewable energy projects (See https://energent.be/). The cooperative selected nine participating households based on previous related and successful projects and coordinated the installation of hardware devices making it possible to remotely monitor and steer their HPs." As a result, while we worked in close collaboration with the cooperative, the researchers did not participate directly in the selection of the participants. 

## References:

(**) Royal Meteorological Institute of Belgium. (2024). Open Data - Royal Meteorological Institute of Belgium
[Accessed: 29 July 2024]. https://opendata.meteo.be/ 

(***) European Network of Transmission System Operators for Electricity. (2024). Day-Ahead Prices Transparency [Accessed: 29 July 2024]. https://transparency.entsoe.eu/transmission-domain/r2/dayAheadPrices/show
