clear all
set more off

global SS "***\SafetyScience_RMGsafety&performance"

global Figures "***\Paper_RMGsafety\Figures"

*mkdir "$SS\Tables" // uncomment if you have not created this folder

global Tables "$SS\Tables"

global Data "***\Data"

cd "$SS"



* upazila adjustment in population census
**************************************************************
use "$Data\ipumsi_00002.dta", clear   

*Ind code from the IPUMS code page after asking in the group post of IPUMSI
tab ind year
lab define IND2011 1 "Agriculture" 2	"Industry" 3 "Services" 8 "Unknown" 9 "NIU (not in universe)"
lab define IND2001 1 "Not working" 2 "Looking for work" 3 "Household work" 4 "Agriculture" 5 "Industry" 6 "Water/electricity/gas" 7 "Construction" 8 "Transport/communication" 9 "Hotel/restaurant" 10 "Business" 11 "Service" 12 "Others" 99 "NIU (not in universe)"
lab define IND1991 1 "Not working" 2 "Looking for work" 3 "Household work" 4 "Agriculture" 5 "Industry" 6 "Water/electricity/gas" 7 "Construction" 8 "Transport/communication" 9 "Business" 10 "Service" 11 "Others" 99 "NIU (not in universe)"
gen Industry2011=ind if year==2011, after(ind)
gen Industry2001=ind if year==2001, after(Industry2011) 
gen Industry1991=ind if year==1991, after(Industry2001)
lab val Industry2011 IND2011
lab val Industry2001 IND2001
lab val Industry1991 IND1991


drop if year==1991
drop bd1991* *bd1991
tab ind year
tab livehood year //2011 not available
tab classwk year // 2011 not available
tab classwkd year //2011 not available
tab empstat year
tab empstatd year
tab labforce
lab val upazilabd
lab val upazilabd UPAZILABD
labelbook GEO2_BD2001 GEO2_BD2011
//collapse (count) empstat , by (year upazilabd)  // 544 total with many missing in 2001 and 1 in 2011
//reshape wide empstat, i(upazilabd) j(year) //karnafuli is not available in 2011 even though the upazila is still prevailing
keep year serial persons hhwt subsamp strata urban geolev1 geolev2 geo1_bd geo2_bd upazilabd dhs_ipumsi_bd pernum perwt age age2 empstat empstatd labforce ind Industry2001 Industry2011  
save "$Data\DataCreated\PopCen_Upazila", replace



use "$Data\DataCreated\PopCen_Upazila", clear
by year upazilabd, sort: gen nupazila= _n==1
count if nupazila & year == 2001 //507
count if nupazila & year == 2011 //543
drop nupazila

by year upazilabd, sort: gen nupazila= _n==1
count if nupazila & year == 2001 //507
count if nupazila & year == 2011 //543
drop nupazila

use "$Data\DataCreated\PopCen_Upazila", clear
collapse (count) empstat , by (year upazilabd)  
//asdoc tab year //507 and 543
tab year //507 and 543
tab year if empstat != . //507 and 543
reshape wide empstat, i(upazilabd) j(year) //544 //because of Karnafuli
drop if empstat2001 == . | empstat2011 == .  //38 obs



******************* Make upazila comparable between 2001 and 2011
use "$Data\DataCreated\PopCen_Upazila", clear
replace upazilabd = 309357 if upazilabd == 309325  //Dhanbari to Madhupur, Tangail: dhabari exist in every year except in 2001  //বিগত ০৬ জুন,২০০৬ খ্রিঃ তারিখে অনুষ্ঠিত নিকারের ৯৩ তম বৈঠকের সিদ্ধান্ত অনুযায়ী টাঙ্গাইল জেলার মধুপুর উপজেলাকে বিভক্ত করে ০৭ টি ইউনিয়ন ও ০১ টি পৌরসভার সমন্বয়ে ১১ জুলাই, ২০০৬ খ্রিঃ তারিখে ধনবাড়ী নামে একটি নতুন প্রশাসনিক উপজেলা গঠনের সিদ্ধান্ত গৃহীত হয়। (upazila website, accessed on 16 September 2021)

replace upazilabd = 203051 if upazilabd == 203041   //Fulgazi to Parshuram, Feni: On 2 June 2002, Fulgazi thana was upgraded to a sub-district by gaining 6 union councils from Parshuram Upazila. (Wikipedia, accessed on 16 September 2021) 

