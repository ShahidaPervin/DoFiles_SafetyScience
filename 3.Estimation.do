clear all
set more off

global SS "***\SafetyScience_RMGsafety&performance"

global Figures "***\Paper_RMGsafety\Figures"

#mkdir "$SS\Tables" // uncomment if you have not created this folder

global Tables "$SS\Tables"

global Data "***\Data"


*							Estimation
********************************************************************************

global predictor200919 D y2019 Dy2019int


*################################################################################
* Table (1) Log employment in upazilas, 2001–2019 
* Panel A: Population census 2001 and 2011 
***********************************************
use "$Data\DataCreated\PopCen_regression", clear

* Define the output table file
local outfile "$Tables\1PanelA.CensuslnReg.doc"

* Global formatting options for outreg2
global outreg2_options tex(frag) nor2 dec(2) bdec(2) sdec(2)

* Column 1: Total employment (All upazilas)
reg lnEmp D y2011 Dy2011int, cluster(ID_ZUpazila)
lincom y2011 + Dy2011int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`outfile'", replace ctitle(Column 1) title("Table 1: Log employment in upazilas (Panel A: 2001 & 2011)") $outreg2_options ///
    addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')

* Column 2: Exclude 0 < apparel share <= 40
drop if Apparel_share2009 > 0 & Apparel_share2009 <= 40
reg lnEmp D y2011 Dy2011int, cluster(ID_ZUpazila)
lincom y2011 + Dy2011int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`outfile'", append ctitle(Column 2) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p') $outreg2_options

* Column 3: Exclude 0 < apparel share <= 40 and textiles share > 50
drop if Textile_share2009 > 50
reg lnEmp D y2011 Dy2011int, cluster(ID_ZUpazila)
lincom y2011 + Dy2011int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`outfile'", append ctitle(Column 3) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p') $outreg2_options

* Column 4: Exclude agricultural upazilas
use "$Data\DataCreated\PopCen_regression", clear
reg lnEmp D y2011 Dy2011int if EPZneibor == 0, cluster(ID_ZUpazila)
lincom y2011 + Dy2011int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`outfile'", append ctitle(Column 4) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p') $outreg2_options

