clear all
set more off

global SS "***\SafetyScience_RMGsafety&performance"

global Figures "***\Appendix\Figures"

*mkdir "$SS\Tables" // uncomment if you have not created this folder

global Tables "$SS\Tables"

global Data "***\Data"




	*A Result appendix: Level outcomes and analysis of apparel and textile together
*######################################################################################

*Table (A1) Total employment and number of establishments in upazilas, 2001–2019
********************************************************************************
** Panel A: Population census 2001 and 2011
******************************************************
*column 1 (Table A1: Panel A)
use "$Data\DataCreated\PopCen_regression", clear
reg tot_emp_wt D y2011 Dy2011int, cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelA.CensusReg.doc", replace ctitle(Total employment) title("Table (A1) Total employment and number of establishments in upazilas, 2001–2019 (Population census 2001 and 2011)") tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all) 
lincom y2011 + Dy2011int 

*column 2 (Table A1: Panel A)
drop if Apparel_share2009 > 0 & Apparel_share2009 <= 40
reg tot_emp_wt D y2011 Dy2011int, cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelA.CensusReg.doc", append ctitle(Total employment) tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all) 
lincom y2011 + Dy2011int 

*column 3 (Table A1: Panel A)
drop if Textile_share2009 > 50
reg tot_emp_wt D y2011 Dy2011int, cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelA.CensusReg.doc", append ctitle(Total employment) tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all) 
lincom y2011 + Dy2011int 

** Panel B: Registered business census 2009 and 2019
******************************************************
*column 1 (Table A1: Panel B)
use "$Data\DataCreated\BusCen_regression", clear
global predictor200919 D y2019 Dy2019int
reg tot_emp $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelB.BusReg.doc", replace ctitle(Employment) title ("Table (A1) Total employment and number of establishments in upazilas, 2001–2019 (Business census 2009 and 2019)") tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all)
lincom y2019 + Dy2019int //test (y2019 + Dy2019int)=0

*column 2 (Table A1: Panel B)
drop if Apparel_share2009>0 & Apparel_share2009 <= 40 // Exclude Apparel_share2009>0 & Apparel_share2009 <= 40
reg tot_emp $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelB.BusReg.doc", append ctitle(Employment) tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all)

*column 3 (Table A1: Panel B)
drop if Textile_share2009>50 
reg tot_emp $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelB.BusReg.doc", append ctitle(Employment) tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all)

** Panel C: Registered business census 2009 and 2019
******************************************************
*column 1 (Table A1: Panel C)
use "$Data\DataCreated\BusCen_regression", clear
global predictor200919 D y2019 Dy2019int
reg count_est $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelC.BusReg.doc", replace ctitle(Establishment) title ("Table (A1) Total employment and number of establishments in upazilas, 2001–2019 (Business census 2009 and 2019)") tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, all)

*column 2 (Table A1: Panel C)
drop if Apparel_share2009>0 & Apparel_share2009 <= 40 // 
reg count_est $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelC.BusReg.doc", append ctitle(Establishment) tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(addtext(Specified upazila, excl. 0<apparel share<= 40))

*column 3 (Table A1: Panel C)
drop if Textile_share2009>50 
reg count_est $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\A1PanelC.BusReg.doc", append ctitle(Establishment) tex(frag) nor2 dec(2) bdec(2) sdec(2)  addtext(Specified upazila, excl. 0<apparel share<=40 & textiles share>50)
*######################################################################################





*Table (A2) Log employment and number of establishments in upazilas for industry and service (excluding agriculture), 2001–2019
*Figure (A1) Difference in log employment and number of establishments in upazilas for industry and service (exclude agriculture)
*######################################################################################


use "$Data\DataCreated\PopCen_regression", clear

* Table (A2) Panel A: 2001-2011 (log of apparel & textile employment) [column 1]
*(log employment difference only industry and service)
reg lnEmp_indser D_ApTx y2011 D_ApTx_y2011int , cluster(ID_ZUpazila)
outreg2 using "$Tables\A2PanelA.Pop_indser.doc", replace ctitle(Ind & service LnEmp) title("Table (A2) Panel A: Log of apparel & textile employment in upazilas in 2001 & 2011 (excluding agriculture)") tex(frag) nor2 dec(2) bdec(2) sdec(2) pdec(2) addtext(Specified upazila, all excl agriculture) 
lincom y2011 + D_ApTx_y2011int