replace  upazilabd = 201936 if upazilabd == 201994  //replace  Upazila = "Daudkandi" if Upazila == "Titas" & Zila == "Comilla"  //Titas to Daudkandi: ২০০৪ সালের ২২ ফ্রেব্রুয়ারী অনুাষ্ঠত নিকার বৈঠকে কুমিল্ল­া জলার দাউদকান্দি উপজেলার ৯টি ইউনিয়ন কর্তন করে ‘‘তিতাস উপজেলা’’ নামে ভিন্ন একটি প্রশাসনিক ইউনিট গঠনের সিদ্ধান্ত গৃহীত হয়। একই সালের ৩০ মার্চ গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের স্থানীয় সরকার, পল্ল­ী উন্নয়ন ও সমবায় মন্ত্রণালয়ের অধীনে স্থানীয় সরকার বিভাগের জারীকৃত এক প্রজ্ঞাপনে তিতাস উপজেলাকে পূর্ণাঙ্গ উপজেলা হিসাবে ঘোষণা করা হয় এবং ৪ এপ্রিল, ২০০৪ বাংলাদেশ গেজেটে অতিরিক্ত সংখ্যায় প্রকাশিত হয়। (Upazila website, accessed on 16 September 2021)

replace upazilabd = 201972 if upazilabd == 201974     // Mahoharganj to Laksam, Comilla: Manoharganj upazila was formed in 2005 with 11 unions in the southern region known as the watershed of the greater Laksam upazila. (Wikipedia, accessed on 16 September 2021)

replace upazilabd = 201972 if upazilabd == 201933 // Comilla Sadar Daskhin to Laksam: Administration Comilla Sadar Dakshin upazila was formed comprising 6 unions of Comilla Adarsha Sadar Upazila and 4 unions on Laksham upazila on 4 April 2005 (Banglapedia online, accessed on 16 September 2021). greater laksam (201972). then part of Sadar Dakshin goes to newly formed Lalmai in 2017

replace upazilabd = 201972 if upazilabd == 201967 // Comilla Adarsha Sadar (201967) to Laksam (201972):  Administration Comilla Sadar Dakshin upazila was formed comprising 6 unions of Comilla Adarsha Sadar Upazila and 4 unions on Laksham upazila on 4 April 2005 (Banglapedia online, accessed on 16 September 2021)

replace upazilabd = 207587 if upazilabd == 207547 //Kabirhat to Noakhali Sadar: On 6 August 2006, the Kabirhat Upazila (sub-district) was formed from some unions of Noakhali Sadar Upazila.[5] (Wikipedia, accessed on 16 September 2021)

replace upazilabd = 207587 if upazilabd == 207585   //Subarnachar to Noakhali sadar: সুবর্ণচর উপজেলা নোয়াখালী জেলার একটি নবসৃষ্টি উপজেলা। গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের স্থানীয় সরকার বিভাগের ০২ এপ্রিল ২০০৫ তারিখের প্রজ্ঞাপন জারীর মাধ্যমে এ উপজেলার গোড়াপত্তন ঘটে। নিকার এর ৯১তম বৈঠকে নোয়াখালী সদর উপজেলার দক্ষিণাঞ্চলের ৭টি ইউনিয়ন নিয়ে এ উপজেলার সৃষ্টির সিদ্ধান্ত গৃহীত হয়। (Subarnachar upazila website, accessed on 16 September 2021)

replace  upazilabd = 207507 if upazilabd == 207583 //replace  Upazila = "Begumganj" if Zila == "Noakhali" &  Upazila == "Sonaimuri"   //Sonaimuri to Begumgonj: সোনাইমুড়ি উপজেলা বাংলাদেশের নোয়াখালী জেলার অন্তর্গত একটি উপজেলা, এটি ২০০৫ সালে গঠিত হয়েছে। বেগমগঞ্জ উপজেলা ভেঙ্গে সোনাইমুড়ি উপজেলা গঠিত হয়েছে। (Upazila website, accessed on 16 September 2021)

replace  upazilabd = 202216 if upazilabd == 202256  // replace  Upazila = "Chakaria" if Upazila == "Pekua" & Zila == "Cox'S Bazar" //Pekua to Chokoria: পেকুয়া উপজেলা ২০০২ সালের ২৩ শে এপ্রিল প্রতিষ্ঠিত হয়। কক্সবাজার জেলার চকরিয়া উপজেলার ২৫ টি ইউনিয়ন হতে ০৭ ইউনিয়ন আলাদা করে নবগঠিত পেকুয়া উপজেলার সৃষ্ঠি হয়। (Upazila website, accessed on 16 September 2021) 

