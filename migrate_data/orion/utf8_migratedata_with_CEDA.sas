options nofmterr; 
%let path=/greenmonthly-export/ssemonthly/homes/paul.van.mol@sas.com/utf8encoding/orion;
libname ordetl1 base "&path/latin1_ordetail"  ; 

proc options option=encoding; 
run;
proc print data=ordetl1.city (obs=5); 
run; 
proc print data=ordetl1.customer(obs=20); run; 