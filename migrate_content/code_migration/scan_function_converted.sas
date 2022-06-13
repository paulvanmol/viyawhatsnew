***********************************************************;
*  Analyze for Internationalization                       *;
*  Convert character functions to UTF-8 K-functions       *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    SCAN (string, n <, 'delimiters'>) ->KSCAN            *;
*    STRIP (string)                    ->KSTRIP           *;
*    COMPBL and PROPCASE already are UTF-8 compatible     *;
***********************************************************;

***********************************************************;
*  Demo                                                   *;
*  Code migration character functions                     *;
*  1) Use Analyze for Internationalization:               *;
*  2) Substitutions are suggested for functions           *;
*  3) Paths, Macro functions are manually changed         *;
***********************************************************;
%let path =c:/workshop/git/viyawhatsnew; 
libname pg2 "&path/migrate_content/code_migration"; 
data weather_japan_clean;
	set pg2.weather_japan;
	Location=compbl(Location);
	City=propcase(kscan(Location, 1,','),' ');
	Prefecture=kstrip(kscan(Location, 2,','));
	country=kscan(Location,-1); 
run;

%macro weatherlist(prefecture=Tokyo); 
%let prefecture=%upcase(&prefecture);
proc print data=weather_japan_clean; 
where kupcase(prefecture)="&prefecture";
title "Weather stations for &prefecture"; 
run; 
%mend; 
%weatherlist(prefecture=Tokyo);