clear all
set more off

global SS "***\SafetyScience_RMGsafety&performance"

global Figures "***\Paper_RMGsafety\Figures"

*mkdir "$SS\Tables" // uncomment if you have not created this folder

global Tables "$SS\Tables"

global Data "***\Data"


*************************************************************
            *Data cleaning and organising and merging
*************************************************************


*			Busniess Register 2009  
**************************************************************

use "$Data\BusinessReg2009\tblAllEstablishment" ,  clear
save "$Data\tblAllEstablishment" , replace
import excel "$Data\BusinessReg2009\BsicClass.xlsx" , firstrow clear
gen New_BSIC= Class
save "$Data\BusinessReg2009\BsicClass" , replace
import excel "$Data\BusinessReg2009\BsicDivision.xlsx" , firstrow clear
save "$Data\BusinessReg2009\BsicDivision" , replace
import excel "$Data\BusinessReg2009\BsicGroup.xlsx" , firstrow clear
save "$Data\BusinessReg2009\BsicGroup" , replace
import excel "$Data\BusinessReg2009\tblDivision.xlsx" , firstrow clear
save "$Data\BusinessReg2009\tblDivision" , replace
import excel "$Data\BusinessReg2009\tblZila.xls" , firstrow clear
save "$Data\BusinessReg2009\tblZila" , replace
import excel "$Data\BusinessReg2009\tblUpazila.xlsx" , firstrow clear
save "$Data\BusinessReg2009\tblUpazila" , replace


*******       merge for geographic unit and sector identification
use "$Data\BusinessReg2009\tblAllEstablishment", clear
fre Division_cd
merge m:1 Division_cd using "$Data\BusinessReg2009\tblDivision"  //to get the district name ; all matched
tab Division_cd DV_NAME_E
drop _merge
fre Zila_cd
rename Zila_cd ZILA_cd
merge m:1 ZILA_cd using "$Data\BusinessReg2009\tblZila.dta"  //to get the district name ; all matched
drop _merge

tab New_BSIC
merge m:1 New_BSIC using "$Data\BusinessReg2009\BsicClass" //to get the name of type of industry. 0 not matched from master but 85 not matched from using //more New_BSIC than available in the data, so observations go up from 100194 to 100279
/*keep if _merge ==2 //85 not matched
count if Total == . // 85 missing values 
count if Establishment_cd == "." //0
count if Establishment_cd == "" //86 */
drop if _merge==2
drop _merge

*destring Divisions, replace //2 digit level sector
merge m:1 Divisions using "$Data\BusinessReg2009\BsicDivision.dta" //to get the name of type of industry. 0 not matched from the master, 2 from using
//keep if _merge ==2
drop if _merge==2 // 2 obs
drop _merge

destring Divisions, replace //2 digit level sector

count if Total<10  //0
gen tot_emp = Total, after(Total)
tabstat tot_emp if Divisions==14 | Divisions==13, stat(N sum mean min max sd) 
tabstat tot_emp if Divisions==14 , stat(N sum mean min max sd) 
tabstat Male if Divisions==14 | Divisions==13, stat(N sum mean min max sd) 
tabstat Male if Divisions==14 , stat(N sum mean min max sd) 
tabstat Female if Divisions==14 | Divisions==13, stat(N sum mean min max sd) 
tabstat Female if Divisions==14 , stat(N sum mean min max sd) 
di (926973/1662344)*100
di (1142626/ 2508567)*100 

gen NAME_2 = ZL_NAME_E, after(ZL_NAME_E)
fre NAME_2

by NAME_2, sort: gen nvals= _n==1
count if nvals //64
drop nvals

by Upazila_cd, sort: gen nvals= _n==1
count if nvals //549
drop nvals

by Division_cd ZILA_cd Upazila_cd , sort: gen nvals= _n==1
count if nvals //549
drop nvals

gen year=2009
pwd
save "$Data\DataCreated\BR2009", replace //100194


sum tot_emp
di r(sum)  //5279564
total tot_emp
total Male //3663518
total Female //1615739

rename ZILA_cd Zila_cd, replace
merge m:1 Zila_cd Upazila_cd using "D:\1. Research\Safety_ManufacturIngIndustry_BD\1. WorkingOnData_CMISMIBR\1PreparingTheChapter\Data&Result\Data\BusinessReg2009\tblUpazila.dta" //93 not matched from master file merge m:1 Upazila_cd using "tblUpazila.dta"  //to get the upazila name ; 93 not matched
drop _merge
by NAME_2 UZ_NAME_E, sort: gen nvals= _n==1
count if nvals //547
drop nvals

by Zila_cd Upazila_cd, sort: gen nvals= _n==1
count if nvals //549
drop nvals

by Zila_cd ZILA NAME_2 Upazila_cd UPZA UZ_NAME_E, sort: gen nvals= _n==1
count if nvals //549
drop nvals
gen NAME_3 = UZ_NAME_E, after(UZ_NAME_E)
save "$Data\DataCreated\BR2009", replace //100194


***** Harmonising Upazila name matching with shape file and BR 2019
use "$Data\DataCreated\BR2009" , clear
replace NAME_3 = proper(NAME_3)
replace NAME_3 = "Mehendiganj" if NAME_3 == "Mhendiganj"
replace NAME_3 = "Daulatkhan" if NAME_3=="Daulat Khan"
replace NAME_3 = "Bagati Para" if NAME_3== "Bagatipara"
replace NAME_3 = "Baghai Chhari" if NAME_3 =="Baghaichhari"
replace NAME_3 = "Balia Kandi" if NAME_3 == "Baliakandi"
replace NAME_3 = "Barkal" if NAME_3 == "Barkal Upazila"
replace NAME_3 = "Belai Chhari" if NAME_3 == "Belai Chhari  Upazi"
replace NAME_3 = "Dimla" if NAME_3 == "Dimla Upazila"
replace NAME_3 = "Domar" if NAME_3 == "Domar Upazila"
replace NAME_3 = "Dumki" if NAME_3 == "Dumki Upazila"
replace NAME_3 = "Goalandaghat" if NAME_3 == "Goalanda"
replace NAME_3 = "Golabganj" if NAME_3 == "Golapganj"
replace NAME_3 = "Jaldhaka" if NAME_3 == "Jaldhaka Upazila"
replace NAME_3 = "Jurai Chhari" if NAME_3 == "Jurai Chhari Upazil"
replace NAME_3 = "Kaptai" if NAME_3 == "Kaptai  Upazila"
replace NAME_3 = "Kishoreganj" if NAME_3 == "Kishoreganj Upazila"
replace NAME_3 = "Kotali Para" if NAME_3 == "Kotalipara"
replace NAME_3 = "Langadu" if NAME_3 == "Langadu  Upazila"
replace NAME_3 = "Maulvi Bazar Sadar" if NAME_3 == "Maulvibazar Sadar"
replace NAME_3 = "Mirzaganj" if NAME_3 == "Mirzaganj Upazila"
replace NAME_3 = "Naniarchar" if NAME_3 == "Naniarchar  Upazila"
replace NAME_3 = "Nazirpur" if NAME_3 == "Nazirpur Upazila"
replace NAME_3 = "Nilphamari Sadar" if NAME_3 == "Nilphamari Sadar Upaz"
replace NAME_3 = "Noakhali Sadar (Sudharam)" if NAME_3 == "Noakhali Sadar"
replace NAME_3 = "Rajasthali" if NAME_3 == "Rajasthali  Upazila"
replace NAME_3 = "Rangamati Sadar" if NAME_3 == "Rangamati Sadar  Up"
replace NAME_3 = "Saghatta" if NAME_3 == "Saghata"
replace NAME_3 = "Saidpur" if NAME_3 == "Saidpur Upazila"
replace NAME_3 = "Sarishabari" if NAME_3 == "Sarishabari Upazila"
replace NAME_3 = "Tungi Para" if NAME_3 == "Tungipara"
replace NAME_3 = "Ukhia" if NAME_3 == "Ukhia Upazila"
replace NAME_3 = "Nawabganj Sadar" if NAME_3 == "Chapai Nababganj Sadar"
//replace NAME_3 = "Uttara And Bimanbandar" if NAME_3 == "Uttara" & NAME_2 == "Dhaka" //to match with Census geograpy
//replace NAME_3 = "Uttara And Bimanbandar" if NAME_3 == "Biman Bandar" & NAME_2 == "Dhaka" //to match with Census geograpy
*two upazila in Chittagong in the main file does not exist in mapfile (blank(569) and Karnafuli (police station)(3669)); Bogra (37); Chandpur(13); Comilla(1046); Dhaka(75); Gazipur(800); Gaibandha(17); Khagrachhari(1281); Rangpur(82); Sylhet(467); (total employment in parenthesis)
save "$Data\DataCreated\BR2009UpaName", replace

**Only to check data missing status
use "$Data\DataCreated\BR2009UpaName", clear
by NAME_2 NAME_3, sort: gen nvals= _n==1
count if nvals //547
drop nvals
by Zila_cd ZILA NAME_2 Upazila_cd UPZA UZ_NAME_E, sort: gen nvals= _n==1
count if nvals //549
drop nvals
by Zila_cd Upazila_cd, sort: gen nvals= _n==1
count if nvals //549
drop nvals
collapse (sum) tot_emp , by (NAME_2 Zila_cd ZILA NAME_3 Upazila_cd UPZA UZ_NAME_E) //13 upazila name missing
count if NAME_3 == "" //13


** Filling up the missing address/ upazila information. information is taken from other address column where the location is mentioned; some are checked in online. May not be 100% correct because it is possible that some name in the column information are located in another upazila.
use "$Data\DataCreated\BR2009UpaName", clear  
destring Upazila_cd, replace
destring Zila_cd, replace
drop if NAME_3 != "" //93 observations upazila name is missing (In District: 1 Bogra, 1 Chandpur, 6 Chittagong, 40 Comilla, 2 Dhaka, 1 Gaibandha, 1 Gazipur, 15 Khagrachhari, 1 Narayangonj, 4 Rangpur, 21 Sylhet). From rename 12 upazila name recovered.

replace NAME_3 = "Shajahanpur" if NAME_3 == "" & NAME_2 == "BOGRA" & Name == "MD ALI BRICK FIELD"
replace UZ_NAME_E= "SHAJAHANPUR" if  UZ_NAME_E == "" & NAME_2 == "BOGRA" & Name == "MD ALI BRICK FIELD"
replace ZILA= "10" if  ZILA == "" &  NAME_2 == "BOGRA" & Name == "MD ALI BRICK FIELD"
replace UPZA= "85" if  UPZA == "" &  NAME_2 == "BOGRA" & Name == "MD ALI BRICK FIELD"   
replace Upazila_cd= 1085 if  UPZA == "85" &  NAME_2 == "BOGRA" & Name == "MD ALI BRICK FIELD" // no upazila_cd=82 in Census2011 while all other upazila code of Bogra matches with census 2011, it seems, this upazila is wrong entry.
// 1 observation changes

replace NAME_3 = "Shahrasti" if NAME_3 == "" & NAME_2 == "CHANDPUR" & Name == "TMSS"
replace UZ_NAME_E= "SHAHRASTI" if  UZ_NAME_E == "" & NAME_2 == "CHANDPUR" & Name == "TMSS"
replace ZILA= "13" if  ZILA == "" &  NAME_2 == "CHANDPUR" & Name == "TMSS"
replace UPZA= "95" if  UPZA == "" &  NAME_2 == "CHANDPUR" & Name == "TMSS"
replace Upazila_cd= 1395 if  UPZA == "95" &  NAME_2 == "CHANDPUR" & Name == "TMSS" //there is no upazila_cd = 13 in Chandpur in census 2011, even though all other upazila of chadpur code matches.
//1 observation changes

replace NAME_3 = "Maheshkhali" if NAME_3 == "" & NAME_2 == "CHITTAGONG" & Name == "Krishi Bank" // this is not in chittagong, matarbari and bara maheshkhali in cox's bazar
replace UZ_NAME_E= "MAHESHKHALI" if  NAME_3 == "Maheshkhali" & NAME_2 == "CHITTAGONG" & Name == "Krishi Bank"
replace ZILA= "22" if  NAME_2 == "CHITTAGONG" & Name == "Krishi Bank"
replace UPZA= "49" if  NAME_2 == "CHITTAGONG" & Name == "Krishi Bank"
replace NAME_2= "COX'S BAZAR" if   NAME_2 == "CHITTAGONG" & Name == "Krishi Bank"
//replace Upazila_cd= 2249 if   NAME_2 == "CHITTAGONG" & Name == "Krishi Bank" 
replace Zila_cd= 22 if   NAME_2 == "COX'S BAZAR" & Name == "Krishi Bank" 
// 2 observations change

replace NAME_3 = "Maheshkhali" if Name == "Alamgir and Mahafuzullah Farid Technical College" // this is not in chittagong
replace UZ_NAME_E= "MAHESHKHALI" if  Name == "Alamgir and Mahafuzullah Farid Technical College"
replace ZILA= "22" if  Name == "Alamgir and Mahafuzullah Farid Technical College"
replace UPZA= "49" if  Name == "Alamgir and Mahafuzullah Farid Technical College"
replace NAME_2= "COX'S BAZAR" if Name == "Alamgir and Mahafuzullah Farid Technical College"
replace Upazila_cd= 2249 if NAME_3 == "Maheshkhali" & NAME_2 == "COX'S BAZAR"
replace Zila_cd= 22 if NAME_3 == "Maheshkhali" & NAME_2 == "COX'S BAZAR"
// 1 observations changes

replace NAME_3 = "Chandgaon" if NAME_2 == "CHITTAGONG" & NAME_3== "" // kalurghat in chandgaon
replace UZ_NAME_E= "CHANDGAON" if Zila_cd == 15 & ZILA== ""
replace UPZA= "19" if UZ_NAME_E== "CHANDGAON" & Zila_cd == 15
replace ZILA= "15" if UZ_NAME_E== "CHANDGAON" & ZILA == ""
replace Upazila_cd= 1519 if UZ_NAME_E== "CHANDGAON" & UPZA== "19" &  ZILA == "15"
//3 observations change

replace NAME_3 = "Comilla Adarsha Sadar" if Name == "Telekona Govt. Primary School"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name == "Telekona Govt. Primary School"
replace UPZA= "67" if Name == "Telekona Govt. Primary School"
replace ZILA= "19" if Name == "Telekona Govt. Primary School"
replace Upazila_cd= 1967 if Name == "Telekona Govt. Primary School"
//1 observation changes