* Column 5: Industry and service sectors only
reg lnEmp_indser D y2011 Dy2011int, cluster(ID_ZUpazila)
lincom y2011 + Dy2011int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`outfile'", append ctitle(Column 5) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p') $outreg2_options
***********************************************

* Panel B: Business census 2009 and 2019
***********************************************
use "$Data\DataCreated\BusCen_regression", clear
xtset year

* column 1 (Table 2: Panel B)
reg ln_tot_emp $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\1PanelB.BCensuslnReg.doc", replace ctitle(Log employment) title ("Table 1: Log employment in upazilas (Panel B: 2009 & 2019)") tex(frag)  nor2 dec(2) bdec(2) sdec(2) pdec(2)  addtext(Specified upazila, all)



* column 2 (Table 2: Panel B)
drop if Apparel_share2009>0 & Apparel_share2009 <= 40 // Exclude Apparel_share2009>0 & Apparel_share2009 <= 40
tab D
tab D year
reg ln_tot_emp $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\1PanelB.BCensuslnReg.doc", append ctitle(log employment) tex(frag)  nor2 dec(2) bdec(2) sdec(2) pdec(2) addtext(Specified upazila, excl. 0<apparel share<= 40)
lincom y2019 + Dy2019int

* Exclude 0 < Apparel_share2009 <= 40 and Textile_share2009 > 50
drop if Textile_share2009>50 
tab D
tab D year
* column 3 (Table 2: Panel B)
reg ln_tot_emp $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\1PanelB.BCensuslnReg.doc", append ctitle(log employment) tex(frag)  nor2 dec(2) bdec(2) sdec(2) pdec(2)  addtext(Specified upazila, excl. 0<apparel share<=40 & textiles share>50)
lincom y2019 + Dy2019int

*column 4 (Table 2: Panel B)
use "$Data\DataCreated\BusCen_regression", clear
reg ln_tot_emp $predictor200919 if EPZneibor==0, cluster(ID_ZUpazila)
outreg2 using "$Tables\1PanelB.BCensuslnReg.doc", append ctitle(Log employment) tex(frag)  nor2 dec(2) bdec(2) sdec(2) pdec(2) addtext(Specified upazila, all)
lincom y2019 + Dy2019int //test (y2019 + Dy2019int)=0

* column 5 (Table 2: Panel B)
reg ln_emp_indser $predictor200919 , cluster(ID_ZUpazila)
outreg2 using "$Tables\1PanelB.BCensuslnReg.doc", append ctitle(Log employment) tex(frag)  nor2 dec(2) bdec(2) sdec(2) pdec(2) addtext(Specified upazila, all)
lincom y2019 + Dy2019int
***********************************************


* Figure (5) Difference in log employment in upazilas 
* Panel A: Difference in log employment 2011 and 2001 
***********************************************
use "$Data\DataCreated\PopCen_regression", clear
keep tot_emp_wt lnEmp lnEmp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor year upazilabd ID_ZUpazila
reshape wide tot_emp_wt lnEmp lnEmp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor , i( upazilabd ID_ZUpazila ) j(year) 
replace Apparel_share20092001 = (Apparel_share20092001/100)

gen diflnEmp11n01 = lnEmp2011 - lnEmp2001
egen meanLnEmpupto40= mean(diflnEmp11n01) if Apparel_share20092001 <= 0.4
egen meanlnEmpabove40= mean(diflnEmp11n01) if Apparel_share20092001 > 0.4
scatter diflnEmp11n01 Apparel_share20092001 , msize(small) color(black) || ///
line meanLnEmpupto40 Apparel_share20092001 if Apparel_share20092001 <= 0.4 , lcolor(black) lpattern(solid) lwidth(thin) || ///
line meanlnEmpabove40 Apparel_share20092001 if Apparel_share20092001>0.4 , lcolor(black) lpattern(solid) lwidth(thin) , ///
graphregion(color(white)) ytitle("Difference in log employment between 2011 and 2001", size(3)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xlabel(0(0.1) 0.85, labsize(3)) ylabel(-3 -1.6 .1325961 0 .5407316 1.6 3,angle(0) nogrid labsize(3) format(%9.2f)) xtitle(Share of apparel employment in the upazilas in 2009, size(3)) legend(off)
graph export "$Figures\Fig5PanelA_lntEmpPop.png", as(png) replace
***********************************************
* Panel B: Difference in log employment 2019 and 2009 
***********************************************
use "$Data\DataCreated\BusCen_regression", clear
replace Apparel_share2009 = (Apparel_share2009/100)
keep tot_emp ln_tot_emp ln_emp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor year upazilabd ID_ZUpazila
reshape wide tot_emp ln_tot_emp ln_emp_indser Apparel_share2009 AppTex_share2009 D_ApTx EPZ EPZneibor , i( upazilabd ID_ZUpazila ) j(year) 
  
gen diflnEmp19n09 = ln_tot_emp2019 - ln_tot_emp2009
egen meanLnEmpupto40= mean(diflnEmp19n09) if Apparel_share20092009 <= 0.40
egen meanlnEmpabove40= mean(diflnEmp19n09) if Apparel_share20092009 > 0.40
scatter diflnEmp19n09 Apparel_share20092009 , msize(small) color(black) || line meanLnEmpupto40 Apparel_share20092009 if Apparel_share20092009 <= 0.40 , lcolor(black) lpattern(longdash)  || line meanlnEmpabove40 Apparel_share20092009 if Apparel_share20092009>0.40 , lcolor(black) lpattern(longdash) , graphregion(color(white)) ytitle("Difference in log employment between 2019 and 2009", size(3)) xlabel(0(.1) .85, labsize(3)) ylabel(-3 .5215008 0 -.1605159 3 ,angle(0) nogrid labsize(3) format(%9.2f)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xtitle(Share of apparel employment in the upazilas in 2009, size(3)) legend(off) 
graph export "$Figures\Fig5PanelB_lntEmpBus.png", as(png) replace
*################################################################################




*###############################################################################
*Table (2) Log registered manufacturing employment and number of establishments in upazilas, 2009–2019: total manufacturing, total manufacturing + service - agri
*Panel A: Registered manufacturing employment
***********************************************
use "$Data\DataCreated\BusCen_regression" , clear
local Tab2 "$Tables\2PanelA.BusMfgEmpEstlnReg.doc"

sum ln_tot_emp_App
sum tot_emp_App
tab ln_emp_manufac year
hist ln_emp_manufac
*manufacturing employment in the upazila
reg ln_emp_manufac $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2'", replace ctitle(manufac employment) title ("Table (2) Log registered manufacturing employment and number of establishments in upazilas, 2009–2019 (Panel A: Registered manufacturing employment)") $outreg2_options  addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')

reg ln_emp_manufac D_ApTx y2019 D_ApTx_y2019int , cluster(ID_ZUpazila)
lincom y2019 + D_ApTx_y2019int 
foreach v of varlist ln_emp_AppTex ln_tot_emp_App{
reg `v' $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2'", append ctitle(`v'employment) $outreg2_options addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')
}