replace  upazilabd = 205173 if upazilabd == 205133  //replace  Upazila = "Ramgati" if Upazila == "Kamalnagar" & Zila == "Lakshmipur" //Kamalnagar to Ramgoit, Laksmipur: পরবর্তীতে নিকার ৯৩ তম বৈঠকের সিদ্ধান্তের আলোকে গেজেট বিজ্ঞপ্তি নং- উপ-২/সি- ১৫/২০০৫/২৯৫, তারিখ ০৬.০৬.২০০৬ খ্রি: মোতাবেক লক্ষ্মীপুর জেলার রামগতি উপজেলার ০৫টি ইউনিয়নকে নিয়ে কমলনগর নামে একটি নতুন প্রশাসনিক উপজেলা গঠিত হয়। পরবর্তীতে নভেম্বর ২৯, ২০০৭ বাংলাদেশ গেজেট মোতাবেক ০৪টি ইউনিয়ন দ্বিখন্ডিত হয়ে ০৮টি করা হয় এবং মোট ০৯টি ইউনিয়নে পরিনত হয় (অফিস সুত্র) (Upazila website, accessed on 16 September 2021)

replace upazilabd = 302962 if upazilabd == 302990    //  Saltha to Nagarkanda, Faridpur:  এরপর ১৯৮৪ সালে নগরকান্দা উপজেলায় রুপান্তরিত হয়। কালের আবর্তে এবং সময়ের প্রেক্ষিতে নগরকান্দা উপজেলার (০৮) টি ইউনিয়ন পরিষদের  সমন্বয়ে গত ২৪ সেপ্টেম্বর, ২০০৬ খ্রিঃ তারিখে উপ-২/সি-১২/২০০৫/৩৪ নং প্রজ্ঞাপন মূলে সালথা উপজেলা গঠিত হয়। (Saltha upazila website, accessed on 16 September 2021)

replace  upazilabd = 107980 if upazilabd == 107990 //Zianagar/Indurkandi to pirojpur sadar, pirojpur. পিরোজপুর জেলার সদর উপজেলার সাথে এটি একিভূত ছিল। পরবর্তীতে ২০০২ সালের ২১ এপ্রিল এটি উপজেলা ঘোষনার পর ০৩টি ইউনিয়ন নিয়ে ইন্দুরকানী উপজেলার কার্যক্রম চালু হয়। (Upazila website, accessed on 16 September 2021)

replace upazilabd = 609089 if upazilabd == 609027 // Dakshin Sunamganj to Sunamganj Sadar:   গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের স্থানীয় সরকার, পল্লী উন্নয়ন ও সমবায় মন্ত্রণালয়, স্থানীয় সরকার বিভাগ, উপ-২ শাখা তাং- ১৭.০৭.২০০৬ খ্রিঃ/২ শ্রাবণ ১৪১৩ এর প্রজ্ঞাপনমতে ২৭জুলাই’ ০৬ তারিখে প্রকাশিত বাংলাদেশ গেজেট এ প্রকাশিত সুনামগঞ্জ সদর উপজেলার ৮টি ইউনিয়ন নিয়ে দক্ষিণ সুনামগঞ্জ উপজেলা ঘোষণা করা হয় ফলে ১৮.০৫.২০০৮ খ্রিঃ তারিখ হতে এ উপজেলাটি নবসৃষ্ট উপজেলা হিসেবে কার্যক্রম শুরু হয়। (Upazila website, accessed on 16 September 2021)

replace  upazilabd = 609162 if upazilabd == 609131 //Dakshin Surma to Sylhet sadar, Sylhet: Dakshin Surma exists in 2009, 2011, 2019 but not in 2001 since was formed in 2005 //২৯ জানুয়ারি ২০০৫ তারিখে অনুষ্ঠিত নিকার-এর ৯১তম বৈঠকে সিলেট জেলার সদর উপজেলার ১৭টি ইউনিয়ন হতে ০৯টি ইউনিয়ন যথাক্রমে ১) মোল্লারগাঁও ২) বরইকান্দি ৩) তেতলী ৪) কুচাই ৫) সিলাম ৬) লালাবাজার ৭) জালালপুর ৮) মোগলাবাজার ৯) দাউদপুর ইউনিয়নসমূহকে কর্তন করে এগুলো সমন্বয়ে দক্ষিণ সুরমা নামে একটি নতুন প্রশাসনিক উপজেলা গঠন করার সিদ্ধান্তের প্রেক্ষিতে উপজেলা পরিষদ আইন, ১৯৯৮ এর ৩ (২) ধারায় প্রদত্ত ক্ষমতাবলে সিলেট জেলার সদর উপজেলার উক্ত ইউনিয়নসমূহের সমন্বয়ে দক্ষিণ সুরমা উপজেলা গঠন করা হয়। পরবর্তীতে ২০১১ সালের ৩০ জুন তারিখ মোল্লারগাঁও ও তেতলী ইউনিয়নের অংশবিশেষের সমন্বয়ে কামালবাজার ইউনিয়ন সৃষ্টি হয়। দক্ষিণ সুরমা উপজেলার আয়তন ১৯৫.৪০ বর্গ কিলোমিটার যার বর্তমান ইউনিয়ন সংখ্যা ১০টি। এই উপজেলার আইন শৃঙ্খলা পরিস্থিতি নিয়ন্ত্রনে রাখাসহ জনগণের শান্তি শৃঙ্খলা বজায়ের স্বার্থে সিলেট মেট্রোপলিটন পুলিশের আওতায় দক্ষিণ সুরমা থানা ও মোগলাবাজার থানা সৃষ্টি হয়েছে। সিলেট জেলা হতে মাত্র ০৯ কিলোমিটার দূরত্বে অবস্থান করার কারণে এই উপজেলার ০৪ নং কুচাই ইউনিয়নে বিভাগীয় কমিশনারের কার্যালয়, ডিআইজি সিলেট রেঞ্জ এর কার্যালয়, সিলেট শিক্ষা বোর্ড ভবন, কারিগরি মহিলা প্রশিক্ষণ কেন্দ্রসহ বিভাগীয় পর্যায়ের সরকারি সকল প্রতিষ্ঠানের দপ্তর এই উপজেলায় অবস্থিত হওয়ায় প্রশাসনিকভাবে এর গুরুত্ব অপরিসীম। নবসৃষ্ট এই উপজেলাটি মোগলাবাজার ইউনিয়নে অবস্থিত। (Upazila website, accessed on 16 September 2021)