replace NAME_3 = "Comilla Sadar Dakshin" if Name == "Modern Hospital (Pvt) Ltd."
replace UZ_NAME_E= "COMILLA SADAR DAKSHIN" if Name == "Modern Hospital (Pvt) Ltd."
replace UPZA= "33" if Name == "Modern Hospital (Pvt) Ltd."
replace ZILA= "19" if Name == "Modern Hospital (Pvt) Ltd."
replace Upazila_cd= 1933 if Name == "Modern Hospital (Pvt) Ltd."
//1 observation changes

replace NAME_3 = "Comilla Sadar Dakshin" if Name == "Hossain Haider High School"
replace UZ_NAME_E= "COMILLA SADAR DAKSHIN" if Name == "Hossain Haider High School"
replace UPZA= "33" if Name == "Hossain Haider High School"
replace ZILA= "19" if Name == "Hossain Haider High School"
replace Upazila_cd= 1933 if Name == "Hossain Haider High School"
//1 observation changes

replace NAME_3 = "Jatrabari" if Name == "DANIA SUB-POST OFFICE"
replace UZ_NAME_E= "JATRABARI" if Name == "DANIA SUB-POST OFFICE"
replace UPZA= "29" if Name == "DANIA SUB-POST OFFICE"
replace ZILA= "26" if Name == "DANIA SUB-POST OFFICE"
replace Upazila_cd= 2629 if Name == "DANIA SUB-POST OFFICE"
//1 observation changes

replace NAME_3 = "Jatrabari" if Name == "DHANIA UNIVERSITY COLLEGE"
replace UZ_NAME_E= "JATRABARI" if Name == "DHANIA UNIVERSITY COLLEGE"
replace UPZA= "29" if Name == "DHANIA UNIVERSITY COLLEGE"
replace ZILA= "26" if Name == "DHANIA UNIVERSITY COLLEGE"
replace Upazila_cd= 2629 if Zila_cd ==26 & UPZA == "29"

replace NAME_3 = "Palashbari" if Name == "SAUNIA DEOANER MAZAR GIRLS DAKHIL MADRASHA"
replace UZ_NAME_E= "PALASHBARI" if Name == "SAUNIA DEOANER MAZAR GIRLS DAKHIL MADRASHA"
replace UPZA= "67" if Name == "SAUNIA DEOANER MAZAR GIRLS DAKHIL MADRASHA"
replace ZILA= "32" if Name == "SAUNIA DEOANER MAZAR GIRLS DAKHIL MADRASHA"
replace Upazila_cd= 3267 if ZILA == "32" & UPZA == "67" & UZ_NAME_E == "PALASHBARI"

replace NAME_3 = "Gazipur Sadar" if Name == "BATA SHOE CO (BD)LTD"
replace UZ_NAME_E= "GAZIPUR SADAR" if Name == "BATA SHOE CO (BD)LTD"
replace UPZA= "30" if Name == "BATA SHOE CO (BD)LTD"
replace ZILA= "33" if Name == "BATA SHOE CO (BD)LTD"
replace Upazila_cd= 3330 if ZILA == "33" & UPZA == "30" &  UZ_NAME_E== "GAZIPUR SADAR"

replace NAME_3 = "Matiranga" if Name == "GMB Bricks"
replace UZ_NAME_E= "MATIRANGA" if Name == "GMB Bricks"
replace UPZA= "70" if Name == "GMB Bricks"
replace ZILA= "46" if Name == "GMB Bricks"
replace Upazila_cd= 4670 if Name == "GMB Bricks"

//keep if NAME_2 == "Khagrachhari"
replace NAME_3 = "Matiranga" if add2 == "Matiranga Bazer, matiranga ."
replace UZ_NAME_E= "MATIRANGA" if add2 == "Matiranga Bazer, matiranga ."
replace UPZA= "70" if add2 == "Matiranga Bazer, matiranga ."
replace ZILA= "46" if add2 == "Matiranga Bazer, matiranga ."
replace Upazila_cd= 4670 if add2 == "Matiranga Bazer, matiranga ."

replace NAME_3 = "Matiranga" if add2 == "Gagi nagor , matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Gagi nagor , matiranga"
replace UPZA= "70" if add2 == "Gagi nagor , matiranga"
replace ZILA= "46" if add2 == "Gagi nagor , matiranga"
replace Upazila_cd= 4670 if add2 == "Gagi nagor , matiranga"

replace NAME_3 = "Matiranga" if add2 == "Belchari , matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Belchari , matiranga"
replace UPZA= "70" if add2 == "Belchari , matiranga"
replace ZILA= "46" if add2 == "Belchari , matiranga"
replace Upazila_cd= 4670 if add2 == "Belchari , matiranga"

replace NAME_3 = "Matiranga" if add2 == "Wacho , Matiranga ,"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Wacho , Matiranga ,"
replace UPZA= "70" if add2 == "Wacho , Matiranga ,"
replace ZILA= "46" if add2 == "Wacho , Matiranga ,"
replace Upazila_cd= 4670 if add2 == "Wacho , Matiranga ,"

replace NAME_3 = "Matiranga" if add2 == "Matiranga , Matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Matiranga , Matiranga"
replace UPZA= "70" if add2 == "Matiranga , Matiranga"
replace ZILA= "46" if add2 == "Matiranga , Matiranga"
replace Upazila_cd= 4670 if add2 == "Matiranga , Matiranga"

replace NAME_3 = "Matiranga" if add2 == "Kamini Member Para , Matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Kamini Member Para , Matiranga"
replace UPZA= "70" if add2 == "Kamini Member Para , Matiranga"
replace ZILA= "46" if add2 == "Kamini Member Para , Matiranga"
replace Upazila_cd= 4670 if add2 == "Kamini Member Para , Matiranga"

replace NAME_3 = "Matiranga" if add2 == "Natun Para , Matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Natun Para , Matiranga"
replace UPZA= "70" if add2 == "Natun Para , Matiranga"
replace ZILA= "46" if add2 == "Natun Para , Matiranga"
replace Upazila_cd= 4670 if add2 == "Natun Para , Matiranga"

replace NAME_3 = "Matiranga" if add2 == "Tikapara, Khedachara,Bailla chari Matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Tikapara, Khedachara,Bailla chari Matiranga"
replace UPZA= "70" if add2 == "Tikapara, Khedachara,Bailla chari Matiranga"
replace ZILA= "46" if add2 == "Tikapara, Khedachara,Bailla chari Matiranga"
replace Upazila_cd= 4670 if add2 == "Tikapara, Khedachara,Bailla chari Matiranga"

replace NAME_3 = "Matiranga" if add2 == "Monder para , Matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Monder para , Matiranga"
replace UPZA= "70" if add2 == "Monder para , Matiranga"
replace ZILA= "46" if add2 == "Monder para , Matiranga"
replace Upazila_cd= 4670 if add2 == "Monder para , Matiranga"

replace NAME_3 = "Matiranga" if add2 == "Dollia Matiranga , Matiranga Paurashava"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Dollia Matiranga , Matiranga Paurashava"
replace UPZA= "70" if add2 == "Dollia Matiranga , Matiranga Paurashava"
replace ZILA= "46" if add2 == "Dollia Matiranga , Matiranga Paurashava"
replace Upazila_cd= 4670 if add2 == "Dollia Matiranga , Matiranga Paurashava"

replace NAME_3 = "Matiranga" if add2 == "Guimara , Matiranga"
replace UZ_NAME_E= "MATIRANGA" if add2 == "Guimara , Matiranga"
replace UPZA= "70" if add2 == "Guimara , Matiranga"
replace ZILA= "46" if add2 == "Guimara , Matiranga"
replace Upazila_cd= 4670 if ZILA == "46" & UPZA == "70" & UZ_NAME_E== "MATIRANGA"

//keep if NAME_2 == "Narayanganj"
replace NAME_3 = "Narayanganj Sadar" if add2 == "DIST-NARAYANGONJ"
replace UZ_NAME_E= "NARAYANGANJ SADAR" if add2 == "DIST-NARAYANGONJ"
replace UPZA= "58" if add2 == "DIST-NARAYANGONJ"
replace ZILA= "67" if add2 == "DIST-NARAYANGONJ"
replace Upazila_cd= 6758 if ZILA == "67" & UPZA == "58" & UZ_NAME_E == "NARAYANGANJ SADAR"

replace NAME_3 = "Jaintiapur" if add1 == "Jointapur"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Jointapur"
replace UPZA= "53" if add1 == "Jointapur"
replace ZILA= "91" if add1 == "Jointapur"
replace Upazila_cd= 9153 if add1 == "Jointapur"
//2 obs change

replace NAME_3 = "Jaintiapur" if add1 == "Mokambari, Jointapur"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Mokambari, Jointapur"
replace UPZA= "53" if add1 == "Mokambari, Jointapur"
replace ZILA= "91" if add1 == "Mokambari, Jointapur"
replace Upazila_cd= 9153 if add1 == "Mokambari, Jointapur"
//8 obs change

replace NAME_3 = "Gowainghat" if add1 == "Fathepur"
replace UZ_NAME_E= "GOWAINGHAT" if add1 == "Fathepur"
replace UPZA= "41" if add1 == "Fathepur"
replace ZILA= "91" if add1 == "Fathepur"
replace Upazila_cd= 9141 if ZILA == "91" & UPZA == "41" & UZ_NAME_E == "GOWAINGHAT"
//1 obs change

replace NAME_3 = "Jaintiapur" if add1 == "Jaintapur"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Jaintapur"
replace UPZA= "53" if add1 == "Jaintapur"
replace ZILA= "91" if add1 == "Jaintapur"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
//obs 1 change

replace NAME_3 = "Jaintiapur" if add1 == "Chiknagul"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Chiknagul"
replace UPZA= "53" if add1 == "Chiknagul"
replace ZILA= "91" if add1 == "Chiknagul"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
//obs 1 change

replace NAME_3 = "Jaintiapur" if add1 == "Hemu, Haripur, Jointapur"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Hemu, Haripur, Jointapur"
replace UPZA= "53" if add1 == "Hemu, Haripur, Jointapur"
replace ZILA= "91" if add1 == "Hemu, Haripur, Jointapur"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
//3 obs change

replace NAME_3 = "Jaintiapur" if add1 == "Charicata"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Charicata"
replace UPZA= "53" if add1 == "Charicata"
replace ZILA= "91" if add1 == "Charicata"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
//1 obs change

replace NAME_3 = "Jaintiapur" if add1 == "Lalakhal Charicata"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Lalakhal Charicata"
replace UPZA= "53" if add1 == "Lalakhal Charicata"
replace ZILA= "91" if add1 == "Lalakhal Charicata"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
//1 obs change

replace NAME_3 = "Jaintiapur" if add1 == "Darbast"
replace UZ_NAME_E= "JAINTIAPUR" if add1 == "Darbast"
replace UPZA= "53" if add1 == "Darbast"
replace ZILA= "91" if add1 == "Darbast"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
//1 obs change

replace NAME_3 = "Jaintiapur" if Name == "Jointapur Degree College"
replace UZ_NAME_E= "JAINTIAPUR" if Name == "Jointapur Degree College"
replace UPZA= "53" if Name == "Jointapur Degree College"
replace ZILA= "91" if Name == "Jointapur Degree College"
replace Upazila_cd= 9153 if Name == "Jointapur Degree College"
//1 obs change

replace NAME_3 = "Jaintiapur" if NAME_2 == "SYLHET" & NAME_3 == ""
replace UZ_NAME_E= "JAINTIAPUR" if NAME_2 == "SYLHET" & NAME_3 == "Jaintiapur"
replace UPZA= "53" if NAME_2 == "SYLHET" & NAME_3 == "Jaintiapur"
replace ZILA= "91" if NAME_2 == "SYLHET" & NAME_3 == "Jaintiapur"
replace Upazila_cd= 9153 if UPZA == "53" & ZILA == "91"
//replace UZ_NAME_E= "JAINTIAPUR" if UPZA == "53" & ZILA == "91" 
// 1 obs change

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Ganibhuiyan Mansan, Monoharpur, Comilla"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Ganibhuiyan Mansan, Monoharpur, Comilla"
replace UPZA= "67" if add2== "Ganibhuiyan Mansan, Monoharpur, Comilla"
replace ZILA= "19" if add2== "Ganibhuiyan Mansan, Monoharpur, Comilla"
replace Upazila_cd= 1967 if add2== "Ganibhuiyan Mansan, Monoharpur, Comilla"
//2 obs change

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Dakshin Chartha"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Dakshin Chartha"
replace UPZA= "67" if add2== "Dakshin Chartha"
replace ZILA= "19" if add2== "Dakshin Chartha"
replace Upazila_cd= 1967 if add2== "Dakshin Chartha"
//9 obs change

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Dr. Chartha"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Dr. Chartha"
replace UPZA= "67" if add2== "Dr. Chartha"
replace ZILA= "19" if add2== "Dr. Chartha"
replace Upazila_cd= 1967 if add2== "Dr. Chartha"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Monoharpur, Ram Bhaban"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Monoharpur, Ram Bhaban"
replace UPZA= "67" if add2== "Monoharpur, Ram Bhaban"
replace ZILA= "19" if add2== "Monoharpur, Ram Bhaban"
replace Upazila_cd= 1967 if add2== "Monoharpur, Ram Bhaban"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Monoharpur, comilla"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Monoharpur, comilla"
replace UPZA= "67" if add2== "Monoharpur, comilla"
replace ZILA= "19" if add2== "Monoharpur, comilla"
replace Upazila_cd= 1967 if add2== "Monoharpur, comilla"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Muradpur, Katabil"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Muradpur, Katabil"
replace UPZA= "67" if add2== "Muradpur, Katabil"
replace ZILA= "19" if add2== "Muradpur, Katabil"
replace Upazila_cd= 1967 if add2== "Muradpur, Katabil"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Rammala Raod"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Rammala Raod"
replace UPZA= "67" if add2== "Rammala Raod"
replace ZILA= "19" if add2== "Rammala Raod"
replace Upazila_cd= 1967 if add2== "Rammala Raod"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Gangchar"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Gangchar"
replace UPZA= "67" if add2== "Gangchar"
replace ZILA= "19" if add2== "Gangchar"
replace Upazila_cd= 1967 if add2== "Gangchar"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Nazrul Avenue, Kandirpar Road"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Nazrul Avenue, Kandirpar Road"
replace UPZA= "67" if add2== "Nazrul Avenue, Kandirpar Road"
replace ZILA= "19" if add2== "Nazrul Avenue, Kandirpar Road"
replace Upazila_cd= 1967 if add2== "Nazrul Avenue, Kandirpar Road"

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Shasangacha, Durgapur"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Shasangacha, Durgapur"
replace UPZA= "67" if add2== "Shasangacha, Durgapur"
replace ZILA= "19" if add2== "Shasangacha, Durgapur"
replace Upazila_cd= 1967 if ZILA== "19" & UPZA == "67"