use "$Data\DataCreated\BusCen_exRecentEst", clear
global predictor200919 D y2019 Dy2019int
xtset year
reg ln_emp_manufac $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2'", append ctitle(manufac employment ex recent est) $outreg2_options addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')
***********************************************

* Panel B: Number of registered manufacturing establishments
***********************************************
use "$Data\DataCreated\BusCen_regression" , clear
local Tab2b "$Tables\2PanelB.BusMfgEmpEstlnReg.doc"

//use "CensusBRBDupazila_EPZvar" , clear
tab ln_count_manufac year
hist ln_count_manufac
reg ln_count_manufac $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2b'", replace ctitle(manufac establishment) title ("Table (2) Log registered manufacturing employment and number of establishments in upazilas, 2009–2019 (Panel B: Registered manufacturing establishments)") $outreg2_options addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')

reg ln_count_AppTex $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2b'", append ctitle(manufac establishment) $outreg2_options addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')

reg ln_count_Apparels $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2b'", append ctitle(manufac establishment) $outreg2_options addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')

use "$Data\DataCreated\BusCen_exRecentEst", clear
reg ln_count_manufac $predictor200919 , cluster(ID_ZUpazila) 
lincom y2019 + Dy2019int
local lincom_est = round(r(estimate), 0.01)
local lincom_se = round(r(se), 0.01)
local lincom_p = round(r(p), 0.01)
outreg2 using "`Tab2b'", append ctitle(manufac establishment) $outreg2_options addtext(Specified upazila, all) addstat("Lincom Estimate", `lincom_est', "Lincom SE", `lincom_se', "Lincom p-value", `lincom_p')
***********************************************

***********************************************
*Figure (6) Difference in log manufacturing employment and number of establishments in upazilas
*Panel A: Difference in log manufacturing employment 2019 and 2009
use "$Data\DataCreated\BusCen_regression" , clear
replace Apparel_share2009 = (Apparel_share2009/100)
keep emp_manufac ln_tot_emp ln_emp_indser ln_emp_manufac ln_emp_AppTex ln_tot_emp_App Apparel_share2009 year upazilabd ID_ZUpazila
reshape wide emp_manufac ln_tot_emp ln_emp_indser ln_emp_manufac ln_emp_AppTex ln_tot_emp_App Apparel_share2009, i( upazilabd ID_ZUpazila ) j(year) 

