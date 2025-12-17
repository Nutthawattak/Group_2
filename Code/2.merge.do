* 2) combine dataset (CO2 + CH4 + N2O + GDP)

use "C:\Users\Admin\Documents\Github\Group_2\Data\process\edgar_co2_1970_2024_panel.dta", clear

* merge CH4
merge 1:1 Country_code_A3 year using "C:\Users\Admin\Documents\Github\Group_2\Data\process\edgar_ch4_1970_2024_panel.dta", keep(3) nogen

* merge N2O
merge 1:1 Country_code_A3 year using "C:\Users\Admin\Documents\Github\Group_2\Data\process\edgar_n2o_1970_2024_panel.dta", keep(3) nogen

* merge with GDP annual growth
merge 1:1 Country_code_A3 year using "C:\Users\Admin\Documents\Github\Group_2\Data\process\gdp_annual_growth_panel.dta", keep(3) nogen



* add post-paris agreement
capture confirm variable post_paris
if _rc {
    gen post_paris = year>=2016
}

keep Country_code_A3 Name year ///
     co2_gg co2_mt ch4_gg ch4_mt n2o_gg n2o_mt ///
     gdp_annual_growth post_paris

order Country_code_A3 Name year ///
      co2_gg co2_mt ch4_gg ch4_mt n2o_gg n2o_mt ///
      gdp_annual_growth post_paris

save "C:\Users\Admin\Documents\Github\Group_2\Data\process\multigas_gdp_countries.dta", replace