replace upazilabd = 501020 if upazilabd == 501085 // ২০০৩ সালের ২১ জানুয়ারি শাজাহানপুর উপজেলা গঠিত হয়।  Before it was with Bogra Sadar upazila (Talked with (মোহাম্মদ রুবায়েত খান, উপজেলা নির্বাহী অফিসারের কার্যালয় on March 21, 2021)

replace  upazilabd = 201213 if upazilabd == 201207 // Bijoynagar to Brahmanbaria sadar: Bijoynagar is new upazila 2010, বিগত ৩ আগষ্ট ২০১০ খ্রিঃ তারিখে ৪৮২তম উপজেলা হিসেবে এর প্রশাসনিক কার্যক্রম শুরম্ন হয়েছে। ইতোপূর্বে উপজেলাটি ব্রা‏হ্ম‏ণবাড়িয়া সদর উপজেলার অমত্মর্ভূক্ত হলেও তিতাস নদী দ্বারা বিচ্ছিন্ন বলে এখানে ভিন্নধর্মী একটি আবহ ও আমেজ রয়েছে। (bijoynagar upazila website). 

replace upazilabd = 308273 if upazilabd == 308247  //Kalukhali to Pangsha: রাজবাড়ী জেলার বৃহৎপাংশা উপজেলার ৭টি ইউনিয়ন নিয়ে কালুখালী উপজেলা গঠিত। ইউনিয়নগুলো হচ্ছে :রতনদিয়া ইউপি,কালিকাপুর ইউপি, বোয়ালিয়া ইউপি, মাঝবাড়ী ইউপি, মদাপুর ইউপি, মৃগী ইউপি ও সাওরাইল ইউপি। ২০১০ সালে জুন মাসে কালুখালী উপজেলার প্রশাসনিক কার্যক্রম শুরু হয়। (upazila website)

replace  upazilabd = 302616 if upazilabd == 302633  //replace  Upazila = "Dhanmondi" if Upazila == "Kalabagan" & Zila == "Dhaka" // Kalabagan to Dhanmondi, dhaka: Administration Kalabagan Thana was formed in 2008 with ten mahallas of ward number 50 and 51 (part) of Dhanmondi thana (Online Banglapedia). No Kalabagan in upazila level in 2009 but found Kalabagan addresses in Dhanmondi in 2009 dataset. In census kalabagan is only in 2011, Dhanmondi in both year. 

replace  upazilabd = 302616 if upazilabd == 302663 //Newmarket to Dhanmondi, Dhaka: Administration New Market Thana was formed on 27 June 2005 comprising parts of Dhanmondi thana (Online Banglapedia). Dhanmondi exists in all the years but Newmarket does not exist only in 2001.

replace  upazilabd = 302654 if upazilabd == 302665 //Paltan to Motijheel, Dhaka: Motijhil exists in all the years but Paltan does not exist only in 2001. Paltan Thana was formed on 27 June 2005 comprising part of Motijheel thana (Wikipedia). (code 2665 in BR BD census2011 to 2654 )

replace  upazilabd = 302695 if upazilabd == 302693 //Turag to Uttara, Dhaka: Uttara exists in all the years but Turag does not exist only in 2001. Administration Turag thana was formed on 27 June 2005 comprising part of Harirampur union of Uttara thana (Banglapedia).

replace  upazilabd = 302695 if upazilabd == 302610 //Dakkhinkhan to Uttara, Dhaka: Dakshinkhan Thana was formed in 2006, named after the Dakshinkhan Union (Online Banglapedia). Uttara exists in all the years but Dakkhinkhan does not exist only in 2001. 