gen difMlnEmp = ln_emp_manufac2019 - ln_emp_manufac2009
egen meanMln_emp_manufacupto40= mean(difMlnEmp) if Apparel_share20092009 <= 0.40
egen meanMln_emp_manufacabove40= mean(difMlnEmp) if Apparel_share20092009 > 0.40
scatter difMlnEmp Apparel_share20092009 , msize(small) color(black) ///
|| line  meanMln_emp_manufacupto40 Apparel_share20092009 if Apparel_share20092009 <= 0.40 , lcolor(black) lpattern(longdash) ///
|| line meanMln_emp_manufacabove40 Apparel_share20092009 if Apparel_share20092009>0.40 , lcolor(black) lpattern(longdash) , ///
graphregion(color(white)) ytitle("Difference in log employment between 2019 and 2009", size(3)) ///
xlabel(0(.1) .85, labsize(3)) ylabel(-3 -.45 0  1.11 3,angle(0) nogrid labsize(3) format(%9.2f)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xtitle(Share of apparel employment in the upazilas in 2009, size(3)) legend(off)
graph export "$Figures\Fig6PanelA_lntEmpBus.png", replace
***********************************************
*Panel B: Difference in log manufacturing establishments 2019 and 2009
use "$Data\DataCreated\BusCen_regression", clear
replace Apparel_share2009 = (Apparel_share2009/100)
keep count_est ln_count_est ln_count_manufac ln_count_AppTex ln_count_Apparels Apparel_share2009 year upazilabd ID_ZUpazila
reshape wide count_est ln_count_est ln_count_manufac ln_count_AppTex ln_count_Apparels Apparel_share2009, i( upazilabd ID_ZUpazila ) j(year) 

gen difMlnest = ln_count_manufac2019 - ln_count_manufac2009
egen meanMlnestupto40= mean(difMlnest) if Apparel_share20092009 <= 0.40
egen meanMlnestabove40= mean(difMlnest) if Apparel_share20092009 > 0.40
scatter difMlnest Apparel_share20092009 , msize(small) color(black) ///
|| line  meanMlnestupto40 Apparel_share20092009 if Apparel_share20092009 <= 0.40 , lcolor(black) lpattern(longdash) ///
|| line  meanMlnestabove40 Apparel_share20092009 if Apparel_share20092009>0.40 , lcolor(black) lpattern(longdash) , ///
graphregion(color(white)) ytitle("Difference in log establishment number between 2019 and 2009", size(3)) ///
xlabel(0(.1) .85, labsize(3)) ylabel( -3 -.49 0 .46 3, angle(0) nogrid labsize(3) format(%9.2f)) ///
yline(0, lwidth(thik) lpattern(dot) lcolor(black) ) ///
xtitle(Share of apparel employment in the upazilas in 2009, size(3)) legend(off) 
graph export "$Figures\Fig6PanelB_lntEstBus.png", replace
*################################################################################








**************************************
			*Map
**************************************
use "$Data\DataCreated\BRBDlong", clear

gen tot_emp= mTPE, before(Male)
drop mTPE
tab Divisions
tab Ind_description
gen AppTexOther="Apparels" if Divisions == 14, after(Ind_description)
replace AppTexOther="Textiles" if Divisions==13 & Divisions != 14 
replace AppTexOther="MfgExclAppTex" if Divisions>=10 & Divisions < 13 | Divisions>14 & Divisions<=32 & AppTexOther!="Apparels" & AppTexOther!="Textiles"
replace AppTexOther= "Agri" if Divisions >=1 & Divisions <=9 & AppTexOther!="Apparels" & AppTexOther!="Textiles"   &  AppTexOther!="MfgExAppTex"
replace AppTexOther="ServiceOther" if  Divisions >=33 & AppTexOther!="Apparels" & AppTexOther!="Textiles"   &  AppTexOther!="MfgExAppTex" & AppTexOther!= "Agri"
tabstat tot_emp , stat(n min max mean sum) by(AppTexOther) // ServiceOther outlier, M/S FAHIN WELDING AND AUTO MOBILE (100012), should drop or convert to 12
replace tot_emp = 13 if tot_emp == 100012 & AppTexOther=="ServiceOther" //male only 13
tabstat tot_emp , stat(n min max mean sum) by(AppTexOther) // ServiceOther outlier, M/S FAHIN WELDING AND AUTO MOBILE (100012), should drop or convert to 12

gen tot_emp_App = cond(inlist(AppTexOther,"Apparels"),tot_emp,0)
gen tot_emp_Tex = cond(inlist(AppTexOther,"Textiles"),tot_emp,0)

collapse (sum) tot_emp tot_emp_App tot_emp_Tex (count) Divisions, by(year NAME_2 Upazila)
gen Apparel_share= (tot_emp_App/tot_emp)*100

gen tot_emp_ApTx= tot_emp_App + tot_emp_Tex
gen AppTex_share=(tot_emp_ApTx/tot_emp)*100
keep if year ==2009  

rename Upazila NAME_3

replace NAME_2 =  "Brahamanbaria" if NAME_2 == "Brahmanbaria"
replace NAME_2= "Nawabganj" if NAME_2 =="Chapai Nababganj"
replace NAME_2= "Kishoreganj" if NAME_2=="Kishoregonj"
replace NAME_2 = "Nilphamari" if NAME_2 == "Nilphamari Zila"


*EPZneibor
gen EPZneibor = 1 if NAME_3 == "Narayanganj Sadar" | NAME_3 == "Demra" | NAME_3 == "Jatrabari" | NAME_3 == "Kadamtali" | NAME_3 == "Shyampur" | NAME_3 == "Keraniganj" | NAME_3 == "Rupganj" // narayanganj sadar, and neighboring demra, keranigonj, rupganj

replace EPZneibor = 1 if NAME_3 == "Nilphamari Sadar" /*| NAME_3 == "Jaldhaka"*/ | NAME_2 == "Nilphamari" & NAME_3 ==  "Kishoreganj" | NAME_3 == "Khansama" | NAME_3 == "Saidpur" // nilphamari sadar and neighboring domar, jaldhaka, kishorgonj saidpur, khansama in Dinajpur

replace EPZneibor = 1 if NAME_3 == "Ishwardi" | NAME_3 == "Atgharia" | NAME_3 == "Pabna Sadar"  | NAME_3 == "Bheramara" | NAME_3 == "Lalpur"   // Ishwardi upazila and neighboring atgharia, pabna, bheramara in Kustia, lalpur in natore, 

replace EPZneibor = 1 if NAME_3 == "Savar" | NAME_3 == "Kaliakair" | NAME_3 == "Dhamrai" | NAME_3 == "Singair"   // Dhaka EPZ is in Savar upazila and neighboring kaliakoir, dhamrai, singair, 

replace EPZneibor = 1 if NAME_3 == "Halishahar" | NAME_3 == "Anowara" | NAME_3 == "Bayejid Bostami" | NAME_3 == "Chandgaon" | NAME_3 == "Chittagong Port" | NAME_2== "Chittagong" & NAME_3 == "Kotwali" | NAME_3 == "Pahartali" | NAME_3 == "Patiya" | NAME_3 == "Sandwip" | NAME_3 == "Sitakunda"  // Chittagong EPZ is in Halishahar upazila and neighboring Anwara, Bayejid bostami, Chandgaon, chittagong port, Kotwali, Pahartali, Patiya, Swandip, Shitakunda *Note absent in 2019 NAME_3 == "Mirsharai", not in the regression so kept blank in map too.  

replace EPZneibor = 1 if NAME_3 == "Anowara" /*| NAME_3 == "Banshkhali"*/ | NAME_3 == "Bakalia" | NAME_3 == "Chandanaish" /*| NAME_3 == "Satkania"*/ //| NAME_3 == "Manoharganj" // Karnaphuli EPZ is in Anwara upazila and neighboring Bashkhali, Bakalia, Chandnaish, Satkania

replace EPZneibor = 1 if NAME_3 == "Comilla Sadar Dakshin" | NAME_3 == "Manoharganj" | NAME_3 == "Comilla Adarsha Sadar" | NAME_3 == "Barura" | NAME_3 == "Burichang" | NAME_3 == "Chauddagram" | NAME_3 == "Laksam"  // Cumilla EPZ in old airport in Comilla Sadar upazila which I merged in Laksam upazila in the upazila adjustment, and neighboring Barura, Burichang, Chauddagram, *Note: keeping | NAME_3 == "Manoharganj", because this is merged with Laksam in the main regression

replace EPZneibor = 1 if NAME_3 == "Mongla" | NAME_3 == "Morrelganj" | NAME_3 == "Rampal" | NAME_3 == "Sarankhola" | NAME_3 == "Dacope" // Mongla EPZ is in Mongla port area and neighboring Morolgonj, Rampal, Shoronkhula, Dacope in Khulna
replace EPZneibor = 0 if EPZneibor == .
tab EPZneibor

gen D= (Apparel_share>40)
tab D

gen D_ApTx= (AppTex_share>40)
tab D_ApTx

*location coordinate
gen EPZ_x = 90.52451496931099 if NAME_3 == "Narayanganj Sadar"
gen EPZ_y = 23.677448389050248 if NAME_3 == "Narayanganj Sadar"  
local x " 91.83023310495999   91.18470036256898  90.28051868772285  89.03334142372435  91.83022108733917   89.6028055263911   88.86227311296358   91.47644474174014"
local y "22.33073362795417  23.44620685688666  23.957344987965843  24.093265977770038  22.329673815914784   22.48698066015895  25.85629599853176  22.742232563505368"
local EPZ `" "Halishahar"  "Comilla Sadar Dakshin" "Savar" "Ishwardi" "Anowara"  "Mongla"  "Nilphamari Sadar"  "Chittagong Port" "'
local order: word count `EPZ'
forvalues i=1/`order'{
	local epz: word `i' of `EPZ'
	local xc: word `i' of `x'
	local yc: word `i' of `y'
	display "`epz' `xc' `yc'"
	replace EPZ_x = `xc' if NAME_3== "`epz'"
	replace EPZ_y = `yc' if NAME_3=="`epz'"
}
merge 1:m NAME_2 NAME_3 using "D:\1. Research\Safety_ManufacturIngIndustry_BD\1. WorkingOnData_CMISMIBR\Bangladesh_Districts\gadm36_BGD_shp\upzdb"
drop if _merge==1
drop _merge

