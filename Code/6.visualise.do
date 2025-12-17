********* Graphs - gas growth + GDP growth + Paris line

**** CO2 + GDP growth (dual axis)

use "C:\Users\Admin\Documents\Github\Group_2\Data\final\multigas_gdp_countries_final.dta", clear
keep if inrange(year,1970,2024)

* range (can change)
local xmin = 1970  
local xmax = 2024

local countries "USA CHN GBR IND RUS JPN DEU KOR IDN SAU IRN CAN"

foreach cc of local countries {

    twoway ///
        (line co2_mt year if Country_code_A3=="`cc'", yaxis(1) lpattern(solid)) ///
        (line gdp_annual_growth year if Country_code_A3=="`cc'", yaxis(2) lpattern(solid)), ///
        ///
        yscale(range(`co2min' `co2max') axis(1)) ///
        yscale(range(`gdpmin' `gdpmax') axis(2)) ///
		 xlabel(1970(6)2024) ///
        xscale(range(1970 2024)) ///
        ///
        ytitle("CO2 emissions (Mt)", axis(1)) ///
        ytitle("GDP growth (%)", axis(2)) ///
        xtitle("Year") ///
        legend(order(1 "CO2 (Mt)" 2 "GDP growth (%)")) ///
        xline(2016, lpattern(dash)) ///
        title("`cc': CO2 emissions and GDP growth") ///
        name(co2_gdp_`cc', replace)


    graph export "C:\Users\Admin\Documents\Github\Group_2\Output\Graph\co2_gdp_`cc'_ts.png", replace
    graph save   "C:\Users\Admin\Documents\Github\Group_2\Data\final\Graph\co2_gdp_`cc'.gph", replace
}


* CO2+GDP 12 countries (panel)
graph combine ///
    co2_gdp_USA co2_gdp_CHN co2_gdp_GBR ///
    co2_gdp_IND co2_gdp_RUS co2_gdp_JPN ///
    co2_gdp_DEU co2_gdp_KOR co2_gdp_IDN ///
    co2_gdp_SAU co2_gdp_IRN co2_gdp_CAN, ///
    cols(3) xcommon ///
    title("CO2 emissions (Mt) & GDP growth (%) – 12 countries")

graph export "C:\Users\Admin\Documents\Github\Group_2\Output\Graph\co2_gdp_12countries_panel.png", replace
 graph save "C:\Users\Admin\Documents\Github\Group_2\Data\final\Graph\co2_gdp_12countries_panel.gph", replace 


* 4) CH4 + N2O + GDP growth (dual axis)

use "C:\Users\Admin\Documents\Github\Group_2\Data\final\multigas_gdp_countries_final.dta", clear

* range (can change)
local xmin = 1970  
local xmax = 2024

local countries "USA CHN GBR IND RUS JPN DEU KOR IDN SAU IRN CAN"

foreach cc of local countries {

    twoway ///
        (line ch4_mt year if Country_code_A3=="`cc'", ///
            yaxis(1) lpattern(solid)) ///
        (line n2o_mt year if Country_code_A3=="`cc'", ///
            yaxis(1) lpattern(solid)) ///
        (line gdp_annual_growth year if Country_code_A3=="`cc'", ///
            yaxis(2) lpattern(solid)), ///
        ///
        yscale(range(`gasmin' `gasmax') axis(1)) ///
        yscale(range(`gdpmin' `gdpmax') axis(2)) ///
        xscale(range(`xmin' `xmax')) ///
        xlabel(1970(6)2024) ///
        ///
        ytitle("CH4 & N2O emissions (Mt)", axis(1)) ///
        ytitle("GDP growth (%)", axis(2)) ///
        xtitle("Year") ///
legend(order(1 "CH4 (Mt)" 2 "N2O (Mt)" 3 "GDP growth (%)")) ///
        xline(2016, lpattern(dash)) ///
        title("`cc': CH4 & N2O (Mt) and GDP growth") ///
        name(ch4n2o_gdp_`cc', replace)

    graph export "C:\Users\Admin\Documents\Github\Group_2\Output\Graph\ch4n2o_gdp_`cc'_ts.png", replace
    graph save   "C:\Users\Admin\Documents\Github\Group_2\Data\final\Graph\ch4n2o_gdp_`cc'.gph", replace
}


* CH4+N2O+GDP of 12 Countries
graph combine ///
    ch4n2o_gdp_USA ch4n2o_gdp_CHN ch4n2o_gdp_GBR ///
    ch4n2o_gdp_IND ch4n2o_gdp_RUS ch4n2o_gdp_JPN ///
    ch4n2o_gdp_DEU ch4n2o_gdp_KOR ch4n2o_gdp_IDN ///
    ch4n2o_gdp_SAU ch4n2o_gdp_IRN ch4n2o_gdp_CAN, ///
    cols(3) xcommon ///
    title("CH4 & N2O emissions (Mt) & GDP growth – 12 countries")

graph export "C:\Users\Admin\Documents\Github\Group_2\Output\Graph\ch4n2o_gdp_12countries_panel.png", replace
graph save "C:\Users\Admin\Documents\Github\Group_2\Data\final\Graph\ch4n2o_gdp_12countries_panel.gph", replace 












