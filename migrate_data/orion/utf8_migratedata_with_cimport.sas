/* %let path=C:\workshop\UTF8Encoding\orion; */
%let path=/home/student/viyawhatsnew/migrate_data/orion;
options dlcreatedir nofmterr; 
libname ordet "&path/utf8_ordetail" ; 
libname orfmt "&path/utf8_orfmt"; 

filename ctrldet zip "&path/_ctrl/_ctrl.zip" member="ordet.xpt"; 
proc cimport library=ordet file=ctrldet extendvar=1.5 extendformat=yes; 
run; 
filename ctrlfmt zip "&path/_ctrl/_ctrl.zip" member="orfmt.xpt"; 
proc cimport library=orfmt file=ctrlfmt extendvar=1.5; 
run; 

proc print data=ordet.customer(obs=20); 
run;
proc contents data=ordet.customer; 
run;