//collapse (sum) tot_emp, by (NAME_2 NAME_3)
//keep if NAME_2 == "Chittagong" | NAME_2 == "Cox'S Bazar"
//replace NAME_2 = "CHITTAGONG" if NAME_3 == "Patiya" & NAME_2 == "COX'S BAZAR" 
//replace UPZA= "61" if NAME_3 == "Patiya" & NAME_2 == "Cox'S Bazar"
//replace ZILA= "15" if NAME_3 == "Patiya" & NAME_2 == "Cox'S Bazar"

//replace NAME_2 = "CHITTAGONG" if NAME_3 == "Hathazari" & NAME_2 == "COX'S BAZAR" 

replace NAME_3 = "Comilla Sadar Dakshin" if Name== "Shishumatri General Hospital (Pvt.) Ltd."
replace UZ_NAME_E= "COMILLA SADAR DAKSHIN" if Name== "Shishumatri General Hospital (Pvt.) Ltd."
replace UPZA= "33" if Name== "Shishumatri General Hospital (Pvt.) Ltd."
replace ZILA= "19" if Name== "Shishumatri General Hospital (Pvt.) Ltd."
replace Upazila_cd= 1933 if ZILA== "19" & UPZA == "33"
// 1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Univers Ideal School"
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Univers Ideal School"
replace UPZA= "67" if Name== "Univers Ideal School"
replace ZILA= "19" if Name== "Univers Ideal School"
replace Upazila_cd= 1967 if Name== "Univers Ideal School"
//1 observation changes 
count if NAME_3 == ""

replace NAME_3 = "Chauddagram" if add2== "BSIC Area" //BSIC shilpanagari is in chauddagram in other observations address
replace UZ_NAME_E= "CHAUDDAGRAM" if add2== "BSIC Area"
replace UPZA= "31" if add2== "BSIC Area"
replace ZILA= "19" if add2== "BSIC Area"
replace Upazila_cd= 1931 if add2== "BSIC Area"
//2 observations change 

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Chakbazar" //Chakbazar in comilla adarsha sadar, found online
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Chakbazar"
replace UPZA= "67" if add2== "Chakbazar"
replace ZILA= "19" if add2== "Chakbazar"
replace Upazila_cd= 1967 if add2== "Chakbazar"
//2 observations change 

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Sati Patti, Comilla" //Sati patti in Chakbazar in comilla adarsha sadar, found online
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Sati Patti, Comilla"
replace UPZA= "67" if add2== "Sati Patti, Comilla"
replace ZILA= "19" if add2== "Sati Patti, Comilla"
replace Upazila_cd= 1967 if add2== "Sati Patti, Comilla"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Gul-bagichhha govt. Primary School" //gul bagichha in comilla adarsha sadar, found online
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Gul-bagichhha govt. Primary School"
replace UPZA= "67" if Name== "Gul-bagichhha govt. Primary School"
replace ZILA= "19" if Name== "Gul-bagichhha govt. Primary School"
replace Upazila_cd= 1967 if Name== "Gul-bagichhha govt. Primary School"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Rose Garden International School" //in comilla adarsha sadar, found online
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Rose Garden International School"
replace UPZA= "67" if Name== "Rose Garden International School"
replace ZILA= "19" if Name== "Rose Garden International School"
replace Upazila_cd= 1967 if Name== "Rose Garden International School"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Victoria Govt. college" //in comilla adarsha sadar, found online
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Victoria Govt. college"
replace UPZA= "67" if Name== "Victoria Govt. college"
replace ZILA= "19" if Name== "Victoria Govt. college"
replace Upazila_cd= 1967 if Name== "Victoria Govt. college"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Akanda General Hospital" //in comilla adarsha sadar, found online
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Akanda General Hospital"
replace UPZA= "67" if Name== "Akanda General Hospital"
replace ZILA= "19" if Name== "Akanda General Hospital"
replace Upazila_cd= 1967 if Name== "Akanda General Hospital"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Mission Hospital" //Shasangacha in comilla adarsha sadar in other observation in the dataset
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Mission Hospital"
replace UPZA= "67" if Name== "Mission Hospital"
replace ZILA= "19" if Name== "Mission Hospital"
replace Upazila_cd= 1967 if Name== "Mission Hospital"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Islami School & Madrasha" //"Univers Ideal School" in same address in comilla adarsha sadar in other observation in the dataset
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Islami School & Madrasha"
replace UPZA= "67" if Name== "Islami School & Madrasha"
replace ZILA= "19" if Name== "Islami School & Madrasha"
replace Upazila_cd= 1967 if Name== "Islami School & Madrasha"
//1 observation changes 

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Tolikan, Chakbazar" //Chakbazar in comilla adarsha sadar, found online for another observation
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Tolikan, Chakbazar"
replace UPZA= "67" if add2== "Tolikan, Chakbazar"
replace ZILA= "19" if add2== "Tolikan, Chakbazar"
replace Upazila_cd= 1967 if add2== "Tolikan, Chakbazar"
//1 observations change 

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Chakbazar, Comilla" //Chakbazar in comilla adarsha sadar, found online for another observation
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Chakbazar, Comilla"
replace UPZA= "67" if add2== "Chakbazar, Comilla"
replace ZILA= "19" if add2== "Chakbazar, Comilla"
replace Upazila_cd= 1967 if add2== "Chakbazar, Comilla"
//1 observations change 

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Housing" //Housing in comilla adarsha sadar, found for other observation in the dataset
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Housing"
replace UPZA= "67" if add2== "Housing"
replace ZILA= "19" if add2== "Housing"
replace Upazila_cd= 1967 if add2== "Housing"
//1 observations change 

replace NAME_3 = "Comilla Adarsha Sadar" if add2== "Nanuar Digirpar" //3500, comilla in comilla adarsha sadar found online, Nazrula mem academy address 3500 comilla
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if add2== "Nanuar Digirpar"
replace UPZA= "67" if add2== "Nanuar Digirpar"
replace ZILA= "19" if add2== "Nanuar Digirpar"
replace Upazila_cd= 1967 if add2== "Nanuar Digirpar"
//1 observations change 

replace NAME_3 = "Comilla Adarsha Sadar" if Name== "Comilla Mission School & College" //"Comilla Mission School & College" in comilla adarsha sadar found online, address 3500 comilla
replace UZ_NAME_E= "COMILLA ADARSHA SADAR" if Name== "Comilla Mission School & College"
replace UPZA= "67" if Name== "Comilla Mission School & College"
replace ZILA= "19" if Name== "Comilla Mission School & College"
replace Upazila_cd= 1967 if Name== "Comilla Mission School & College"
//1 observations change 

replace NAME_3 = "Rangpur Sadar" if add2== "Word No-008" //"Word No-008" in Rangpur sadar, found in another observation of the data set
replace UZ_NAME_E= "RANGPUR SADAR" if add2== "Word No-008"
replace UPZA= "49" if add2== "Word No-008"
replace ZILA= "85" if add2== "Word No-008"
replace Upazila_cd= 8549 if UPZA== "49" & ZILA== "85"
//2 observations change 

replace NAME_3 = "Rangpur Sadar" if add2== "J.L.Ray Road , Word no-10" | add2== "J.L.Ray Road , Word no-9" //"J.L.Ray Road" in Rangpur sadar in 2019, found online. However, Rangpur district was formed in 2010
replace UZ_NAME_E= "RANGPUR SADAR" if add2== "J.L.Ray Road , Word no-10" | add2== "J.L.Ray Road , Word no-9"
replace UPZA= "49" if  add2== "J.L.Ray Road , Word no-10" | add2== "J.L.Ray Road , Word no-9"
replace ZILA= "85" if add2== "J.L.Ray Road , Word no-10" | add2== "J.L.Ray Road , Word no-9"
replace Upazila_cd= 8549 if UPZA== "49" & ZILA== "85"
//2 observations change 

count if NAME_3 == ""
drop if NAME_3 == ""
save "$Data\DataCreated\BR09_OnlyMissingFilling", replace //93



use "$Data\DataCreated\BR2009UpaName", clear  //100194
destring Upazila_cd, replace
destring Zila_cd, replace
drop if NAME_3 == "" //100101
append using "$Data\DataCreated\BR09_OnlyMissingFilling" //100194
count if NAME_3 == "" //0
list if NAME_2=="COX'S BAZAR" & Zila_cd==15 //none
by NAME_2 NAME_3, sort: gen nvals= _n==1
count if nvals //536
drop nvals
by Zila_cd ZILA NAME_2 Upazila_cd UPZA UZ_NAME_E, sort: gen nvals= _n==1
count if nvals //536
drop nvals
by Zila_cd Upazila_cd, sort: gen nvals= _n==1
count if nvals //536
drop nvals


order ZILA ZL_NAME_E NAME_2  , after(Zila_cd)
order UPZA UZ_NAME_E  NAME_3 , after(Upazila_cd)
format UZ_NAME_E NAME_3 %15s
format ZL_NAME_E NAME_2 %10s
format Name add1 add2 add3 %30s
save "$Data\DataCreated\BR2009Upazila_noMissing", replace // filled missing upazila name


use "$Data\DataCreated\BR2009Upazila_noMissing", replace
sum tot_emp, det
sum tot_emp if Divisions==14, det
tabstat tot_emp if Divisions==14 & tot_emp<12, stat(sum mean)
tabstat tot_emp if Divisions==14, stat(sum mean)
di (5793/1662344)*100


* 				Business Directory 2019 
******************************************************************

import excel "$Data\BD_2019_AllData_Final_17062021.xlsx", sheet("Sheet1") firstrow clear
//collapse (sum) mTPE , by(zilla_id upazila_id upazila_name_comite_eng)  // Mirsharai missing
tab BSIC // I did some one by one check with BR2009 though not all
count if mTPE<10  //0


*count upazila
by division_name_eng zilla_name_comite_eng upazila_name_comite_eng, sort: gen nvals = _n == 1
count if nvals //566
drop nvals 
by zilla_name_comite_eng upazila_name_comite_eng, sort: gen nvals = _n == 1
count if nvals //566
drop nvals 
by upazila_name_comite_eng, sort: gen nvals = _n == 1
count if nvals //549
drop nvals 
by division_id zilla_id upazila_id upazila_name_comite_eng, sort: gen nvals = _n == 1
count if nvals //565
drop nvals 
by zilla_id upazila_id upazila_name_comite_eng, sort: gen nvals = _n == 1
count if nvals //565
drop nvals 
by zilla_id upazila_id , sort: gen nvals = _n == 1
count if nvals //565
drop nvals 

replace zilla_name_comite_eng = "TANGAIL" if zilla_name_comite_eng == "TANGAIL " //space alignment problem
by division_name_eng zilla_name_comite_eng upazila_name_comite_eng, sort: gen nvals = _n == 1
count if nvals //565
drop nvals 
/*
collapse mTPE, by(division_name_eng zilla_name_comite_eng zilla_id upazila_id upazila_name_comite_eng)
sort zilla_id upazila_id
quietly by zilla_id upazila_id:  gen dup = cond(_N==1,0,_n)
drop dup:  gen dup = cond(_N==1,0,_n)
drop dup
*/

*count zilla
by zilla_name_comite_eng, sort: gen nvals= _n==1
count if nvals //64
drop nvals

rename zilla_name_comite_eng NAME_2
rename upazila_name_comite_eng NAME_3
replace NAME_2 = proper(NAME_2)
replace NAME_3 = proper(NAME_3)
gen year=2019
save "$Data\DataCreated\BD2019", replace //127042