replace  upazilabd = 302695 if upazilabd == 302696 //Uttarkhan to Uttara(in census uttara and biman bandar) , Dhaka:  Administration Uttarkhan thana, named after Uttarkhan Union, was formed in 2006. It consists of union 1, mouza 14. (Banglapedia online). Uttara exists in all the years but Uttarkhan does not exist only in 2001.

replace  upazilabd = 302604 if upazilabd == 302637 //Khilkhet to Badda, Dhaka: Administration Khilkhet thana was established on 27 June in 2005 consisting of south parts of Badda thana (Online Banglapedia). Khilkhet exists in all the years but Badda does not exist only in 2001. 

replace  upazilabd = 302666 if upazilabd == 302675 // Shahbag to Ramna, Dhaka: Administration Shahbagh Thana was formed on 7 August 2006 comprising parts of Ramna thana (Online Banglapedia). Ramna exists in all the years but Shahbagh does not exist only in 2001. 

replace  upazilabd = 302636 if upazilabd == 302667  //replace  Upazila = "Khilgaon" if Upazila == "Rampura" & Zila == "Dhaka" // Rampura to Khilgaon, Dhaka: Administration Rampura thana was formed on 2 August in 2009 (Online Banglapedia). No Rampura in upazila level in 2009  but found Rampura addresses in Khilgaon in 2009 dataset and not in 2011

replace  upazilabd = 302650 if upazilabd == 302602 //Adabor to Mohammadpur, Dhaka: Mohammadpur exists in all the years but Adabar does not exist only in 2001. Administration Adabar thana was formed on 27 June 2007 comprising part of Mohammadpur thana.  (Banglapedia). (code 2665 in BR BD census2011 to 2654 )

replace  upazilabd = 302688 if upazilabd == 302624 //Gendaria (302624) to Sutrapur (302688), Dhaka: Administration Gandaria Thana was formed on 4 February 2010 comprising parts of Sutrapur Thana.(Banlapedia)

replace upazilabd = 302640 if upazilabd == 302609  //replace Upazila = "Chak Bazar" if Upazila == "Chak Bazar" & Zila == "Dhaka"  // Chak bazar(302609) to Kotwali(302640), Dhaka: Chak bazar was formed in August 2009 from parts of Lalbagh Thana and Kotwali Thana (Online Banglapedia). No Chak Bazar upazila in 2009 but found Chak Bazar addresses in Lalbagh in 2009 dataset. And in census chakbazar only in 2011.

replace upazilabd = 302640 if upazilabd == 302642  //replace Upazila = "Kotwali" if Upazila == "Lalbagh" & Zila == "Dhaka"  // Lalbagh(302642) to Kotwali(302640), Dhaka: Chak bazar was formed in August 2009 from parts of Lalbagh Thana and Kotwali Thana (Online Banglapedia). 

replace  upazilabd = 302640 if upazilabd == 302605 // replace  Upazila = "Kotwali" if Upazila == "Bangshal" & Zila == "Dhaka" // Bangshal to kotwali, Dhaka: No Bangshal upazila in 2009 but found all the Bangshal address in Kotwali in 2009 dataset, BR BD data it is in Kotwali; census has Bangshal only in 2011. So I put Bangshal in Kotwali 

replace  upazilabd = 302648  if upazilabd == 302611 // Darus Salam to Mirpur, Dhaka: Administration Darus Salam Thana was formed on 23 August 2008 comprising part of Mirpur Model Thana (Online Banglapedia). No Darus Salam upazila in 2009 but found Darus Salam addresses in Mirpur in 2009 dataset, in BR BD dataset it is Mirpur. In census Darus salam is only in 2011. So I make it Mirpur

replace  upazilabd = 302648 if upazilabd == 302674 //Shah Ali(302674) to Mirpur(405094) //Mirpur Model Thana was formed in 1962 (Banglapedia). Mirpur Thana has recently been divided into the three thanas of Shah Ali, Pallabi and Kafrul (Wikipedia). Administration Pallabi Thana was formed on 15 March 1995 (Banglapedia). Administration Kafrul thana was formed in 1998 consisting parts of Mirpur Model and Cantonment thanas (Banglapedia). Administration Shah Ali Thana was formed in 2005 (Banglapedia).

replace  upazilabd = 302612 if upazilabd == 302629 //Jatrabari to Demra(302612), Dhaka: Demra exists in all the years but Jatrabari does not exist only in 2001. 