gen EPZn = "EPZ" if EPZ_x !=.
//replace EPZn = "Neighbor" if EPZneibor == 1 & EPZn == "" 
gen xEPZon = x_c if EPZneibor == 1 & EPZ_x !=.
gen yEPZon = y_c if EPZneibor == 1 & EPZ_y !=.


gen epz_x= EPZ_x
replace epz_x = x_c if EPZneibor ==1 &  epz_x == .
gen epz_y= EPZ_y
replace epz_y = y_c if EPZneibor ==1 &  epz_y == .
save "$Data\DataCreated\Ap2009", replace

gen labtype =1
append using "$Data\DataCreated\Ap2009"
replace labtype = 2 if labtype==.
replace NAME_3 = string(Apparel_share , "%4.1f") if labtype == 2
save "$Data\spmapBR2009UPZ.dta",replace

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
	
grmap D  using "D:\1. Research\Safety_ManufacturIngIndustry_BD\1. WorkingOnData_CMISMIBR\Bangladesh_Districts\gadm36_BGD_shp\upzcoord.dta", id(id)  ///
clbreaks (0 40 100) clmethod(unique)  ///    
point(xcoord(EPZ_x) ycoord(EPZ_y)  size(large vsmall ) fcolor(cyan)  by(EPZnbor) /*legenda(on) */) fcolor(white red) legend(off) /* ///
title("Bangladesh's upazilas by apparel dominance, and EPZ", size(*0.5)) */
graph export "$Figures\Fig4_map.png", replace

	

	
	
	
	

