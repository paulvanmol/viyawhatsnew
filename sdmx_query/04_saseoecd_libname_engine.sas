/*
http://stats.oecd.org/sdmx-json/data/SNA_TABLE1_SNA93/EA17.B1_GA.C/all?startTime=1995&endTime=2013
*/
%let homedir=%sysget(HOME); 
%let path=&homedir/viyawhatsnew; 
options validvarname=any dlcreatedir;
libname oecddata base "&path/sdmx_query/oecddata"; 

data keylist0;
   length key0 $8;
   key0='EA17'; output; /* country is euro area; 17 countries */
run;

data keylist1;
   length key1 $8;
   key1='B1_GA'; output; /* transaction is GDP; output approach */
run;

data keylist2;
   length key2 $2;
   key2='C'; output;     /* measure is current prices */
run;

title 'Request GDP for EA_17 in Current Prices';
LIBNAME myLib saseoecd "&path/sdmx_query/oecddata"
   setid=SNA_TABLE1_SNA93
   inset0=keylist0
   inset1=keylist1
   inset2=keylist2
   out=gstart
   ;

data myGDP;
   set myLib.gstart ;
run;
proc print data=myGDP; run;