replace  upazilabd = 302612 if upazilabd == 302632 //Kadamtali to Demra(302612), Dhaka: Administration Kadamtali Thana was formed on 23 September 2008 comprising parts of Shyampur and Demra thanas (Online Banglapedia). Administration Demra Thana was formed in 1973; later on the thana was reconstituted (Online Banglapedia).. Shyampur exists in all the years but Kadamtali does not exist only in 2001. 

replace  upazilabd = 302612 if upazilabd == 302676 //Shyampur to Demra(302612), Dhaka: Administration Kadamtali Thana was formed on 23 September 2008 comprising parts of Shyampur and Demra thanas (Online Banglapedia). Administration Demra Thana was formed in 1973; later on the thana was reconstituted (Online Banglapedia).. Shyampur exists in all the years but Kadamtali does not exist only in 2001. 



*adding up upazilas to address the upazila which originated from more than one upzila
replace  upazilabd = 605865 if upazilabd == 605814| upazilabd == 605835  //barlekha(605814) & Juri(605835) to Kulaura(605865)  // বিগত ২৬ আগষ্ট ২০০৪ খ্রিঃ তারিখে বাংলাদেশ সরকারের প্রশাসনিক পুনর্বিন্যাস সংক্রান্ত জাতীয় বাস্তবায়ন কমিটি(নিকা)র ৯০তম বৈঠকে মৌলভীবাজার জেলার কুলাউড়া উপজেলার ০৪টি (জায়ফরনগর, গোয়ালবাড়ী, সাগরনাল, ফুলতলা) এবং বড়লেখা উপজেলার ০৪টি( পূর্বজুড়ী, পশ্চিমজুড়ী, দক্ষিণভাগ, সুজানগর) এই ০৮ টি ইউনিয়ন নিয়ে একটি  ঐতিহাসিক ঘোষনার মাধ্যমে বাংলাদেশের ৪৭১তম প্রশাসনিক উপজেলা হিসেবে জুড়ীর আত্নপ্রকাশ। (Juri upazila website)

replace  upazilabd = 302650 if upazilabd == 302690 | upazilabd == 302692 | upazilabd == 302630 | upazilabd == 302650 | upazilabd == 302680 | upazilabd == 302626 //Tejgaon(302690) & Tejgaon Ind. Area(302692) & Kafrul(302630) & Mohammadpur(302650) & Sher-E-Bangla Nagar(302680) & Gulshan(302626) to Mohammadpur 
//Administration Tejgaon Thana was formed in 1953. This thana was reconstituted when Tejgaon Industrial Area thana was formed on 7 August 2006. (Banglapedia)
//Administration Sher-E-Bangla Nagar Thana was formed on 4 August 2009 comprising parts of Tejgaon, Kafrul and Mohammadpur thanas. (Banglapedia)
//Turag, Uttara and Biman Bandar are already together
 

 

*adjustment for business census. same ID do not match after adjustment for census too, so I incorporate new revision in 2001 level
*to make same as 2019 (from above 2009 did not match: Panchlaish, Double Mooring, Khulshi, Ramgarh, Mahanchhari,Pachlaish, Lalbagh, Potenga) because some of these have been revised between 2009 and 2019 covering more than one upazila 
//replace  Upazila = "Kotwali" if (Upazila == "Chalk Bazar" | Upazila == "Panchlaish" | Upazila == "Double Mooring" | Upazila == "Sadarghat")  & NAME_2 == "Chittagong" 
replace upazilabd = 201541 if (upazilabd == 201557 | upazilabd == 201528 ) //

//replace  Upazila = "Pahartali" if (Upazila == "Akbarshah" | Upazila == "Khulshi") & NAME_2 == "Chittagong" // Akbarshah established in 2013
replace upazilabd = 201555 if (upazilabd == 201543)  

//replace  Upazila = "Kotwali" if (Upazila == "Chak Bazar" | Upazila == "Lalbagh") & NAME_2 == "Dhaka" // 
replace  upazilabd = 302640 if (upazilabd == 302642)   //0

//replace Upazila = "Matiranga" if (Upazila =="Guimara" | Upazila == "Ramgarh" | Upazila == "Mahalchhari") & Zila == "46" // 
replace upazilabd = 204670 if (upazilabd ==204680 | upazilabd ==204665)   // 

//replace  Upazila = "Chittagong Port" if (Upazila == "Epz" | Upazila == "Patenga") & NAME_2 == "Chittagong" //
replace  upazilabd = 201520 if (upazilabd == 201565) // 

drop if upazilabd == 201553 //BR 2019 does not have mirsharai 

save "$Data\DataCreated\PopCen_UpaCodeAdjust", replace



use "$Data\DataCreated\PopCen_UpaCodeAdjust", clear