*Haromonise upazila name with shape file and BR2009
use "$Data\DataCreated\BD2019", clear
replace NAME_3 = "Morrelganj" if NAME_3 == "Morelganj"
replace NAME_3 = "Sarankhola" if NAME_3=="Sharankhola"
replace NAME_3 = "Naikhongchhari" if NAME_3== "Naikkhongchhari"
replace NAME_2 = "Barisal" if NAME_2== "Barishal"
replace NAME_2 = "Bogra" if NAME_2== "Bogura"
replace NAME_2 = "Brahamanbaria" if NAME_2== "Brahmanbaria"
replace NAME_2 = "Chittagong" if NAME_2== "Chattogram"
replace NAME_2 = "Comilla" if NAME_2== "Cumilla"
replace NAME_2 = "Cox'S Bazar" if NAME_2== "Coxs Bazar"
replace NAME_2 = "Jessore" if NAME_2== "Jashore"
replace NAME_3 = "Baghai Chhari" if NAME_3 =="Baghaichhari"
replace NAME_3 = "Balia Kandi" if NAME_3 == "Baliakandi"
replace NAME_3 = "Goalandaghat" if NAME_3 == "Goalanda"
replace NAME_3 = "Golabganj" if NAME_3 == "Golapganj"
replace NAME_3 = "Kotali Para" if NAME_3 == "Kotalipara"
replace NAME_3 = "Noakhali Sadar (Sudharam)" if NAME_3 == "Noakhali Sadar"
replace NAME_3 = "Saghatta" if NAME_3 == "Saghata"
replace NAME_3 = "Tungi Para" if NAME_3 == "Tungipara"
replace NAME_3 = "Banari Para" if NAME_3 == "Banaripara"
replace NAME_3 = "Barisal Sadar (Kotwali)" if NAME_3 == "Barishal Sadar (Kotwali)"
replace NAME_3 = "Hizla" if NAME_3 == "Hijla"
replace NAME_3 = "Wazirpur" if NAME_3 == "Ujirpur"
replace NAME_3 = "Burhanuddin" if NAME_3 == "Borhanuddin"
replace NAME_3 = "Char Fasson" if NAME_3 == "Charfasson"
replace NAME_3 = "Manpura" if NAME_3 == "Monpura"
replace NAME_3 = "Bogra Sadar" if NAME_3 == "Bogura Sadar"
replace NAME_3 = "Dhupchanchia" if NAME_3 == "Dupchachia"
replace NAME_3 = "Sonatola" if NAME_3 == "Sonatala"
replace NAME_3 = "Haim Char" if NAME_3 == "Haimchar"
replace NAME_3 = "Matlab Dakshin" if NAME_3 == "Matlab Dakkhin"
replace NAME_2 = "Nawabganj" if NAME_2 == "Chapainababganj" // no idea if there is any difference betweeen Nawabgonj and Chapainababganj
replace NAME_2 = "Maulvibazar" if NAME_2 == "Moulvibazar"
replace NAME_3 = "Anowara" if NAME_3 == "Anwara"
replace NAME_3 = "Double Mooring" if NAME_3 == "Doublemooring"
replace NAME_3 = "Jiban Nagar" if NAME_3 == "Jibannagar"
replace NAME_3 = "Brahman Para" if NAME_3 == "Brahmanpara"
replace NAME_3 = "Comilla Sadar Dakshin" if NAME_3 == "Cumilla Sadar Dakkhin"
replace NAME_3 = "Cox'S Bazar Sadar" if NAME_3 == "Coxs Bazar Sadar"
replace NAME_3 = "Adabor" if NAME_3 == "Adabar"
//replace NAME_3 = "Uttara And Bimanbandar" if NAME_3 == "Bimanbandar" //to match with Census geograpy
replace NAME_3 = "Chak Bazar" if NAME_3 == "Chakbazar"
replace NAME_3 = "Dakshinkhan" if NAME_3 == "Dakkhinkhan"
replace NAME_3 = "Darus Salam" if NAME_3 == "Darussalam"
replace NAME_3 = "Hazaribagh" if NAME_3 == "Hazaribag"
replace NAME_3 = "Kamrangir Char" if NAME_3 == "Kamrangichar"
replace NAME_3 = "Lalbagh" if NAME_3 == "Lalbag"
replace NAME_3 = "New Market" if NAME_3 == "Newmarket"
replace NAME_3 = "Sabujbagh" if NAME_3 == "Sabujbag"
replace NAME_3 = "Shahbagh" if NAME_3 == "Shahbag"
replace NAME_3 = "Sher-e-bangla Nagar" if NAME_3 == "Shere Bangla Nagar"
replace NAME_3 = "Tejgaon Ind. Area" if NAME_3 == "Tejgaon Shilpa Elaka"
replace NAME_3 = "Uttar Khan" if NAME_3 == "Uttarkhan"
replace NAME_3 = "Biral" if NAME_3 == "Birol"
replace NAME_3 = "Nawabganj" if NAME_3 == "Nababganj"
replace NAME_3 = "Parshuram" if NAME_3 == "Parashuram"
replace NAME_3 = "Comilla Adarsha Sadar" if NAME_3 == "Adarsha Sadar"
replace NAME_3 = "Bagher Para" if NAME_3 == "Bagharpara"
replace NAME_3 = "Jhalokati Sadar" if NAME_3 == "Jhalokathi Sadar"
replace NAME_3 = "Nalchhity" if NAME_3 == "Nalchity"
replace NAME_3 = "Harinakunda" if NAME_3 == "Harinakundu"
replace NAME_3 = "Lakshmichhari" if NAME_3 == "Lakkhichhari"
replace NAME_3 = "Kuliar Char" if NAME_3 == "Kuliarchar"
replace NAME_3 = "Char Rajibpur" if NAME_3 == "Rajibpur"
replace NAME_3 = "Raumari" if NAME_3 == "Roumari"
replace NAME_3 = "Roypur" if NAME_3 == "Raipur"
replace NAME_3 = "Shib Char" if NAME_3 == "Shibchar"
replace NAME_3 = "Shibalaya" if NAME_3 == "Shibalay"
replace NAME_3 = "Mujib Nagar" if NAME_3 == "Mujibnagar"
replace NAME_3 = "Nalchity" if NAME_3 == "Nalchhity"
replace NAME_3 = "Barlekha" if NAME_3 == "Baralekha"
replace NAME_3 = "Maulvi Bazar Sadar" if NAME_3 == "Moulvibazar Sadar"
replace NAME_3 = "Lohajang" if NAME_3 == "Louhajang"
replace NAME_3 = "Serajdikhan" if NAME_3 == "Sirajdikhan"
replace NAME_3 = "Gaffargaon" if NAME_3 == "Gafargaon"
replace NAME_3 = "Gauripur" if NAME_3 == "Gouripur"
replace NAME_3 = "Roypura" if NAME_3 == "Raipura"
replace NAME_3 = "Bagati Para" if NAME_3 == "Bagatipara"
replace NAME_3 = "Nawabganj Sadar" if NAME_3 == "Chapainawabganj Sadar"
replace NAME_3 = "Netrokona Sadar" if NAME_3 == "Netrakona Sadar"
replace NAME_3 = "Senbagh" if NAME_3 == "Senbag"
replace NAME_3 = "Atwari" if NAME_3 == "Atowari"
replace NAME_3 = "Kala Para" if NAME_3 == "Kalapara"
replace NAME_3 = "Nesarabad (Swarupkati)" if NAME_3 == "Nesarabad (Swarupkathi)"
replace NAME_3 = "Baghmara" if NAME_3 == "Bagmara"
replace NAME_3 = "Belai Chhari" if NAME_3 == "Belaichhari"
replace NAME_3 = "Jurai Chhari" if NAME_3 == "Jurachhari"
replace NAME_3 = "Kawkhali (Betbunia)" if NAME_3 == "Kawkhali" & NAME_2 =="Rangamati"
replace NAME_3 = "Mitha Pukur" if NAME_3 == "Mithapukur"
replace NAME_3 = "Assasuni" if NAME_3 == "Ashashuni"
replace NAME_3 = "Zanjira" if NAME_3 == "Zajira"
replace NAME_3 = "Chauhali" if NAME_3 == "Chouhali"
replace NAME_3 = "Royganj" if NAME_3 == "Rayganj"
replace NAME_3 = "Ullah Para" if NAME_3 == "Ullapara"
replace NAME_3 = "Bishwambarpur" if NAME_3 == "Bishwambharpur"
replace NAME_3 = "Dakshin Sunamganj" if NAME_3 == "Dakkhin Sunamganj"
replace NAME_3 = "Dharampasha" if NAME_3 == "Dharmapasha"
replace NAME_3 = "Sulla" if NAME_3 == "Shalla"
replace NAME_3 = "Beani Bazar" if NAME_3 == "Beanibazar"
replace NAME_3 = "Dakshin Surma" if NAME_3 == "Dakkhin Surma"
replace NAME_3 = "Jaintiapur" if NAME_3 == "Jaintapur"
replace NAME_3 = "Bhuapur" if NAME_3 == "Bhuanpur"
replace NAME_3 = "Ranisankail" if NAME_3 == "Ranishankail"
replace NAME_3 = "Phulpur" if NAME_3 == "Fulpur"

//keep if NAME_2 == "Dhaka"
//sort NAME_3
//collapse (sum) mTPE , by (NAME_2 NAME_3)
//di 3673 + 18348 //Uttara Purba & Uttra Pashchim
//replace mTPE = 22021 if NAME_3 == "Uttara Purba" // Uttara exist in 2009, code is 2695
replace NAME_3="Uttara" if NAME_3 == "Uttra Pashchim"  // in 2019 its code is 2694 which does not exist in 2009,
replace upazila_id = "95" if NAME_3 == "Uttara" & upazila_id == "94"  // there is Uttara in using shape file, in the BR data there are two rows Uttara Purba & Uttra Pashchim, I add them in Uttara so that I can merge Uttara with shape file
replace NAME_3 = "Uttara" if NAME_3 == "Uttara Purba" // there is Uttara in using shape file, in the BR data there are two rows Uttara Purba & Uttra Pashchim, I add them in Uttara so that I can merge Uttara with shape file
//replace NAME_3 = "Uttara And Bimanbandar" if NAME_3 == "Uttara" //to match with Census geograpy

/*
merge 1:1 NAME_2 NAME_3 using "bdupzdb"
*28 upazila do not match
keep if _merge==3
drop _merge */
save "$Data\DataCreated\BD2019Upazila", replace
collapse (sum) mTPE , by(NAME_2 NAME_3) //Not 565 upazila but 564 because I merged Uttara Purba & Pashim 

use "$Data\DataCreated\BD2019Upazila", clear
sort NAME_2 NAME_3
save "$Data\DataCreated\BD2019Upazila", replace





** Organising Upazila that has changed, merged, broke down......... between 2009 and 2019
use "$Data\DataCreated\BD2019Upazila", clear

gen Divisions = substr(BSIC, 1, 2), after(BSIC)
destring Divisions, replace

sum mTPE, det
sum mTPE if Divisions==14, det
tabstat mTPE if Divisions==14, stat(sum mean)
tabstat mTPE if Divisions==14 & mTPE<12, stat(sum mean)
di (7614/ 1731928)*100

tabstat mTPE if Divisions==14 | Divisions==13, stat(N sum mean min max sd) 
tabstat mTPE if Divisions==14 , stat(N sum mean min max sd) 
gen Male= TPPer_Male + TPTem_Male
gen Female= TPPer_Female + TPTem_FeMale
tabstat Male if Divisions==14 | Divisions==13, stat(N sum mean min max sd) 
tabstat Male if Divisions==14 , stat(N sum mean min max sd) 
tabstat Female if Divisions==14 | Divisions==13, stat(N sum mean min max sd) 
tabstat Female if Divisions==14 , stat(N sum mean min max sd) 
di (963704/1731928)*100
di (1236167/ 2455766)*100 

rename zilla_id Zila
rename NAME_3 Upazila

//keep if Upazila == "Zianagar" | Upazila== "Indurkani"
replace Upazila = "Zianagar" if Upazila== "Indurkani" //On 28 July 1980, President Ziaur Rahman turned Indurkani river police station into a full police station. On 21 April 2002, Prime Minister Khaleda Zia renamed Indurkani into Zianagar Upazila. On 9 January 2017, the National Implementation Committee for Administrative Reform led by Prime Minister Sheikh Hasina renamed Zianagar Upazila back to Indurkani Upazila।  // No code adjustment needed, 2009 has same code 79 90 for Zianagar. Only name adjustment.  // 56 obs

//keep if Upazila == "Brahmanbaria Sadar" | Upazila == "Bijoynagar" & NAME_2 == "Brahamanbaria"
replace  Upazila = "Brahmanbaria Sadar" if Upazila == "Bijoynagar" & NAME_2 == "Brahamanbaria" // Bijoynagar to Brahmanbaria sadar: Bijoynagar is new upazila 2010, বিগত ৩ আগষ্ট ২০১০ খ্রিঃ তারিখে ৪৮২তম উপজেলা হিসেবে এর প্রশাসনিক কার্যক্রম শুরম্ন হয়েছে। ইতোপূর্বে উপজেলাটি ব্রা‏হ্ম‏ণবাড়িয়া সদর উপজেলার অমত্মর্ভূক্ত হলেও তিতাস নদী দ্বারা বিচ্ছিন্ন বলে এখানে ভিন্নধর্মী একটি আবহ ও আমেজ রয়েছে। (bijoynagar upazila website). 
replace  upazila_id = "13" if upazila_id == "07" & Zila == "12" // Bijoynagar is new upazila 2010 from Brahmanbaria sadar //105 obs

//keep if Upazila == "Pangsha" | Upazila == "Kalukhali"
replace Upazila = "Pangsha" if Upazila== "Kalukhali" & Zila == "82" //Kalukhali to Pangsha: রাজবাড়ী জেলার বৃহৎপাংশা উপজেলার ৭টি ইউনিয়ন নিয়ে কালুখালী উপজেলা গঠিত। ইউনিয়নগুলো হচ্ছে :রতনদিয়া ইউপি,কালিকাপুর ইউপি, বোয়ালিয়া ইউপি, মাঝবাড়ী ইউপি, মদাপুর ইউপি, মৃগী ইউপি ও সাওরাইল ইউপি। ২০১০ সালে জুন মাসে কালুখালী উপজেলার প্রশাসনিক কার্যক্রম শুরু হয়।  (upazila website, accessed on 17 September 2021)
replace upazila_id= "73" if upazila_id == "47" & Zila == "82" //73 & 82 exist for Pangsha in 2009, but no 47 & 82 Kalukhali //81 obs

//keep if Upazila== "Balaganj" | Upazila == "Osmaninagar"
replace Upazila= "Balaganj" if Upazila == "Osmaninagar" & Zila == "91" //Osmaninagar to Balaganj: Osmani Nagar thana was established with eight Union Parishads of Balaganj on 23 March 2001. On 2 June 2014, the thana was turned into an upazila. (Wikipedia, accessed on 17 September 2021)
replace upazila_id= "08" if upazila_id == "60" & Zila == "91" //08 & 91 exist for balaganj in 2009, but no 60 & 91  Osmaninagar //108 obs

//keep if Upazila == "Galachipa" | Upazila== "Rangabali"
replace upazila_id = "57" if Upazila== "Rangabali" & upazila_id == "97" & Zila == "78" //Rangabali to Galachipa, Patuakhali: 57 78 exist for galachipa, but no 97 78 Rangabali in 2009
replace Upazila = "Galachipa" if Upazila== "Rangabali" & Zila == "78" //On 7 June 2011, Rangabali became an upazila after being partitioned from the Galachipa Upazila. (Wikipedia, accessed on 17 September 2021) //32 obs

//keep if Upazila == "Natore Sadar" | Upazila =="Naldanga"
replace Upazila = "Natore Sadar" if Upazila =="Naldanga"  & Zila == "69"
replace upazila_id = "63" if upazila_id == "55" & Zila == "69" //Naldanga to Natore, Natore: Naldanga was previously a union of Natore Upazila in Rajshahi Division of Bangladesh but, in a Government gazette published in May 2013, Naldanga was declared as an Upazila of Bangladesh. (Wikipedia, accessed on 17 September 2021) //55 obs

//keep if Upazila == "Phulpur" | Upazila =="Tarakanda" & Zila == "61" 
replace upazila_id = "81" if upazila_id == "88" & Zila == "61" // no 61 88 Tarakanda exist in 2009, but 61 81 Phulpur
replace Upazila = "Phulpur" if Upazila == "Tarakanda" & Zila == "61" //Tarakanda to Phulpur,  Mymensingh: Tarakanda was established as a thana on 19 May 1999. In 2012, the Tarakanda Thana was upgraded into an upazila (sub-district), making it Mymensingh District's latest upazila.[3] Prior to this, Tarakanda was a part of the Phulpur Upazila.(Wikipedia, accessed on 17 September 2021) //88 obs

