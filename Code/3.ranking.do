*Ranking

use "C:\Users\Admin\Documents\Github\Group_2\Data\process\multigas_gdp_countries.dta", clear

keep if inrange(year, 2016, 2024)
collapse (mean) co2_mt_mean=co2_mt (mean) co2_gg_mean=co2_gg ///
        (first) Name, by(Country_code_A3)

gsort -co2_mt_mean
gen rank = _n
list rank Country_code_A3 Name co2_mt_mean, noobs



save "C:\Users\Admin\Documents\Github\Group_2\Data\process\ranking.dta", replace

use "C:\Users\Admin\Documents\Github\Group_2\Data\process\multigas_gdp_countries.dta", clear
merge m:1 Country_code_A3 using "C:\Users\Admin\Documents\Github\Group_2\Data\process\ranking.dta", keep(match) nogen

save "C:\Users\Admin\Documents\Github\Group_2\Data\final\multigas_gdp_countries_final.dta", replace