decode geo2_bd, generate(Zila) 
decode upazilabd, generate(Upazila)
replace Zila = proper(Zila)
replace Upazila = proper(Upazila)
*Some name adjustment
replace Upazila = "Banari Para" if Upazila == "Banaripara"
replace Upazila = "Barisal Sadar (Kotwali)" if Upazila == "Barisal Sadar"
replace Upazila = "Daulatkhan" if Upazila == "Daulat Khan"
replace Zila = "Brahamanbaria" if Zila == "Brahmanbaria"
replace  Upazila = "Matlab Uttar" if Upazila == "Uttar Matlab" 
replace  Upazila = "Matlab Dakshin" if Upazila == "Matlab" 
replace Zila = "Nawabganj" if Zila == "Chapai Nababganj"
replace Upazila = "Bakalia" if Upazila == "Bakalia Thana"
replace Upazila = "Bayejid Bostami" if Upazila == "Bayejid Bostami Thana"
replace Upazila = "Chandgaon" if Upazila == "Chandgaon Thana"
replace Upazila = "Chittagong Port" if Upazila == "Chittagong Port Thana"
//replace Upazila = "Double Mooring" if Upazila == "Double Mooring Thana"
replace Upazila = "Halishahar" if Upazila == "Halishahar Thana"
replace Upazila = "Karnafuli (Police Station)" if Upazila == "Karnafuli"
//replace Upazila = "Khulshi" if Upazila == "Khulshi Thana"
replace Upazila = "Kotwali" if Upazila == "Kotwali Thana"
replace Upazila = "Pahartali" if Upazila == "Pahartali Thana"
//replace Upazila = "Panchlaish" if Upazila == "Panchlaish Thana"
//replace Upazila = "Patenga" if Upazila == "Patenga Thana"
replace Upazila = "Badda" if Upazila == "Badda Thana"
replace Upazila = "Cantonment" if Upazila == "Cantonment Thana"
replace Upazila = "Demra" if Upazila == "Demra Thana"
replace Upazila = "Dhanmondi" if Upazila == "Dhanmondi Thana"
//replace Upazila = "Gulshan" if Upazila == "Gulshan Thana"
replace Upazila = "Hazaribagh" if Upazila == "Hazaribagh Thana"
//replace Upazila = "Kafrul" if Upazila == "Kafrul Thana"
replace Upazila = "Kamrangir Char" if Upazila == "Kamrangir Char Thana"
replace Upazila = "Khilgaon" if Upazila == "Khilgaon Thana"
replace Upazila = "Mirpur" if Upazila == "Mirpur Thana"
replace Upazila = "Mohammadpur" if Upazila == "Mohammadpur Thana"
replace Upazila = "Motijheel" if Upazila == "Motijheel Thana"
replace Upazila = "Pallabi" if Upazila == "Pallabi Thana"
replace Upazila = "Ramna" if Upazila == "Ramna Thana"
replace Upazila = "Sabujbagh" if Upazila == "Sabujbagh Thana"
//replace Upazila = "Sher-E-Bangla Nagar" if Upazila == "Sher-E-Bangla Nagar Thana"
replace Upazila = "Sutrapur" if Upazila == "Sutrapur Thana"
//replace Upazila = "Tejgaon Ind. Area" if Upazila == "Tejgaon Ind.Area Thana"
//replace Upazila = "Tejgaon" if Upazila == "Tejgaon Thana"
replace Upazila = "Uttara And Bimanbandar" if Upazila == "Uttara And Bimanbandar Thana"
replace Upazila = "Daulatpur" if Upazila == "Daulatpur Thana"
replace Upazila = "Khalishpur" if Upazila == "Khalishpur Thana"
replace Upazila = "Khan Jahan Ali" if Upazila == "Khan Jahan Ali Thana"
replace Upazila = "Khulna Sadar" if Upazila == "Khulna Sadar Thana"
replace Upazila = "Sonadanga" if Upazila == "Sonadanga Thana"
replace Upazila = "Kendua" if Upazila == "Kendua Thana"
replace Upazila = "Boalia" if Upazila == "Boalia Thana"
replace Upazila = "Matihar" if Upazila == "Matihar Thana"
replace Upazila = "Rajpara" if Upazila == "Rajpara Thana"
replace Upazila = "Shah Makhdum" if Upazila == "Shah Makhdum Thana"
replace Upazila = "Kotali Para" if Upazila == "Kotalipara"
replace Upazila = "Tungi Para" if Upazila == "Tungipara"
replace Zila = "Jhenaidah" if Zila == "Jhenaidaha"
replace Zila = "Netrakona" if Zila == "Netrokona"
replace Zila = "Maulvibazar" if Zila == "Maulvi Bazar"
replace Upazila = "Shariatpur Sadar" if Upazila == "Palong (Sadar)"
replace Upazila = "Naniarchar" if Upazila == "Maniarchar"
replace Upazila = "Balia Kandi" if Upazila == "Baliakandi"
replace Upazila = "Nawabganj Sadar" if Upazila == "Nababganj Sadar"
replace Upazila = "Jhenaidah Sadar" if Upazila == "Jhenaidaha Sadar"