//keep if Upazila == "Matiranga" | Upazila =="Guimara"
replace Upazila = "Matiranga" if (Upazila =="Guimara" | Upazila == "Ramgarh" | Upazila == "Mahalchhari") & Zila == "46" // Guimara & Ramgarh & Mahalchhari to Matiranga: ২০১৪ সালের ৬ জুন প্রশাসনিক পুনর্বিন্যাস সংক্রান্ত জাতীয় বাস্তবায়ন কমিটির ১০৯তম সভায় এই উপজেলাকে অনুমোদন দেয়া হয়. গুইমারা উপজেলায় বর্তমানে ৩টি ইউনিয়ন রয়েছে। সম্পূর্ণ উপজেলার প্রশাসনিক কার্যক্রম গুইমারা থানার আওতাধীন।  (Wikipedia, accessed on 17 September 2021). গুইমারা ইউনিয়ন ছিল মাটিরাঙ্গা উপজেলার আওতাধীন ৭নং ইউনিয়ন পরিষদ। বর্তমানে এটি গুইমারা উপজেলার আওতাধীন ১নং ইউনিয়ন পরিষদ। (Wikipedia, accessed on 17 September 2021). হাফছড়ি ইউনিয়ন ছিল রামগড় উপজেলার আওতাধীন ৩নং ইউনিয়ন পরিষদ। বর্তমানে এটি গুইমারা উপজেলার আওতাধীন ২নং ইউনিয়ন পরিষদ। এ ইউনিয়নের প্রশাসনিক কার্যক্রম গুইমারা থানার আওতাধীন। (Wikipedia, accessed on 17 September 2021). সিন্দুকছড়ি ইউনিয়ন গুইমারা উপজেলার আওতাধীন ৩নং ইউনিয়ন পরিষদ, তবে পূর্বে এটি মহালছড়ি উপজেলাধীন ৫নং ইউনিয়ন পরিষদ ছিল। এ ইউনিয়নের প্রশাসনিক কার্যক্রম গুইমারা থানার আওতাধীন। (Wikipedia, accessed on 17 September 2021). According to Upazila website and wikipedia no mention of any change in Ramgarh and Mohalcharri over this period.
replace upazila_id = "70" if (upazila_id =="47" | upazila_id =="80" | upazila_id =="65")  & Zila == "46" // no 47 46 guimara in 2009, but 70 46 matiranga in 2009 //5,684 obs

//keep if Upazila == "Gazipur Sadar" | Upazila =="Tongi" | Upazila =="Joydebpur" & Zila== "33"
replace upazila_id = "30" if upazila_id == "20" & Upazila == "Tongi" & Zila == "33" //Tongi, a thana (police station) within the Gazipur Sadar Upazila along with Joydebpur since 1983 (Wikipedia, accessed on 17 September 2021); 
replace Upazila = "Gazipur Sadar" if Upazila =="Tongi" & Zila== "33" //Tongi, a thana (police station) within the Gazipur Sadar Upazila along with Joydebpur since 1983 //505 obs
replace upazila_id = "30" if upazila_id == "99" & Upazila == "Joydebpur" & Zila == "33"
replace Upazila = "Gazipur Sadar" if Upazila =="Joydebpur" | Upazila == "Tongi" & Zila== "33" // No 99 and 20 30 for Joydebpur and Tongi in 2009, but 30 33 Gazipur sadar. //1261 obs

//keep if Upazila == "Amtali" | Upazila=="Taltali" & Zila == "04"
replace Upazila = "Amtali" if Upazila=="Taltali" & Zila == "04" //Taltali to Amtali, Barguna: Taltali Upazila was established on 25 April 2012. It was previously part of Amtali Upazila. (Wikipedia, accessed on 17 September 2021).
replace upazila_id = "09" if upazila_id == "90" & Zila == "04" //51 obs

//keep if Upazila == "Laksam" if Upazila =="Lalmai" | Upazila == "Comilla Sadar Dakshin" & Zila== "19"
replace Upazila = "Comilla Sadar Dakshin" if Upazila =="Lalmai" & Zila== "19" // Lalmai to Comilla Sadar Dakshin, Comilla: নং ৪৬.০৪৬.০১৮.০০.০০.০৬৭.২০১৪-৩২৬-০৯ জানুয়ারি ২০১৭/২৬ পৌষ ১৪২৩ তারিখে অনুষ্ঠিত প্রশাসনিক পুনর্বিন্যাস সংক্রান্ত জাতীয় বাস্তবায়ন কমিটি (নিকার) এর ১১৩ তম বঠৈকের সিদ্ধান্ত অনুযায়ী কুমিল্লা সদর দক্ষিণ উপজেলার ৮টি ইউনিয়ন , যথা:(১) বাগমারা (উত্তর), (২) বাগমারা (দক্ষিণ) , (৩) ভূলইন (উত্তর), (৪) ভূলইন (দক্ষিণ), (৫) পেরুল (উত্তর), (৬) পেরুল (দক্ষিণ) (৭) বেলঘর (উত্তর), (৮) বেলঘর (দক্ষিণ), এবং লাকসাম উপজেলার ১টি ইউনিয়ন, যথা (৯) বাকই (উত্তর) সহ সর্বমোট ৯টি ইউনিয়ন সমন্বয়ে ‍‍‌‌"লালমাই' উপজেলা গঠন করার বিষয়ে সিদ্ধান্ত গৃহীত হয়। (Upazila website, accessed on 17 September 2021)//103 obs
replace upazila_id = "33" if upazila_id =="73" & Zila== "19" // no 73 19 for Lamai exist in 2009, but 72 and 67 19 for laksam and Comilla sadar. //Lalmai Upazila (Bengali: লালমাই উপজেলা) is an upazila of Comilla District in the Division of Chittagong, Bangladesh. Lalmai is the 17th upazila of Comilla District and 491st upazila of the country. //103 obs

//keep if Upazila == "Karnafuli (Police Station)" | Upazila == "Karnaphuli" & Zila == "15"
replace Upazila = "Karnafuli (Police Station)" if Upazila == "Karnaphuli" & Zila == "15" // just name adjustment, same exist in 2009 //119 obs

replace  Upazila = "Pahartali" if (Upazila == "Akbarshah" | Upazila == "Khulshi") & NAME_2 == "Chittagong" // ২০১৩ সালের ৩০ মে চট্টগ্রাম সিটি কর্পোরেশনের পাহাড়তলী থানা ও খুলশী থানা থেকে কিছু অংশ নিয়ে আকবর শাহ থানা গঠিত হয়।  ১৯৭৮ সালের ৩০ নভেম্বর হাটহাজারী উপজেলার কিছু অংশ এবং আরো ৬টি মেট্রোপলিটন থানা নিয়ে চট্টগ্রাম সিটি কর্পোরেশন গঠিত হয়, তন্মধ্যে অন্যতম পাহাড়তলী থানা। ২০০০ সালের ২৭ মে পাহাড়তলী থানা ও পাঁচলাইশ থানা থেকে কিছু অংশ নিয়ে খুলশী থানা গঠন করা হয়।(Wikipedia, accessed on 17 September 2021)
replace upazila_id = "55" if (upazila_id == "02" | upazila_id == "43") & Zila == "15" // 2210 obs

replace  Upazila = "Kotwali" if (Upazila == "Chalk Bazar" | Upazila == "Panchlaish" | Upazila == "Double Mooring" | Upazila == "Sadarghat")  & NAME_2 == "Chittagong" // ২০১৩ সালের ৩০ মে পাঁচলাইশ থানা ও কোতোয়ালী থানার কিছু অংশ নিয়ে চকবাজার থানা গঠন করা হয়।  ১৯৭৮ সালের ৩০ নভেম্বর হাটহাজারী উপজেলার ১টি ওয়ার্ড এবং আরো ৬টি মেট্রোপলিটন থানা নিয়ে চট্টগ্রাম সিটি কর্পোরেশন গঠিত হয়, তন্মধ্যে পাঁচলাইশ থানা অন্যতম।[২] ২০০৭ সালে এ থানা পুলিশ রিফর্ম প্রোগ্রাম (পিআরপি)-র আওতায় প্রথম ধাপে মডেল থানা হিসেবে স্বীকৃতি পায়।[৩]. ১৯২২ সালে কোতোয়ালী থানা গঠিত হয়। (Wikipedia, accessed on 17 September 2021). Found some address with Chalk bazar in Kotwali upazila, in 2009 dataset. not sure how much it covers
// ২০১৩ সালের ৩০ মে কোতোয়ালী থানা ও ডবলমুরিং থানা থেকে কিছু অংশ নিয়ে সদরঘাট থানা গঠন করা হয়। ১৯৭৮ সালের ৩০ নভেম্বর হাটহাজারী উপজেলার ১টি ওয়ার্ড এবং আরো ৬টি থানার সমন্বয়ে চট্টগ্রাম সিটি কর্পোরেশন গঠিত হয়, তন্মধ্যে ডবলমুরিং থানা অন্যতম। ১৯২২ সালে কোতোয়ালী থানা গঠিত হয়। তবে ১৯৭৮ সালের ৩০ নভেম্বর হাটহাজারী উপজেলার ১টি ওয়ার্ড এবং আরো ৬টি থানার সমন্বয়ে চট্টগ্রাম সিটি কর্পোরেশন গঠিত হয়, তন্মধ্যে কোতোয়ালী থানা অন্যতম।  (Wikipedia, accessed on 17 September 2021). No Sadarghat in 2009 but found some address with Sadarghat in Double Mooring, in 2009 dataset
replace upazila_id = "41" if (upazila_id == "16" | upazila_id == "57" | upazila_id == "28" | upazila_id == "77" ) & Zila == "15" //1020 obs

//keep if NAME_2 == "Chittagong" & Upazila == "Chittagong Port" | Upazila == "Epz" 
replace  Upazila = "Chittagong Port" if (Upazila == "Epz" | Upazila == "Patenga") & NAME_2 == "Chittagong" // ২০১৩ সালের ৩০ মে বন্দর ও পতেঙ্গা থানা থেকে কিছু অংশ নিয়ে ইপিজেড থানা গঠন করা হয়।. ১৯৭৮ সালের ৩০ নভেম্বর হাটহাজারী উপজেলার কিছু অংশ ও আরো ৬টি থানা নিয়ে গঠিত হয় চট্টগ্রাম সিটি কর্পোরেশন, তন্মধ্যে বন্দর থানা অন্যতম।. ২০০০ সালের ২৭ মে বন্দর থানার কিছু অংশ নিয়ে পতেঙ্গা থানা গঠন করা হয় (Wikipedia, accessed on 17 September 2021). No EPZ in 2009 but found some address with EPZ in chittagong port in 2009 dataset
replace  upazila_id = "20" if (upazila_id == "31" | upazila_id == "65") & Zila == "15" // no 31 15 EPZ in 2009, but there is 20 15 Chittagong port //338  obs

//keep if NAME_2 == "Dhaka"
replace  Upazila = "Gulshan" if Upazila == "Banani" & NAME_2 == "Dhaka" //বনানী মডেল টাউন গুলশান থানা ১৯ নম্বর ওয়ার্ড এর একটি অংশ  (Wikipedia, accessed on 17 September 2021). No Banani upazila in 2009 but found all the banani address in Gulshan, in 2009 dataset
replace  upazila_id = "26" if upazila_id == "07" & Zila == "26" //384 obs

replace  Upazila = "Kotwali" if Upazila == "Bangshal" & NAME_2 == "Dhaka" //Bangshal to Kotwali: Administration Bangshal Thana was formed on 30 September 2009 comprising part of Kotwali thana (Online Banglapedia). No Bangshal upazila in 2009 but found all the Bangshal address in Kotwali, in 2009 dataset
replace  upazila_id = "40" if upazila_id == "05" & Zila == "26" //798 obs

replace  Upazila = "Kotwali" if (Upazila == "Chak Bazar" | Upazila == "Lalbagh") & NAME_2 == "Dhaka" // Lalbagh and Chak Bazar to Kotwali Administration Chawkbazar Model Thana was formed on 30 August 2009 comprising parts of Lalbagh and Kotwali thanas. Administration Kotwali Thana was formed in 1976. (Banglapedia, access 17 September 2021)  No Chak Bazar upazila in 2009 but found Chak Bazar addresses in Lalbagh in 2009 dataset
replace  upazila_id = "40" if (upazila_id == "09" | upazila_id == "42") & Zila == "26"  //763 obs

replace  Upazila = "Kafrul" if Upazila == "Bhasantek" & NAME_2 == "Dhaka" //২০১২ সালের ১৩ এপ্রিল ঢাকার ৪৫তম থানা হিসেবে ভাষানটেক থানার কার্যক্রম শুরু হয়। কাফরুল থানাকে ভাগ করে ভাষানটেক থানা সৃষ্টি করা হয়েছে। (http://www.online-dhaka.com/619_847_9251_0-bhashantek-thana-dhaka.html , access 17 September 2021) No Bhasantex upazila in 2009 but found Bhasantex addresses in Kafrul, in 2009 dataset
replace  upazila_id = "30" if upazila_id == "21" & Zila == "26" //69 obs

replace  Upazila = "Mohammadpur" if (Upazila == "Sher-e-bangla Nagar" | Upazila == "Kafrul" | Upazila == "Tejgaon") & NAME_2 == "Dhaka" // Administration Sher-E-Bangla Nagar Thana was formed on 4 August 2009 comprising parts of Tejgaon, Kafrul and Mohammadpur thanas (Banglapedia). No Sher-e-bangla Nagar in upazila level in 2009 but found Sher-e-bangla nagar addresses in both Tejgaon and Mohammadpur in 2009 dataset; mohammadpur upazila code 2650 while Sher-e-bangla Nagar thana code is 2650 too but tejgao is 2690 and Tejgaon Ind. Area is 2692  in 2019, so I replaced in to muhammadpur
replace  upazila_id = "66" if (upazila_id == "80"  | upazila_id == "30"  | upazila_id == "90")  & Zila == "26" //888 obs

replace  Upazila = "Badda" if Upazila == "Bhatara" & NAME_2 == "Dhaka" //২০১২ সালের ১১ এপ্রিল ঢাকার ৪৪তম থানা হিসেবে ভাটারা থানার কার্যক্রম শুরু হয়। বাড্ডা থানাকে ভাগ করে ভাটারা থানা সৃষ্টি করা হয়েছে। (http://www.online-dhaka.com/0_0_9250_0-bhatara-thana-dhaka.html  , accessed 17 September 2021) No Bhatara upazila in 2009 but found Bhatara addresses in Badda, in 2009 dataset
replace  upazila_id = "04" if upazila_id == "22" & Zila == "26" //298

replace  Upazila = "Mirpur" if Upazila == "Darus Salam" & NAME_2 == "Dhaka" // Darus Salam to Mirpur, Dhaka: Administration Darus Salam Thana was formed on 23 August 2008 comprising part of Mirpur Model Thana (Banglapedia, accessed on 17 September 2021). No Darus Salam upazila in 2009 but found Darus Salam addresses in Mirpur in 2009 dataset
replace  upazila_id = "48" if upazila_id == "11" & Zila == "26"  //165 obs

replace  Upazila = "Pallabi" if Upazila == "Rupnagar" & NAME_2 == "Dhaka" // ২০১২ সালের ১৫ এপ্রিল ঢাকার ৪৬তম থানা হিসেবে রূপনগর থানার কার্যক্রম শুরু হয়। পল্লবী থানাকে ভাগ করে রূপনগর থানা সৃষ্টি করা হয়েছে। (http://www.online-dhaka.com/619_847_9252_0-rupnagar-thana-dhaka.html , accessed on 17 September 2021) No Rupnagar in upazila level in 2009 but found Rupnagar addresses in Mirpur in 2009 dataset
replace  upazila_id = "64" if upazila_id == "70" & Zila == "26" //63 obs

