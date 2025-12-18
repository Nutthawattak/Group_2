***********Summarise table
clear all
set more off

* Load merged panel
use "C:\Users\Admin\Documents\Github\Group_2\Data\final\multigas_gdp_countries_final.dta", clear

* keep sample period
keep if inrange(year,1970,2024)
keep if inlist(Country_code_A3, ///
    "CHN","USA","IND","RUS","JPN","IRN","DEU") ///
 | inlist(Country_code_A3, ///
    "KOR","IDN","CAN","SAU","GBR")

* Summary statistics (mean, sd, min, max) by country × period
collect clear
table Country_code_A3 post_paris, ///
    stat(mean co2_mt) stat(sd co2_mt) stat(min co2_mt) stat(max co2_mt) ///
    stat(mean gdp_annual_growth) ///
    stat(sd   gdp_annual_growth) ///
    stat(min  gdp_annual_growth) ///
    stat(max  gdp_annual_growth)

*--------------------------------------------------
* Volatility of CO2 growth vs GDP growth
*--------------------------------------------------

* co2_log_growth 
gen ln_co2 = ln(co2_mt)

bysort Country_code_A3 (year): gen co2_log_growth = (ln_co2 - ln_co2[_n-1]) * 100


* sd growth
bysort Country_code_A3: egen sd_co2_growth = sd(co2_log_growth)
bysort Country_code_A3: egen sd_gdp_annual_growth   = sd(gdp_annual_growth)



* volatility ratio
gen vol_ratio = sd_gdp_annual_growth / sd_co2_growth

bys Country_code_A3: keep if _n == 1
sort Country_code_A3
list Country_code_A3 sd_co2_growth sd_gdp_annual_growth vol_ratio, sepby(Country_code_A3)