by year Zila upazilabd, sort: gen nupazila= _n==1
count if nupazila & year == 2001 //493
count if nupazila & year == 2011 //492

by year Zila Upazila, sort: gen nupazila1= _n==1
count if nupazila1 & year == 2001 //493
count if nupazila1 & year == 2011 //492
list if nupazila1 == . //none
drop nupazila1
drop nupazila
save "$Data\DataCreated\PopCen_UpaNamAdjust", replace

by year Zila upazilabd, sort: gen nupazila= _n==1
count if nupazila & year == 2001 //493
count if nupazila & year == 2011 //492
by year Zila Upazila, sort: gen nupazila1= _n==1
count if nupazila1 & year == 2001 //493
count if nupazila1 & year == 2011 //492 // because I name Bijoynagar upazila as Brahmanbaria sadar when I generate name of Zila and Upazila. 
keep if nupazila== 1 | nupazila1== 1 
keep if year ==2011
drop nupazila nupazila1

use "$Data\DataCreated\PopCen_UpaNamAdjust", clear
gen upazila_cd = upazilabd
collapse (count) empstat , by (year upazilabd upazila_cd)  
drop if upazilabd == 201539 
tab year, sum(empstat)

sort upazilabd
//asdoc tab year 
tab year 
tab year if empstat != . //

reshape wide empstat, i(upazilabd) j(year)  //need to know why karnafuli is not in the 2011 census
//drop if empstat2001 == . | empstat2011 == . //
list if empstat2011 == . //only Karnafuli
list if empstat2001 == . 
* just to check karnafuli in 2011
use "$Data\ipumsi_00002.dta", clear
tab upazilabd if geo2_bd == 50020004 & year ==2011 // no idea why karnafuli is not in 2011! Is it a sampling issue (Maybe I should ask IPUMS ). I will check Chittagong zila statistics report of 2011 census, it is not working right now, will do later
tab upazilabd if geo2_bd == 50020004 & year ==2001







use "$Data\DataCreated\PopCen_UpaNamAdjust", clear
format upazilabd %30.0g
fre empstatd
fre empstat
gen employed_dum= (empstat==1)
tab employed_dum

//egen livelihood = total(livehood) if livelihod==1
tab urban
gen urbanpop= (urban==2)
tab urbanpop

fre Industry2001
fre Industry2011
gen industry = (Industry2001==5 | Industry2001==6 | Industry2001==7 | Industry2001==8  | Industry2001==9 | Industry2001==10 | Industry2001==11 | Industry2001==12 | Industry2011==2 | Industry2011==3), after(ind)
gen ind_emp = (empstat==1 & industry==1)

tab industry year
tab year, sum(industry)
tabstat industry, stat(sum n min mean max) by(year ) 

bysort year geo2_bd upazilabd: gen pop_total =_N
egen  pop_urban = total(urbanpop) , by (year geo2_bd upazilabd)  
egen  emp_indser = total(ind_emp) , by (year geo2_bd upazilabd)  

collapse (count) empstat (sum) urbanpop employed_dum industry , by (year geo2_bd upazilabd pop_total pop_urban emp_indser)
rename employed_dum emp_total
drop empstat urbanpop industry
 
format year geo2_bd upazilabd pop_total pop_urban emp_indser emp_total %10.0g

summarize pop_total pop_urban emp_indser emp_total, format
tabstat pop_total pop_urban emp_indser emp_total, stat(sum n min mean max) col(stat) long format by(year ) 
lab var pop_total "total population"
lab var pop_urban "urban population"
lab var emp_indser "employment in industry and service"
lab var emp_total "total employment"

reshape wide pop_total pop_urban emp_indser emp_total, i(geo2_bd  upazilabd ) j(year) 
reshape long pop_total pop_urban emp_indser emp_total, i(geo2_bd  upazilabd) j(year) 
gen urban_rate = (pop_urban / pop_total)*100
gen emp_rate = (emp_total/pop_total)*100
gen emp_indser_rate = (emp_indser/pop_total)*100

reshape wide pop_total pop_urban emp_indser emp_total urban_rate emp_rate emp_indser_rate, i(geo2_bd  upazilabd ) j(year) 

drop if upazilabd == 201539 // I do not know why Karnafuli does not exist in 2011, it's missing

//generate ID_ZUpazila= mod(upazilabd, 10000)
tostring upazilabd, gen(IDUpazila) format(%07.0f)


gen ID_ZUpazila = substr(IDUpazila, -4,.)
save "$Data\DataCreated\PopCen_Adjusted", replace




