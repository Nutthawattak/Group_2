*5) Coupling Table (CO2+CH4))
clear all
set more off

* 1. Load pre-merged multi-gas + GDP dataset

use "C:\Users\Admin\Documents\Github\Group_2\Data\final\multigas_gdp_countries_final.dta", clear


keep if inlist(Country_code_A3, ///
    "CHN","USA","IND","RUS","JPN","IRN","DEU") ///
 | inlist(Country_code_A3, ///
    "KOR","IDN","CAN","SAU","GBR")

keep if inrange(year, 1990, 2024)
encode Country_code_A3, gen(country_id)
xtset country_id year

* 2. Build emission & GDP growth variables


* Use Mt variables for emissions (levels)
rename co2_mt co2
rename ch4_mt ch4

* CO2 and CH4 growth rates (% per year, log-difference)
bys country_id (year): gen co2_growth = 100 * (ln(co2) - ln(L.co2))
bys country_id (year): gen ch4_growth = 100 * (ln(ch4) - ln(L.ch4))


* 3. Absolute and relative decoupling indicators


gen abs_decouple_co2 = (gdp_annual_growth > 0 & co2_growth < 0)
gen rel_decouple_co2 = (gdp_annual_growth > 0 & co2_growth > 0 ///
                         & co2_growth < gdp_annual_growth)

gen abs_decouple_ch4 = (gdp_annual_growth > 0 & ch4_growth < 0)
gen rel_decouple_ch4 = (gdp_annual_growth > 0 & ch4_growth > 0 ///
                         & ch4_growth < gdp_annual_growth)

* Save full panel with decoupling flags
save "C:\Users\Admin\Documents\Github\Group_2\Data\final\co2_ch4_decoupling_panel.dta", replace


* 4. Aggregate over 2016–2024 (Paris Agreement period)
*----------------------------------------------------------

keep if year >= 2016

bys Country_code_A3: egen n_years = count(year)

bys Country_code_A3: egen abs_co2 = total(abs_decouple_co2)
bys Country_code_A3: egen rel_co2 = total(rel_decouple_co2)

bys Country_code_A3: egen abs_ch4 = total(abs_decouple_ch4)
bys Country_code_A3: egen rel_ch4 = total(rel_decouple_ch4)

bys Country_code_A3: keep if _n == 1

gen decouple_total_co2 = abs_co2 + rel_co2
gen share_decouple_co2 = decouple_total_co2 / n_years
gen share_abs_co2      = abs_co2 / decouple_total_co2 if decouple_total_co2 > 0

gen decouple_total_ch4 = abs_ch4 + rel_ch4
gen share_decouple_ch4 = decouple_total_ch4 / n_years
gen share_abs_ch4      = abs_ch4 / decouple_total_ch4 if decouple_total_ch4 > 0

set linesize 255

list Country_code_A3 ///
     abs_co2 rel_co2 decouple_total_co2 share_decouple_co2 share_abs_co2 ///
     abs_ch4 rel_ch4 decouple_total_ch4 share_decouple_ch4 share_abs_ch4, ///
     noobs sep(0) clean

* 5. Prepare wide dataset for graph

preserve

keep Country_code_A3 abs_co2 rel_co2 abs_ch4 rel_ch4

tempfile wide
save `wide'

use `wide', clear
keep Country_code_A3 abs_co2 rel_co2
gen gas = "CO2"
rename abs_co2 abs
rename rel_co2 rel
tempfile co2
save `co2'

use `wide', clear
keep Country_code_A3 abs_ch4 rel_ch4
gen gas = "CH4"
rename abs_ch4 abs
rename rel_ch4 rel

append using `co2'

graph bar abs rel, ///
    over(gas, label(labsize(tiny))) ///
    over(Country_code_A3, label(labsize(vsmall))) ///
    stack ///
    legend(order(1 "Absolute" 2 "Relative") size(vsmall)) ///
    ytitle("Number of years (2016–2024)", size(vsmall)) ///
    title("CO2 and CH4 decoupling years after the Paris Agreement")
	
graph export "C:\Users\Admin\Documents\Github\Group_2\Output\Graph\co2_ch4_decoupling_combined_2016_2024.png", replace
graph save "C:\Users\Admin\Documents\Github\Group_2\Data\final\Graph\co2_ch4_decoupling_combined_2016_2024.gph", replace
restore








