options nofmterr; 
%let path=/home/student/viyawhatsnew/migrate_data/orion;
libname ordetl1 base "&path/latin1_ordetail"  ; 

proc options option=encoding; 
run;
proc print data=ordetl1.city (obs=5); 
run; 
proc print data=ordetl1.customer(obs=20); run; 