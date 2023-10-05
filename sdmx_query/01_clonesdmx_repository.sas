/*create the SDMX folder in the home directory of the user*/
%let homedir=%sysget(HOME); 
%let path=&homedir;

%let path=c:/workshop/viyawhatsnew/sdmx_query;
options dlcreatedir; 
libname data "&path/SDMX"; 

/*clone the SDMX git repository to a local folder*/
data _null_;
RC = GITFN_CLONE("https://github.com/amattioc/SDMX.git",
"&path/SDMX");
run;

/*Get the latest release from https://github.com/amattioc/SDMX/releases/latest*/
/*Current release is 3.0.6*/

/*create the lib folder*/
libname lib "&path/SDMX/lib"; 
/*download SDMX.jar to the lib folder*/
 filename out "&path/SDMX/lib/SDMX.jar"; 
 proc http 
  url='https://github.com/amattioc/SDMX/releases/download/v3.0.6/SDMX.jar' 
  method="get" out=out; 
  *debug level=3; 
 run; 

/*download the sassdmx.tar.gz files*/
filename out "&path/SDMX/lib/sassdmx.tar.gz";
proc http
 url='https://github.com/amattioc/SDMX/releases/download/v3.0.6/sassdmx.tar.gz'
 method="get" out=out;
 *debug level=3;
run;

/*Add the downloaded jar file to the classpath of your sas session*/
/*in SASV9.CFG use: */
/*-SET CLASSPATH "&path/SDMX/lib/SDMX.jar"; */
*options set=CLASSPATH "&path/SDMX/lib/SDMX.jar"; 