//%%%%%%%%%%%    Back of the envelope   %%%%%%%%%%%%%%%
use "$Data\DataCreated\PopBusCen_upazila" , clear

*correlation between registered employment in 2009 and any employment in 2011 is 0.84
corr emp_total2011 tot_emp2009





* (population census) related to Fig 5 Panel A: log employment difference
use "$Data\DataCreated\PopCen_regression", clear
keep tot_emp_wt lnEmp lnEmp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor year upazilabd ID_ZUpazila
reshape wide tot_emp_wt lnEmp lnEmp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor , i( upazilabd ID_ZUpazila ) j(year) 
replace Apparel_share20092001 = (Apparel_share20092001/100)

gen diflnEmp11n01 = lnEmp2011 - lnEmp2001
egen meanLnEmpupto40= mean(diflnEmp11n01) if Apparel_share20092001 <= 0.4
sum meanLnEmpupto40
egen meanlnEmpabove40= mean(diflnEmp11n01) if Apparel_share20092001 > 0.4

reg diflnEmp11n01 Apparel_share20092001
predict dif200111

graph twoway (scatter diflnEmp11n01 Apparel_share20092001, xline(.4, lcolor(black)) ) ///
(line dif200111 Apparel_share20092001, lcolor(black) lpattern("-.-")  lwidth(medthick)), ///
ytitle("Difference of log employment between 2011 & 2001", size(3)) ylabel(0(.5)3 , nogrid labsize(4)) /// 
xtitle("Upazila's apparel employment share in 2009", size(3)) legend(off)  graphregion(color(white)) //xlabel(15(5) 60, labsize(4)) 



