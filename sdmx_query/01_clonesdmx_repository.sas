/*create the SDMX folder in the home directory of the user*/
%let homedir=%sysget(HOME); 

%let path=&homedir;
options dlcreatedir; 
libname data "&path/SDMX"; 

/*clone the SDMX git repository to a local folder*/
data _null_;
RC = GITFN_CLONE("https://github.com/amattioc/SDMX.git",
"&path/SDMX");
run;

/*create the lib folder*/
libname lib "&path/SDMX/lib"; 
/*download SDMX.jar to the lib folder*/
/* filename out "&path/SDMX/lib/SDMX.jar"; */
/* proc http */
/*  url='https://github.com/amattioc/SDMX/releases/latest/SDMX.jar' */
/*  method="get" out=out; */
/*  *debug level=3; */
/* run; */
/*
download the sassdmx.tar.gz files
filename out "&path/SDMX/lib/sassdmx.tar.gz";
proc http
 url='https://github.com/amattioc/SDMX/releases/latest/sassdmx.tar.gz'
 method="get" out=out;
 *debug level=3;
run;
*/
/*Add the downloaded jar file to the classpath of your sas session*/
/*in SASV9.CFG use: */
/*-SET CLASSPATH "&path/SDMX/lib/SDMX.jar"; */
*options set=CLASSPATH "/home/student/SDMX/lib/SDMX.jar"; 