* Figure (A1) Panel A: 2001-2011 (log of apparel & textile employment)
keep tot_emp_wt lnEmp lnEmp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor year upazilabd ID_ZUpazila
reshape wide tot_emp_wt lnEmp lnEmp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor , i( upazilabd ID_ZUpazila ) j(year) 
replace AppTex_share20092001 = (AppTex_share20092001/100)

gen diflnEmp11n01 = lnEmp_indser2011 - lnEmp_indser2001
egen meanLnEmpupto40= mean(diflnEmp11n01) if AppTex_share20092001 <= 0.48
egen meanlnEmpabove40= mean(diflnEmp11n01) if AppTex_share20092001 > 0.48
scatter diflnEmp11n01 AppTex_share20092001 , msize(small) color(black) || ///
line meanLnEmpupto40 AppTex_share20092001 if AppTex_share20092001 <= 0.4 , lcolor(black) lpattern(solid) lwidth(thin) || ///
line meanlnEmpabove40 AppTex_share20092001 if AppTex_share20092001>0.4 , lcolor(black) lpattern(solid) lwidth(thin) , ///
graphregion(color(white)) ytitle("Difference in log employment between 2011 and 2001", size(3)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xlabel(0(0.1) 1, labsize(3)) ylabel(-3 -1.6 .08   .45 1.6 3,angle(0) nogrid labsize(3) format(%9.2f)) xtitle(Share of apparel & textiles employment in the upazilas in 2009, size(3)) legend(off)
graph export "$Figures\FigA1PanelA_PoplnIndSerEmp.png", as(png) replace

* Table (A2) Panel A: 2001-2011 (log of apparel & textile employment) [column 2]
use "$Data\DataCreated\PopCen_regression", clear
drop if AppTex_share2009>0 & AppTex_share2009 <= 48
reg lnEmp_indser D_ApTx y2011 D_ApTx_y2011int , cluster(ID_ZUpazila)
outreg2 using "$Tables\A2PanelA.Pop_indser.doc", append ctitle(Ind & service LnEmp) tex(frag) nor2 dec(2) bdec(2) sdec(2) pdec(2) addtext(Specified upazila, Exclude 0<Appael & Textile share <= 48) 
lincom y2011 + D_ApTx_y2011int




* Table (A2) Panel B: 2009-2019 (log of apparel & textile employment) [column 1]
*(log employment difference only industry and service)
use "$Data\DataCreated\BusCen_regression", clear
reg ln_emp_indser D_ApTx y2019 D_ApTx_y2019int , cluster(ID_ZUpazila)
outreg2 using "$Tables\A2PanelB.bus_indser.doc", replace ctitle(Ind & service LnEmp) title("Table (A2) Panel B: Log of apparel & textile employment in upazilas in 2009 & 2019 (excluding agriculture)") tex(frag)  nor2  addtext(Specified upazila, all excl agriculture) 
lincom y2019 + D_ApTx_y2019int

* Table (A2) Panel C: 2009-2019 (log of apparel & textile number of establishments) [column 1]
reg ln_count_indser D_ApTx y2019 D_ApTx_y2019int , cluster(ID_ZUpazila)
outreg2 using "$Tables\A2PanelC.bus_indser.doc", replace ctitle(Ind & service LnEst) title ("Table (A2) Panel C: Log of apparel & textile establishments in upazilas in 2009 & 2019 (excluding agriculture)") tex(frag)  nor2 bdec(2) pdec(3) addtext(Specified upazila, all excl agriculture)
lincom y2019 + D_ApTx_y2019int

* Figure (A1) Panel B: 2009-2019 (log of apparel & textile employment)
keep ln_emp_indser ln_count_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor year upazilabd ID_ZUpazila
reshape wide ln_emp_indser ln_count_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor, i( upazilabd ID_ZUpazila ) j(year) 
replace AppTex_share20092009 = (AppTex_share20092009/100)

gen diflnEmp11n01 = ln_emp_indser2019 - ln_emp_indser2009
egen meanLnEmpupto48= mean(diflnEmp11n01) if AppTex_share20092009 <= 0.48
egen meanlnEmpabove48= mean(diflnEmp11n01) if AppTex_share20092009 > 0.48
scatter diflnEmp11n01 AppTex_share20092009 , msize(small) color(black) || ///
line meanLnEmpupto48 AppTex_share20092009 if AppTex_share20092009 <= 0.48 , lcolor(black) lpattern(solid) lwidth(thin) || ///
line meanlnEmpabove48 AppTex_share20092009 if AppTex_share20092009>0.48 , lcolor(black) lpattern(solid) lwidth(thin) , ///
graphregion(color(white)) ytitle("Difference in log employment between 2019 and 2009", size(3)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xlabel(0(0.1) 1, labsize(3)) ylabel(-3 -1.6 .02   .52 1.6 3,angle(0) nogrid labsize(3) format(%9.2f)) xtitle(Share of apparel & textiles employment in the upazilas in 2009, size(3)) legend(off)
graph export "$Figures\FigA1PanelB_BuslnIndSerEmp.png", as(png) replace

* Figure (A1) Panel C: 2009-2019 (log of apparel & textile establishments)
gen diflnCount11n01 = ln_count_indser2019 - ln_count_indser2009
egen meanLnCupto48= mean(diflnCount11n01 ) if AppTex_share20092009 <= 0.48
egen meanlnCabove48= mean(diflnCount11n01 ) if AppTex_share20092009 > 0.48
scatter diflnCount11n01 AppTex_share20092009 , msize(small) color(black) || ///
line meanLnCupto48 AppTex_share20092009 if AppTex_share20092009 <= 0.48 , lcolor(black) lpattern(solid) lwidth(thin) || ///
line meanlnCabove48 AppTex_share20092009 if AppTex_share20092009>0.48 , lcolor(black) lpattern(solid) lwidth(thin) , ///
graphregion(color(white)) ytitle("Difference in log establishment numbers between 2019 and 2009", size(3)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xlabel(0(0.1) 1, labsize(3)) ylabel(-3 -1.6 .02    0.02 .38 1.6 3,angle(0) nogrid labsize(3) format(%9.2f)) xtitle(Share of apparel & textiles establishments in the upazilas in 2009, size(3)) legend(off)
graph export "$Figures\FigA1PanelC_BuslnIndSerEst.png", as(png) replace


* Table (A2) Panel B: 2009-2019 (log of apparel & textile employment) [column 2]
use "$Data\DataCreated\BusCen_regression", clear
drop if AppTex_share2009>0 & AppTex_share2009 <= 48
reg ln_emp_indser D_ApTx y2019 D_ApTx_y2019int , cluster(ID_ZUpazila)
outreg2 using "$Tables\A2PanelB.bus_indser.doc", append ctitle(Ind & service LnEmp) title("Table (A2) Panel B: Log of apparel & textile employment in upazilas in 2009 & 2019 (excluding agriculture)") tex(frag)  nor2 bdec(2) pdec(3)  addtext(Specified upazila, Exclude 0<Appael & Textile share <= 48) 
lincom y2019 + D_ApTx_y2019int

* Table (A2) Panel C: 2009-2019 (log of apparel & textile establishments) [column 2]
reg ln_count_indser D_ApTx y2019 D_ApTx_y2019int , cluster(ID_ZUpazila)
outreg2 using "$Tables\A2PanelC.bus_indser.doc", append ctitle(Ind & service LnEst) title ("Table (A2) Panel C: Log of apparel & textile establishments in upazilas in 2009 & 2019 (excluding agriculture)") tex(frag)  nor2 bdec(2) pdec(3) addtext(Specified upazila, Exclude 0<Appael & Textile share <= 48)
lincom y2019 + D_ApTx_y2019int
*######################################################################################



* Map
*######################################################################################
*Figure (A2) Location of Export Processing Zones (EPZs) and apparel-textile dominant upzilas

use "$Data\DataCreated\Ap2009", clear
merge 1:m NAME_2 NAME_3 using "$Data\gadm36_BGD_shp\upzdb"
drop _merge
	
	gen EPZnbor=1 if EPZneibor == 1 & EPZ_x!= .
	replace EPZnbor=2 if EPZneibor == 1 & EPZ_x== .
    label define EZPnibour 1 "EPZ location" 2 "EPZ's neighbor upazila" 
    label values EPZnbor EZPnibour  
	fre EPZnbor
	
	label define Dif 1 "Apparel dominant upazila" 0 "Comparison upazila" 
    label values D Dif  
	fre D
tab D_ApTx 
grmap D_ApTx  using "D:\1. Research\Safety_ManufacturIngIndustry_BD\1. WorkingOnData_CMISMIBR\Bangladesh_Districts\gadm36_BGD_shp\upzcoord.dta", id(id)  ///
clbreaks (0 40 100) clmethod(unique)  ///    
point(xcoord(EPZ_x) ycoord(EPZ_y)  size(large vsmall ) fcolor(red)  by(EPZnbor) /*legenda(on) */) fcolor(white cyan) legend(off) 
graph export "$Figures\FigA2_BDMapApTxEPZ.png", replace

*######################################################################################
