*(business census) related to Fig 4: Panel B log employment difference
***************************** 
use "$Data\DataCreated\BusCen_regression", clear

replace Apparel_share2009 = (Apparel_share2009/100)
keep tot_emp ln_tot_emp ln_emp_indser Apparel_share2009 AppTex_share2009 D D_ApTx EPZ EPZneibor year upazilabd ID_ZUpazila
reshape wide tot_emp ln_tot_emp ln_emp_indser Apparel_share2009 AppTex_share2009 D_ApTx EPZ EPZneibor , i( upazilabd ID_ZUpazila ) j(year) 
  
gen diflnEmp19n09 = ln_tot_emp2019 - ln_tot_emp2009
egen meanLnEmpupto40= mean(diflnEmp19n09) if Apparel_share20092009 <= 0.40
sum meanLnEmpupto40
egen meanlnEmpabove40= mean(diflnEmp19n09) if Apparel_share20092009 > 0.40
sum meanlnEmpabove40

reg diflnEmp19n09 Apparel_share20092009
predict dif200919
graph twoway (lfit dif200919 Apparel_share20092009) (scatter diflnEmp19n09 Apparel_share20092009)
graph twoway (lfit diflnEmp19n09 Apparel_share20092009) (scatter diflnEmp19n09 Apparel_share20092009)

graph twoway (scatter diflnEmp19n09 Apparel_share20092009, xline(.4, lcolor(black)) ) ///
(lfit dif200919 Apparel_share20092009, lcolor(black) lpattern("-.-")  lwidth(medthick)), ///
ytitle("Difference of log employment between 2019 & 2009", size(3)) ylabel(0(.5)3 , nogrid labsize(4)) /// 
xtitle("Upazila's apparel employment share in 2009", size(3)) legend(off)  graphregion(color(white)) //xlabel(15(5) 60, labsize(4)) 


use "$Data\DataCreated\BusCen_regression", clear
replace Apparel_share2009 = (Apparel_share2009/100)
sum ln_tot_emp_App if Apparel_share2009 <= .4

sum Apparel_share2009 if Apparel_share2009 <= .4 
sum Apparel_share2009 if Apparel_share2009 > .4 