replace  Upazila = "Dhanmondi" if Upazila == "Kalabagan" & NAME_2 == "Dhaka" //Administration Kalabagan Thana was formed in 2008 with ten mahallas of ward number 50 and 51 (part) of Dhanmondi thana. (Banlapedia, accessed on 17 September 2021) No Kalabagan in upazila level in 2009 but found Kalabagan addresses in Dhanmondi in 2009 dataset
replace  upazila_id = "16" if upazila_id == "33" & Zila == "26" //112 obs

replace  Upazila = "Sabujbagh" if Upazila == "Mugda" & NAME_2 == "Dhaka" //মুগদা থানার অন্তর্গত এলাকাগুলো আগে সবুজবাগ থানার আওতাধীন ছিল। (http://www.online-dhaka.com/619_847_21111_0-mugda-police-station-dhaka-city.html , accessed on 17 September 2021)   No Mugda in upazila level in 2009 but found Mugda addresses in Sabujbagh in 2009 dataset
replace  upazila_id = "68" if upazila_id == "57" & Zila == "26" //120 obs

replace  Upazila = "Sutrapur" if Upazila == "Gendaria" & NAME_2 == "Dhaka" // Administration Gandaria Thana was formed on 4 February 2010 comprising parts of Sutrapur Thana.(Banlapedia, accessed 17 September 2021) No Gendaria in upazila level in 2009 but found Gandaria addresses in Shyampur in 2009 dataset
replace  upazila_id = "88" if upazila_id == "24" & Zila == "26" //202 obs

replace  Upazila = "Sutrapur" if Upazila == "Wari" & NAME_2 == "Dhaka" // No Wari in upazila level in 2009 but found Wari addresses in Sutrapur in 2009 dataset //340 obs
replace  upazila_id = "88" if upazila_id == "98" & Zila == "26"

replace  Upazila = "Khilgaon" if Upazila == "Rampura" & NAME_2 == "Dhaka" // Administration Rampura thana was formed on 2 August in 2009 (Banglpedia). Administration Khilgaon Thana was formed in 1998 comprising part of Sabujbagh, gulshan and Demra Thanas. Rampura Thana was formed in 2009 comprising Ward No. 22 and 23.' (Banglapedia). No Rampura in upazila level in 2009 but found Rampura addresses in Khilgaon in 2009 dataset
replace  upazila_id = "36" if upazila_id == "67" & Zila == "26" //334 obs

replace  Upazila = "Motijheel" if Upazila == "Shahjahanpur" & NAME_2 == "Dhaka" // No Shahjahanpur in upazila level in 2009 but found Shahjahanpur addresses in Motijheel in 2009 dataset
replace  upazila_id = "54" if upazila_id == "73" & Zila == "26" //61 obs
* dhaka has many mismatch and quite confusing.

//keep if NAME_2 == "Jessore" & Upazila == "Kotwali" | Upazila == "Jashore Sadar"
replace  Upazila = "Kotwali" if Upazila == "Jashore Sadar" & NAME_2 == "Jessore" // Only Jessore Sadar & no Kotowali in 2019, Only Kotowali & no Jessore Sadar in 2009, only mismatch upazila level is these two, in some other locations kotowali and sadar is synonymour, so I changed here  //1010 obs 
// 47 41 Kotwali in 2009, and 47 41 Jessore sadar in 2019; seems like they are same

//keep if Upazila == "Hathazari" // 15 37 Hathazari both in 2019 and 2009 ; in 2009 I replaced  NAME_2 = "Chittagong" if Upazila == "Hathazari" & NAME_2 == "Cox'S Bazar" // in 2009 it is in Coxs Bazar but in 2019 in Chittagong 

//replace NAME_2 = "Tangail" if NAME_2=="Tangail "

save "$Data\DataCreated\BD2019UpazilAll", replace //127042
*to check upazila only
collapse(sum) mTPE, by (year Zila Upazila) //535, after upazila revision 526
/*save "justTocheck", replace

use "D:\1. Research\Safety_ManufacturIngIndustry_BD\Data_Manufacturing\1. WorkingOnData_CMISMIBR\UNcon_final draft_working\Data&Result\ResultSave\BR2009Upazila_noMissing.dta", clear
collapse Total, by( year Zila_cd NAME_2 UZ_NAME_E)
sort Zila_cd UZ_NAME_E
gen Upazila = proper( UZ_NAME_E)
rename Zila_cd Zila
tostring Zila, replace
merge 1:1 Zila Upazila using "D:\1. Research\Safety_ManufacturIngIndustry_BD\Data_Manufacturing\1. WorkingOnData_CMISMIBR\UNcon_final draft_working\Data&Result\ResultSave\justTocheck"
drop if _merge==3
sort Upazila
drop in 1/40
drop in 2/25
drop in 3/12
drop in 4/15
drop in 5/55
*mirsharai in 2009, so 536 while in 2019 it is 535 */






******to match variable name with data2019UpazilAll
use "$Data\DataCreated\BR2009Upazila_noMissing", clear 
rename Division_cd division_id
rename DV_NAME_E division_name_eng
order division_name_eng, after(division_id)
replace division_name_eng =  division_name_eng + " " + "DIVISION"

drop Zila_cd Upazila_cd
rename ZILA Zila
drop ZL_NAME_E
replace NAME_2 = proper(NAME_2)
rename UPZA upazila_id
rename NAME_3 Upazila
drop UZ_NAME_E
rename union_cd nunion_id
rename Mauza_cd nmouza_id
rename tot_emp mTPE
rename New_BSIC BSIC

append using "$Data\DataCreated\BD2019UpazilAll.dta"

replace Male = TPPer_Male + TPTem_Male if year ==2019 & Male ==.
replace Female = TPPer_Female + TPTem_FeMale if year ==2019 & Female ==.
drop TPPer_Male  TPTem_Male TPPer_Female  TPTem_FeMale Total status Establishmentcategory CT Remarks ByForce  LessThan20 GreaterThan19 Off_Cat Est_type Pro_Mar Reg_type1 Cetegory Region_cd

count  if missing(real(Inception))
count if Inception != StartYear & year==2019
replace Inception = StartYear if missing(real(Inception)) 
drop StartYear
order union_name_comite_eng mouza_name_comite_eng, after(nmouza_id) 

order Divisions DivisionDescription Group Class ClassDescription , after(BSIC)
order Mobile, after(Tele)

format DivisionDescription ClassDescription Name %30s
egen Ind_description = concat(Divisions ClassDescription), punct(.) 
order Ind_description, after(Class)
format Ind_description %30s
drop DivisionDescription Group Class ClassDescription

format union_name_comite_eng mouza_name_comite_eng %20s
format Name %25s
format add1 add2 add3 Tele %12s 

save "$Data\DataCreated\BRBDlong", replace   // This to be used for firm level analysis


// Check if I missed it somewhere. replace mTPE= 13 if mTPE==100012 & Upazila == "Brahmanbaria" & Upazila == "Akhaura" & Name== "M/S FAHIN WELDING AND AUTO MOBILE" // very inconsistence number compared to other establishment in 2019 and total Akhaura compared to 2009


















********************************************************************************
*				BR/BD to adjust with Population Census 2001 and 2011
********************************************************************************


use "$Data\DataCreated\BRBDlong", clear

gen tot_emp= mTPE, before(Male)
drop mTPE

replace Upazila = "Biman Bandar" if Upazila == "Bimanbandar"
tab NAME_2

egen ID_ZUpazila = concat(Zila upazila_id), decode p(" ")

replace ID_ZUpazila = subinstr(ID_ZUpazila, " ", "", .)

/*
gen tot_emp_App = cond(inlist(AppTexOther,"Apparels"),tot_emp,0)
gen tot_emp_Tex = cond(inlist(AppTexOther,"Textiles"),tot_emp,0)
gen tot_emp_Other = cond(inlist(AppTexOther,"AllOther"),tot_emp,0)
//collapse (sum) tot_emp (count) Ind_ID (sum) tot_emp_App (sum) tot_emp_Tex, by(year Zila NAME_2 Upazila upazila_id) //535
drop if Upazila == "" //0
*/

replace ID_ZUpazila = "9357" if ID_ZUpazila == "9325"  //Dhanbari to Madhupur, Tangail: dhabari exist in every year except in 2001  //বিগত ০৬ জুন,২০০৬ খ্রিঃ তারিখে অনুষ্ঠিত নিকারের ৯৩ তম বৈঠকের সিদ্ধান্ত অনুযায়ী টাঙ্গাইল জেলার মধুপুর উপজেলাকে বিভক্ত করে ০৭ টি ইউনিয়ন ও ০১ টি পৌরসভার সমন্বয়ে ১১ জুলাই, ২০০৬ খ্রিঃ তারিখে ধনবাড়ী নামে একটি নতুন প্রশাসনিক উপজেলা গঠনের সিদ্ধান্ত গৃহীত হয়। 125 obs

replace ID_ZUpazila = "3051" if ID_ZUpazila == "3041"   //Fulgazi to Parshuram, Feni: Fulgazi Upazila was split off from Parshuram Upazila in 2002. 106 obs

replace  ID_ZUpazila = "1936" if ID_ZUpazila == "1994"  //replace  Upazila = "Daudkandi" if Upazila == "Titas" & Zila == "Comilla"  //Titas to Daudkandi: ২০০৪ সালের ২২ ফ্রেব্রুয়ারী অনুাষ্ঠত নিকার বৈঠকে কুমিল্ল­া জলার দাউদকান্দি উপজেলার ৯টি ইউনিয়ন কর্তন করে ‘‘তিতাস উপজেলা’’ নামে ভিন্ন একটি প্রশাসনিক ইউনিট গঠনের সিদ্ধান্ত গৃহীত হয়। একই সালের ৩০ মার্চ গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের স্থানীয় সরকার, পল্ল­ী উন্নয়ন ও সমবায় মন্ত্রণালয়ের অধীনে স্থানীয় সরকার বিভাগের জারীকৃত এক প্রজ্ঞাপনে তিতাস উপজেলাকে পূর্ণাঙ্গ উপজেলা হিসাবে ঘোষণা করা হয় এবং ৪ এপ্রিল, ২০০৪ বাংলাদেশ গেজেটে অতিরিক্ত সংখ্যায় প্রকাশিত হয়।

replace ID_ZUpazila = "1972" if ID_ZUpazila == "1974"     //Mahoharganj to Laksam, Comilla: Manoharganj upazila was formed in 2005 with 11 unions in the southern region known as the watershed of the greater Laksam upazila.

replace ID_ZUpazila = "1972" if ID_ZUpazila == "1933" //Comilla Sadar Daskhin to laksam: Administration Comilla Sadar Dakshin upazila was formed comprising 6 unions of Comilla Adarsha Sadar Upazila and 4 unions on Laksham upazila on 4 April 2005, then part of Sadar Dakshin goes to newly formed Lalmai in 2017. \textcolor{blue}{convert sadar daskhin, lalmai to laksam in other years}, Lalmai adjusted in 2019 above

replace ID_ZUpazila = "1972" if ID_ZUpazila == "1967" //Comilla Adarsha Sadar to laksam: Administration Comilla Sadar Dakshin upazila was formed comprising 6 unions of Comilla Adarsha Sadar Upazila and 4 unions on Laksham upazila on 4 April 2005, then part of Sadar Dakshin goes to newly formed Lalmai in 2017. \textcolor{blue}{convert sadar daskhin, lalmai to laksam in other years}, Lalmai adjusted in 2019 above

replace ID_ZUpazila = "7587" if ID_ZUpazila == "7547" //Kabirhat to Noakhali Sadar: On 6 August 2006, the Kabirhat Upazila (sub-district) was formed from some unions of Noakhali Sadar Upazila.[5]

replace ID_ZUpazila = "7587" if ID_ZUpazila == "7585"   //Subarnachar to Noakhali sadar: সুবর্ণচর উপজেলা নোয়াখালী জেলার একটি নবসৃষ্টি উপজেলা। গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের স্থানীয় সরকার বিভাগের ০২ এপ্রিল ২০০৫ তারিখের প্রজ্ঞাপন জারীর মাধ্যমে এ উপজেলার গোড়াপত্তন ঘটে। নিকার এর ৯১তম বৈঠকে নোয়াখালী সদর উপজেলার দক্ষিণাঞ্চলের ৭টি ইউনিয়ন নিয়ে এ উপজেলার সৃষ্টির সিদ্ধান্ত গৃহীত হয়।

replace  ID_ZUpazila = "7507" if ID_ZUpazila == "7583" //replace  Upazila = "Begumganj" if Zila == "Noakhali" &  Upazila == "Sonaimuri"   //Sonaimuri to Begumgonj: সোনাইমুড়ি উপজেলা বাংলাদেশের নোয়াখালী জেলার অন্তর্গত একটি উপজেলা, এটি ২০০৫ সালে গঠিত হয়েছে। বেগমগঞ্জ উপজেলা ভেঙ্গে সোনাইমুড়ি উপজেলা গঠিত হয়েছে।

replace  ID_ZUpazila = "2216" if ID_ZUpazila == "2256"  // replace  Upazila = "Chakaria" if Upazila == "Pekua" & Zila == "Cox'S Bazar" //Pekua to Chokoria: পেকুয়া উপজেলা ২০০২ সালের ২৩ শে এপ্রিল প্রতিষ্ঠিত হয়। কক্সবাজার জেলার চকরিয়া উপজেলার ২৫ টি ইউনিয়ন হতে ০৭ ইউনিয়ন আলাদা করে নবগঠিত পেকুয়া উপজেলার সৃষ্ঠি হয়। 

replace  ID_ZUpazila = "5173" if ID_ZUpazila == "5133"  //replace  Upazila = "Ramgati" if Upazila == "Kamalnagar" & Zila == "Lakshmipur" //Kamalnagar to Ramgoit, Laksmipur: পরবর্তীতে নিকার ৯৩ তম বৈঠকের সিদ্ধান্তের আলোকে গেজেট বিজ্ঞপ্তি নং- উপ-২/সি- ১৫/২০০৫/২৯৫, তারিখ ০৬.০৬.২০০৬ খ্রি: মোতাবেক লক্ষ্মীপুর জেলার রামগতি উপজেলার ০৫টি ইউনিয়নকে নিয়ে কমলনগর নামে একটি নতুন প্রশাসনিক উপজেলা গঠিত হয়। পরবর্তীতে নভেম্বর ২৯, ২০০৭ বাংলাদেশ গেজেট মোতাবেক ০৪টি ইউনিয়ন দ্বিখন্ডিত হয়ে ০৮টি করা হয় এবং মোট ০৯টি ইউনিয়নে পরিনত হয় (অফিস সুত্র)

