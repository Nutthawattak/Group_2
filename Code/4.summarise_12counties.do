***********Summarise table
clear all
set more off

* 1. Load merged panel
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
	
	
export delimited using "C:\Users\Admin\Documents\Github\Group_2\Output\Table\Table1_emissions_gdp_pre_post.csv" , replace










