%let path=/greenmonthly-export/ssemonthly/homes/paul.van.mol@sas.com/utf8encoding; 
options dlcreatedir; 
libname _latin1 "&path/data/latin1" outencoding='wlatin1';
 
data _latin1.T01_LATIN1 (encoding=wlatin1);
*length TX_STRING $5;
length TX_STRING $8;
TX_STRING="jérémy";
len=length(TX_STRING);
klen=klength(TX_STRING); 
run;
proc contents data=_latin1.T01_LATIN1; 
run;  
proc print data=_latin1.t01_latin1; 
run; 
* A exécuter sur SASApp-UTF8;   
options dlcreatedir; 
libname _latin1 "&path/data/latin1" inencoding='wlatin1'; 
*libname _latin1 CVP "&path/data/latin1" inencoding='wlatin1'; 
libname _utf8 "&path/data/utf8" outencoding='utf-8';  
 
data _utf8.T01_UTF8;
set _latin1.T01_LATIN1;
run;
proc contents data=_latin1.T01_LATIN1; 
run; 
proc print data=_utf8.T01_UTF8; 
run; 