replace ID_ZUpazila = "2962" if ID_ZUpazila == "2990"    //  Saltha to Nagarkanda, Faridpur:  এরপর ১৯৮৪ সালে নগরকান্দা উপজেলায় রুপান্তরিত হয়। কালের আবর্তে এবং সময়ের প্রেক্ষিতে নগরকান্দা উপজেলার (০৮) টি ইউনিয়ন পরিষদের  সমন্বয়ে গত ২৪ সেপ্টেম্বর, ২০০৬ খ্রিঃ তারিখে উপ-২/সি-১২/২০০৫/৩৪ নং প্রজ্ঞাপন মূলে সালথা উপজেলা গঠিত হয়। 

replace  ID_ZUpazila = "7980" if ID_ZUpazila == "7990" //Zianagar/Indurkandi to pirojpur sadar, pirojpur. It was included in Pirojpur sadar upazila, later on 21 April 2002 began operation as a upazila with 3 unions.

replace ID_ZUpazila = "9089" if ID_ZUpazila == "9027" // Dakshin Sunamganj to Sunamganj Sadar:   গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের স্থানীয় সরকার, পল্লী উন্নয়ন ও সমবায় মন্ত্রণালয়, স্থানীয় সরকার বিভাগ, উপ-২ শাখা তাং- ১৭.০৭.২০০৬ খ্রিঃ/২ শ্রাবণ ১৪১৩ এর প্রজ্ঞাপনমতে ২৭জুলাই’ ০৬ তারিখে প্রকাশিত বাংলাদেশ গেজেট এ প্রকাশিত সুনামগঞ্জ সদর উপজেলার ৮টি ইউনিয়ন নিয়ে দক্ষিণ সুনামগঞ্জ উপজেলা ঘোষণা করা হয় ফলে ১৮.০৫.২০০৮ খ্রিঃ তারিখ হতে এ উপজেলাটি নবসৃষ্ট উপজেলা হিসেবে কার্যক্রম শুরু হয়।

replace  ID_ZUpazila = "9162" if ID_ZUpazila == "9131" //Dakshin Surma to Sylhet sadar, Sylhet: Dakshin Surma exists in 2009, 2011, 2019 but not in 2001 since was formed in 2005 //২৯ জানুয়ারি ২০০৫ তারিখে অনুষ্ঠিত নিকার-এর ৯১তম বৈঠকে সিলেট জেলার সদর উপজেলার ১৭টি ইউনিয়ন হতে ০৯টি ইউনিয়ন যথাক্রমে ১) মোল্লারগাঁও ২) বরইকান্দি ৩) তেতলী ৪) কুচাই ৫) সিলাম ৬) লালাবাজার ৭) জালালপুর ৮) মোগলাবাজার ৯) দাউদপুর ইউনিয়নসমূহকে কর্তন করে এগুলো সমন্বয়ে দক্ষিণ সুরমা নামে একটি নতুন প্রশাসনিক উপজেলা গঠন করার সিদ্ধান্তের প্রেক্ষিতে উপজেলা পরিষদ আইন, ১৯৯৮ এর ৩ (২) ধারায় প্রদত্ত ক্ষমতাবলে সিলেট জেলার সদর উপজেলার উক্ত ইউনিয়নসমূহের সমন্বয়ে দক্ষিণ সুরমা উপজেলা গঠন করা হয়। পরবর্তীতে ২০১১ সালের ৩০ জুন তারিখ মোল্লারগাঁও ও তেতলী ইউনিয়নের অংশবিশেষের সমন্বয়ে কামালবাজার ইউনিয়ন সৃষ্টি হয়। দক্ষিণ সুরমা উপজেলার আয়তন ১৯৫.৪০ বর্গ কিলোমিটার যার বর্তমান ইউনিয়ন সংখ্যা ১০টি। এই উপজেলার আইন শৃঙ্খলা পরিস্থিতি নিয়ন্ত্রনে রাখাসহ জনগণের শান্তি শৃঙ্খলা বজায়ের স্বার্থে সিলেট মেট্রোপলিটন পুলিশের আওতায় দক্ষিণ সুরমা থানা ও মোগলাবাজার থানা সৃষ্টি হয়েছে। সিলেট জেলা হতে মাত্র ০৯ কিলোমিটার দূরত্বে অবস্থান করার কারণে এই উপজেলার ০৪ নং কুচাই ইউনিয়নে বিভাগীয় কমিশনারের কার্যালয়, ডিআইজি সিলেট রেঞ্জ এর কার্যালয়, সিলেট শিক্ষা বোর্ড ভবন, কারিগরি মহিলা প্রশিক্ষণ কেন্দ্রসহ বিভাগীয় পর্যায়ের সরকারি সকল প্রতিষ্ঠানের দপ্তর এই উপজেলায় অবস্থিত হওয়ায় প্রশাসনিকভাবে এর গুরুত্ব অপরিসীম। নবসৃষ্ট এই উপজেলাটি মোগলাবাজার ইউনিয়নে অবস্থিত।

replace ID_ZUpazila = "1020" if ID_ZUpazila == "1085" // ২০০৩ সালের ২১ জানুয়ারি শাজাহানপুর উপজেলা গঠিত হয়।  Before it was with Bogra Sadar upazila (Talked with (মোহাম্মদ রুবায়েত খান, উপজেলা নির্বাহী অফিসারের কার্যালয় on March 21, 2021)

replace  ID_ZUpazila = "5865" if ID_ZUpazila == "5814" | ID_ZUpazila == "5835"  //Borolekha(605814) & Juri(605835) to Kulaura(605865) . On 26 August 2004, Juri upazila with 8 unions (4 from Kulaura and 4 from Barlekha) was established.

replace  ID_ZUpazila = "2616" if ID_ZUpazila == "2663" //Newmarket to Dhanmondi, Dhaka: Administration New Market Thana was formed on 27 June 2005 comprising parts of Dhanmondi thana (Online Banglapedia). Dhanmondi exists in all the years but Newmarket does not exist only in 2001. Dhanmondi exists in all the years but Newmarket does not exist only in 2001. 

replace  ID_ZUpazila = "2654" if ID_ZUpazila == "2665" //Paltan to Motijheel, Dhaka: Motijhil exists in all the years but Paltan does not exist only in 2001. Paltan Thana was formed on 27 June 2005 comprising part of Motijheel thana (Wikipedia). (code 2665 in BR BD census2011 to 2654 )

replace  ID_ZUpazila = "2695" if ID_ZUpazila == "2693" //Turag to Uttara, Dhaka: Uttara exists in all the years but Turag does not exist only in 2001. Administration Turag thana was formed on 27 June 2005 comprising part of Harirampur union of Uttara thana (Banglapedia).

replace  ID_ZUpazila = "2695" if ID_ZUpazila == "2610" //Dakkhinkhan to Uttara, Dhaka: Uttara exists in all the years but Dakkhinkhan does not exist only in 2001. 

replace  ID_ZUpazila = "2695" if ID_ZUpazila == "2696" //Uttarkhan to Uttara(in census uttara and biman bandar) , Dhaka: Uttara exists in all the years but Uttarkhan does not exist only in 2001. 

replace  ID_ZUpazila = "2695" if ID_ZUpazila == "2606" //biman bandar(2606) to Uttara(2695)

replace  ID_ZUpazila = "2604" if ID_ZUpazila == "2637" //Khilkhet to Badda, Dhaka: Khilkhet exists in all the years but Badda does not exist only in 2001. 

replace  ID_ZUpazila = "2666" if ID_ZUpazila == "2675" //Shahbag to Ramna, Dhaka: Administration Shahbagh Thana was formed on 7 August 2006 comprising parts of Ramna thana. Ramna exists in all the years but Shahbagh does not exist only in 2001. Ramna exists in all the years but Shahbagh does not exist only in 2001. 

replace  ID_ZUpazila = "2650" if ID_ZUpazila == "2602" //Adabor to Mohammadpur, Dhaka: Mohammadpur exists in all the years but Adabar does not exist only in 2001. Administration Adabar thana was formed on 27 June 2007 comprising part of Mohammadpur thana.  (Banglapedia). (code 2665 in BR BD census2011 to 2654 )

replace  ID_ZUpazila = "2648" if ID_ZUpazila == "2674" // Shah Ali(302674) to Mirpur(302648): Mirpur Model Thana was formed in 1962 (Banglapedia). Mirpur Thana has recently been divided into the three thanas of Shah Ali, Pallabi and Kafrul (Wikipedia). Administration Pallabi Thana was formed on 15 March 1995 (Banglapedia). Administration Kafrul thana was formed in 1998 consisting parts of Mirpur Model and Cantonment thanas (Banglapedia). Administration Shah Ali Thana was formed in 2005 (Banglapedia).

replace  ID_ZUpazila = "2612" if ID_ZUpazila == "2629" //Jatrabari to Demra, Dhaka: Administration Jatrabari Thana was formed in 2007 (Online Banglapedia).Demra exists in all the years but Jatrabari does not exist only in 2001. 

replace  ID_ZUpazila = "2612" if ID_ZUpazila == "2632" | ID_ZUpazila == "2676" //Kadamtali and Shympur to Demra, Dhaka: Administration Kadamtali Thana was formed on 23 September 2008 comprising parts of Shyampur and Demra thanas (Online Banglapedia). Administration Demra Thana was formed in 1973; later on the thana was reconstituted (Online Banglapedia). Shyampur exists in all the years but Kadamtali does not exist only in 2001.

replace  ID_ZUpazila = "2650" if ID_ZUpazila == "2690" |ID_ZUpazila == "2692" | ID_ZUpazila== "2630" | ID_ZUpazila == "2626" | ID_ZUpazila == "2680" //Tejgaon(302690) & Tejgaon Ind. Area(302692) & Kafrul(302630) & Gulshan(302626) & Sher-E-Bangla Nagar(302680) to  Mohammadpur(302650) . Administration Tejgaon Thana was formed in 1953. This thana was reconstituted when Tejgaon Industrial Area thana was formed on 7 August 2006. (Banglapedia). Administration Sher-E-Bangla Nagar Thana was formed on 4 August 2009 comprising parts of Tejgaon, Kafrul and Mohammadpur thanas. (Banglapedia). Administration Gulsan Thana was formed in 1972. Part of Ward no. 20 of this Thana was included in the Tejgaon Industrial Area Thana when it was formed in 2006 (Banglapedia)

drop if ID_ZUpazila == "1553" //Mirsharai
drop if ID_ZUpazila == "1539" // Karnafuli  // I do not know why Karnafuli does not exist in 2011, it's missing

//Turag, Uttara and Biman Bandar are already together

*to make same as 2019 (from above 2009 did not match: Panchlaish, Double Mooring, Khulshi, Ramgarh, Mahanchhari,Pachlaish, Lalbagh, Potenga) because some of these have been revised between 2009 and 2019 covering more than one upazila 
//replace  Upazila = "Kotwali" if (Upazila == "Chalk Bazar" | Upazila == "Panchlaish" | Upazila == "Double Mooring" | Upazila == "Sadarghat")  & NAME_2 == "Chittagong" 
replace ID_ZUpazila = "1541" if (ID_ZUpazila == "1557" | ID_ZUpazila == "1528" ) //

//replace  Upazila = "Pahartali" if (Upazila == "Akbarshah" | Upazila == "Khulshi") & NAME_2 == "Chittagong" // Akbarshah established in 2013
replace ID_ZUpazila = "1555" if (ID_ZUpazila == "1543")  

//replace  Upazila = "Kotwali" if (Upazila == "Chak Bazar" | Upazila == "Lalbagh") & NAME_2 == "Dhaka" // 
replace  ID_ZUpazila = "2640" if (ID_ZUpazila == "2642")   

//replace Upazila = "Matiranga" if (Upazila =="Guimara" | Upazila == "Ramgarh" | Upazila == "Mahalchhari") & Zila == "46" // 
replace ID_ZUpazila = "4670" if (ID_ZUpazila =="4680" | ID_ZUpazila =="4665")   // 

//replace  Upazila = "Chittagong Port" if (Upazila == "Epz" | Upazila == "Patenga") & NAME_2 == "Chittagong" //
replace  ID_ZUpazila = "1520" if (ID_ZUpazila == "1565") // 
save "$Data\DataCreated\BRBD_adjAlongCensus", replace



use "$Data\DataCreated\BRBD_adjAlongCensus", clear
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
gen tot_emp_mfg = cond(inlist(AppTexOther,"MfgExclAppTex"), tot_emp,0)
gen tot_emp_agri = cond(inlist(AppTexOther,"Agri"), tot_emp,0)
gen tot_emp_serNother = cond(inlist(AppTexOther,"ServiceOther"), tot_emp,0)
gen tot_emp_Other = cond(inlist(AppTexOther,"MfgExclAppTex","agri","ServiceOther"),tot_emp,0)
gen emp_indser = cond(inlist(AppTexOther,"Apparels","Textiles", "MfgExclAppTex", "ServiceOther"),tot_emp,0)

tabstat tot_emp , stat(n min max mean sum) by(AppTexOther)
tabstat tot_emp tot_emp_App tot_emp_Tex tot_emp_mfg tot_emp_agri tot_emp_serNother tot_emp_Other, stat(n min max mean sum) format(%12.0fc)
sum tot_emp tot_emp_App tot_emp_Tex tot_emp_mfg tot_emp_agri tot_emp_serNother tot_emp_Other emp_indser

save "$Data\DataCreated\BRBD_varCreated", replace


use "$Data\DataCreated\BRBD_varCreated", clear

/*Same command to create variable as the following
ssc install dummieslab
tab AppTexOther, gen(AppTexOther_) */
levelsof AppTexOther , local(list)
	foreach y of local list{
	gen count_`y' = (AppTexOther== "`y'" )
	}
	
collapse (sum) tot_emp Male Female tot_emp_App tot_emp_Tex tot_emp_mfg tot_emp_agri tot_emp_serNother tot_emp_Other emp_indser count_Agri count_Apparels count_MfgExclAppTex count_ServiceOther count_Textiles (count) Divisions, by(year ID_ZUpazila)  


gen count_indser = count_Apparels + count_Textiles + count_MfgExclAppTex + count_ServiceOther

tabstat tot_emp, stat(sum) format(%12.0fc)
rename Divisions count_est

