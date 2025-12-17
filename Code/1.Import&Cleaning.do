*Import&Cleaning Datasets

clear all
set more off

local countries "USA CHN GBR IND RUS JPN DEU KOR IDN SAU IRN CAN"

* 1) CO2  
import excel using "C:\Users\Admin\Documents\Github\Group_2\Data\Raw\IEA_EDGAR_CO2_1970_2024.xlsx", ///
    sheet("TOTALS BY COUNTRY") cellrange(A10:BH235) firstrow clear


capture isid Country_code_A3
if _rc {
    gen id = _n
    reshape long Y_, i(id) j(year)
}
else {
    reshape long Y_, i(Country_code_A3) j(year)
}

rename Y_ co2_gg
gen double co2_mt = co2_gg/1000
label var co2_gg "CO2 emissions (Gg)"
label var co2_mt "CO2 emissions (MtCO2)"

sort Country_code_A3 year


save "C:\Users\Admin\Documents\Github\Group_2\Data\process\edgar_co2_1970_2024_panel.dta", replace



* 2) CH4
clear all
set more off

import excel using "C:\Users\Admin\Documents\Github\Group_2\Data\Raw\EDGAR_CH4_1970_2024.xlsx", ///
    sheet("TOTALS BY COUNTRY") cellrange(A10:BH233) firstrow clear


capture isid Country_code_A3
if _rc {
    gen id = _n
    reshape long Y_, i(id) j(year)
}
else {
    reshape long Y_, i(Country_code_A3) j(year)
}

rename Y_ ch4_gg
generate double ch4_mt = ch4_gg/1000

label var ch4_gg "CH4 emissions (Gg)"
label var ch4_mt "CH4 emissions (MtCH4)"


sort Country_code_A3 year


save "C:\Users\Admin\Documents\Github\Group_2\Data\process\edgar_ch4_1970_2024_panel.dta", replace


* 3) N2O
clear all
set more off

import excel using "C:\Users\Admin\Documents\Github\Group_2\Data\Raw\EDGAR_N2O_1970_2024.xlsx", ///
    sheet("TOTALS BY COUNTRY") cellrange(A10:BH233) firstrow clear
	
	
capture isid Country_code_A3
if _rc {
    gen id = _n
    reshape long Y_, i(id) j(year)
}
else {
    reshape long Y_, i(Country_code_A3) j(year)
}

rename Y_ n2o_gg
generate double n2o_mt = n2o_gg/1000

label var n2o_gg "N2O emissions (Gg)"
label var n2o_mt "N2O emissions (MtN2O)"


sort Country_code_A3 year



save "C:\Users\Admin\Documents\Github\Group_2\Data\process\edgar_n2o_1970_2024_panel.dta", replace

*4. GDP Anuual Growth
clear all
set more off

import delimited using "C:\Users\Admin\Documents\Github\Group_2\Data\Raw\WB_WDI_NY_GDP_MKTP_KD_ZG.csv", ///
    varnames(1) clear
rename ref_area_label Name
rename ref_area Country_code_A3


ds, has(type numeric)
local yearvars `r(varlist)'

local firstvar  : word 1 of `yearvars'
local firstyear = real(substr("`firstvar'", -4, 4))

local i = 1
foreach v of local yearvars {
    rename `v' gdp_`i'
    local ++i
}

rename gdp_1 year
rename gdp_2 gdp_annual_growth
keep Country_code_A3 year gdp_annual_growth Name 
sort  Country_code_A3 year

keep if year >= 1970 & year <= 2024
drop if missing(gdp_annual_growth)

label var gdp_annual_growth "GDP annual growth  (%)"



save "C:\Users\Admin\Documents\Github\Group_2\Data\process\gdp_annual_growth_panel.dta", replace