gen Apparel_share= (tot_emp_App/tot_emp)*100
gen Textile_share= (tot_emp_Tex/tot_emp)*100
gen AppTex_share= ((tot_emp_App+tot_emp_Tex)/tot_emp)*100
total(count_est) //226963

tabstat count_Agri count_Apparels count_MfgExclAppTex count_ServiceOther count_Textiles count_est, stat(N sum)


reshape wide count_est tot_emp Male Female  tot_emp_App tot_emp_Tex tot_emp_mfg tot_emp_agri tot_emp_serNother tot_emp_Other Apparel_share Textile_share AppTex_share emp_indser count_Agri count_Apparels count_MfgExclAppTex count_ServiceOther count_Textiles count_indser, i(ID_ZUpazila ) j(year) 

save "$Data\DataCreated\BusCen_Adjusted", replace







*					For		Estimation
********************************************************************************


*Variable creating
******************
*	Dummy variable creation
use "$Data\DataCreated\BusCen_Adjusted", clear
merge 1:1 ID_ZUpazila using "$Data\DataCreated\PopCen_Adjusted" // same ID do not match after adjustment for census, so I incorporate at 2001 level
drop _merge
tab ID_ZUpazila geo2_bd if  Apparel_share2009 > 40
gen D = (Apparel_share2009 > 40 )
tab  upazilabd if D==1
fre D // 20 & 472
gen D2001 =D
gen D2011 =D
gen D2019 =D
rename D D2009
sum Apparel_share2009 if D2009==1
sum Apparel_share2009 if D2009==0

tab AppTex_share2009
histogram AppTex_share2009
sum AppTex_share2009,det
tabstat AppTex_share2009, stat(N sum p25 mean p75 min max)

gen D_ApTx= (AppTex_share2009>48) 
tab upazilabd if D_ApTx==1
fre D_ApTx // 48 & 444
gen D_ApTx2001 =D_ApTx
gen D_ApTx2011 =D_ApTx
gen D_ApTx2019 =D_ApTx
rename D_ApTx D_ApTx2009

save "$Data\DataCreated\PopBusCen_upazila" , replace





* Create EPZ and neighboring EPZ upazila variable 
use "$Data\DataCreated\PopBusCen_upazila" , clear

*	EPZ upazila
gen EPZ = (upazilabd== 306758) // Adamzi EPZ in Siddirgonj is in narayanganj sadar
*Bandar(306706) & rupganj(306768) neighboring upazila, think about this to consider as EPZ upazila. part of Dhaka is also neiboring Siddirgonj 
replace EPZ = 1 if upazilabd== 557364 // Uttara EPZ in Sangloshi is in Nilphamari sadar upazila
replace EPZ = 1 if upazilabd== 507639 // Ishwardi EPZ in Paksey is in Ishwardi upazila
replace EPZ = 1 if upazilabd== 302672 // Dhaka EPZ is in Savar upazila
replace EPZ = 1 if upazilabd== 201535 // Chittagong EPZ is in Halishahar upazila
replace EPZ = 1 if upazilabd== 201972 // Cumilla EPZ in old airport in Comilla Sadar upazila, which I merged in Laksam upazila in the upazila adjustment
replace EPZ = 1 if upazilabd== 400158 // Mongla EPZ is in Mongla port area
replace EPZ = 1 if upazilabd== 201504 // Karnaphuli EPZ is in Anwara upazila
replace EPZ = 0 if EPZ == .
tab EPZ

*	EPZ and neighboring upazila
tab upazilabd  //if geo2_bd == 50030001 | geo2_bd == 50020002 | geo2_bd == 50020003| geo2_bd == 50020005| geo2_bd == 50030009 | geo2_bd ==50030011 | geo2_bd ==5003001   

gen EPZneibor = 1 if upazilabd==306758 | upazilabd==302612 | upazilabd==302638 | upazilabd==306768 // Adamzi EPZ in Siddirgonj is in narayanganj sadar and neighboring demra, keranigonj, rupganj

replace EPZneibor = 1 if upazilabd== 557364 | upazilabd== 557315 /*| upazilabd==  557336 jaldhaka*/ | upazilabd== 557345 | upazilabd== 557385 | upazilabd== 552760 // Uttara EPZ in Siddirgonj is in nilphamari sadar and neighboring domar, jaldhaka, kishorgonj saidpur, khansama in Dinajpur

replace EPZneibor = 1 if upazilabd== 507639 | upazilabd== 507605 | upazilabd== 507655  | upazilabd== 405015 | upazilabd== 506944   // Ishwardi EPZ in Paksey is in Ishwardi upazila and neighboring atgharia, pabna, bheramara in Kustia, lalpur in natore, 

replace EPZneibor = 1 if upazilabd== 302672 | upazilabd== 303332 | upazilabd == 302614 | upazilabd == 305682   // Dhaka EPZ is in Savar upazila and neighboring kaliakoir, dhamrai, singair, 

replace EPZneibor = 1 if upazilabd== 201535 | upazilabd==201504 | upazilabd== 201506 | upazilabd== 201519 | upazilabd== 201520 | upazilabd== 201541 | upazilabd== 201555 | upazilabd==201561 | upazilabd==201578| upazilabd==201586 // Chittagong EPZ is in Halishahar upazila and neighboring Anwara, Bayejid bostami, Chandgaon, chittagong port, Kotwali, Pahartali, Patiya, Swandip, Shitakunda

replace EPZneibor = 1 if upazilabd== 201504 /*| upazilabd== 201508*/ | upazilabd== 201510 | upazilabd== 201518 /*| upazilabd== 201582*/  // Karnaphuli EPZ is in Anwara upazila and neighboring Bashkhali, Bakalia, Chandnaish, Satkania

replace EPZneibor = 1 if upazilabd== 201972 | upazilabd == 201909 | upazilabd == 201918 | upazilabd == 201931  // Cumilla EPZ in old airport in Comilla Sadar upazila which I merged in Laksam upazila in the upazila adjustment, and neighboring Barura, Burichang, Chauddagram, 

replace EPZneibor = 1 if upazilabd== 400158 | upazilabd == 400160 | upazilabd == 400173 | upazilabd == 400177 | upazilabd== 404717 // Mongla EPZ is in Mongla port area and neighboring Morolgonj, Rampal, Shoronkhula, Dacope in Khulna

replace EPZneibor = 0 if EPZneibor == .

tab EPZneibor
//* Note: to consider: if EPZ is perfectly correlated with apparel dominant, then I could estimate EPZ outcome (employment and export) pre and post period of safety enforecement. The data is continuously available in the website https://www.bepza.gov.bd/. Not really, not perfectly correlated
save "$Data\DataCreated\PopBusCen_Upazila_EPZ" , replace








*		Population census regression
***********************************************
use "$Data\DataCreated\PopBusCen_Upazila_EPZ" , clear

keep *2001 *2011 Apparel_share2009 Textile_share2009 AppTex_share2009 geo2_bd upazilabd ID_ZUpazila ID_ZUpazila EPZ EPZneibor

reshape long  emp_total  emp_indser emp_rate emp_indser_rate pop_total  pop_urban urban_rate D D_ApTx, i(geo2_bd upazilabd ID_ZUpazila ID_ZUpazila ) j(year) //544     //500 after adjustment with 2001

gen tot_emp_wt =  emp_total * 20 if year == 2011
replace tot_emp_wt =  emp_total * 10 if year ==2001

gen emp_indser_wt = emp_indser *20 if year== 2011
replace emp_indser_wt = emp_indser *10 if year== 2001

gen lnEmp = log(tot_emp_wt)

gen lnEmp_indser = log(emp_indser_wt)

gen y2011= (year == 2011)
lab def y2011 0 "Population census 2001" 1 "Population census 2011" 
lab val y2011 y2011
fre y2011

gen Dy2011int = D * y2011 
tab Dy2011int

gen D_ApTx_y2011int = D_ApTx * y2011 
tab D_ApTx_y2011int
tab D_ApTx_y2011int year

gen EPZy2011int = EPZ * y2011 
tab EPZy2011int

gen EPZneibor2011int = EPZneibor * y2011 
tab EPZneibor2011int

corr D EPZ
corr D EPZneibor

xtset year 
tab D year
save "$Data\DataCreated\PopCen_regression", replace


use "$Data\DataCreated\PopBusCen_Upazila_EPZ", clear

rename urban_rate2001 urban_rate2009
rename urban_rate2011 urban_rate2019

drop *2001 *2011 

//reshape wide tot_emp Male Female D urban_rate /*tot_pop emp_rate*/, i(/*geo2_bd*/ upazilabd ID_ZUpazila ) j(year) //544     //500 after adjustment with 2001
reshape long tot_emp Male Female emp_indser tot_emp_App tot_emp_Tex tot_emp_mfg tot_emp_agri tot_emp_serNother tot_emp_Other count_est count_Apparels count_Textiles count_MfgExclAppTex count_Agri count_ServiceOther count_indser D D_ApTx urban_rate  , i( upazilabd ID_ZUpazila ) j(year)

tabstat tot_emp emp_indser tot_emp_App tot_emp_Tex tot_emp_mfg tot_emp_agri tot_emp_serNother tot_emp_Other D D_ApTx, stat(n min max mean sum) format(%14.0fc)

gen emp_AppTex = tot_emp_App + tot_emp_Tex, after(tot_emp_App)
gen emp_manufac= emp_AppTex + tot_emp_mfg , after(emp_AppTex)

gen count_AppTex = count_Apparels + count_Textiles, after(count_Apparels)
gen count_manufac= count_AppTex + count_MfgExclAppTex , after(emp_AppTex)

sum tot_emp_App,det
sum emp_AppTex,det
sum emp_manufac,det
sum emp_indser, det
foreach v of varlist tot_emp emp_indser tot_emp_App emp_AppTex emp_manufac count_Apparels count_AppTex count_manufac count_est count_indser{
	replace `v' = `v'+1   // to convert 0 to log
	gen ln_`v' = log(`v')
//	drop `v'
}

gen y2019= (year == 2019)
lab def y2019 0 "BR2009" 1 "BD2019"
lab val y2019 y2019
fre y2019

gen Dy2019int = D * y2019 

gen D_ApTx_y2019int = D_ApTx * y2019 

tab Apparel_share2009
sum Apparel_share2009 if D==0 & y2019==0
sum Apparel_share2009 if D==1 & y2019==0

histogram tot_emp_App
sum tot_emp_App

gen EPZy2019int = EPZ * y2019 
tab EPZy2019int

corr D EPZ

tab EPZneibor D
tab EPZneibor year

gen EPZneiborY2019 = EPZneibor * y2019 
tab EPZneiborY2019

corr D EPZneibor

global predictor200919 D y2019 Dy2019int

save "$Data\DataCreated\BusCen_regression", replace



* Drop recent established firms
**********************************************
use "$Data\DataCreated\BRBD_varCreated", clear
//collapse (sum) tot_emp emp_indser tot_emp_mfg  (count) Divisions, by(year ID_ZUpazila)  //984
destring Inception, replace ignore("")
list Inception if missing(real(Inception))
//drop if Inception == ""
//collapse (sum) tot_emp emp_indser tot_emp_mfg  (count) Divisions, by(year ID_ZUpazila)  //984
list Inception if missing(real(Inception))
//drop if Inception == "UFAZ" | Inception == "gold" | Inception == "biba" | Inception == "dcf." | Inception == "coub" 
replace Inception = "" if Inception == "UFAZ" | Inception == "gold" | Inception == "biba" | Inception == "dcf." | Inception == "coub" 
replace Inception = "1991" if Inception == "১৯৯১"
replace Inception = "1983" if Inception == "১৯৮৩"
replace Inception = "2010" if Inception == "২০১০"
replace Inception = "1996" if Inception == "১৯৯৬"
replace Inception = "2000" if Inception == "২০০০"
replace Inception = "2012" if Inception == "২০১2"
tab Inception if !regexm(Inception, "[0-9]+")
destring Inception, replace 
/*
tab Inception
drop if Inception > 2013 & year ==2019
drop if Inception > 2004 & year ==2009
tab Inception
drop if  Inception <1800
*/
tab year
tab year  if Inception == .
tab year if Inception == ., sum(tot_emp_mfg)  
tab tot_emp_mfg year if Inception == . 

foreach v of varlist tot_emp emp_indser tot_emp_App tot_emp_Tex tot_emp_mfg Divisions {
	sum `v' if year == 2019 & Inception > 2013  | Inception == .
	replace `v' = 0 if year == 2019 & Inception > 2013  | Inception == .
	sum `v' if year == 2009 & Inception > 2003  | Inception == .
	replace `v' = 0 if year == 2009 & Inception > 2003  | Inception == .
}

replace AppTexOther = "" if year == 2019 & Inception > 2013  | Inception == .
replace AppTexOther = "" if year == 2009 & Inception > 2003  | Inception == .
levelsof AppTexOther , local(list)
	foreach y of local list{
	gen count_`y' = (AppTexOther== "`y'" )
	}
gen emp_AppTex = tot_emp_App + tot_emp_Tex, after(tot_emp_App)
gen emp_manufac= emp_AppTex + tot_emp_mfg , after(emp_AppTex)
gen count_AppTex = count_Apparels + count_Textiles, after(count_Apparels)
gen count_manufac= count_AppTex + count_MfgExclAppTex , after(count_MfgExclAppTex)

collapse (sum) tot_emp emp_indser emp_manufac emp_AppTex tot_emp_App count_manufac (count) Divisions, by(year ID_ZUpazila)  
rename Divisions count_est
total(count_est) // 226963
tabstat tot_emp emp_indser emp_manufac emp_AppTex tot_emp_App count_manufac count_est, stat(N sum)
reshape wide  tot_emp emp_indser emp_manufac emp_AppTex tot_emp_App count_manufac count_est, i(ID_ZUpazila ) j(year) 
merge 1:1 ID_ZUpazila using "$Data\DataCreated\PopBusCen_upazila"
drop _merge
keep *2009 *2019 ID_ZUpazila 
reshape long tot_emp emp_indser emp_manufac emp_AppTex tot_emp_App count_manufac count_est Apparel_share D, i(ID_ZUpazila ) j(year) 
keep tot_emp emp_indser emp_manufac emp_AppTex tot_emp_App count_manufac count_est Apparel_share D ID_ZUpazila year
tab D
foreach v of varlist tot_emp emp_indser emp_manufac emp_AppTex tot_emp_App count_manufac count_est{
	replace `v' = `v'+1   // to convert 0 to log
	gen ln_`v' = log(`v')
//	drop `v'
}

gen y2019= (year == 2019)
lab def y2019 0 "BR2009" 1 "BD2019"
lab val y2019 y2019
fre y2019

gen Dy2019int = D * y2019

save "$Data\DataCreated\BusCen_exRecentEst", replace











