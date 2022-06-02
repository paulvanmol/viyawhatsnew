
proc options option=encoding; 
run; 
proc options option=casdatalimit; 
run; 


libname case "d:\workshop\casestudy"; 
proc datasets lib=case; 
contents data=megacorp2020; 
quit;  
options cashost="server.demo.sas.com" casport=5570; 
cas mysession; 

proc casutil ; 
droptable casdata="megacorp2020" incaslib="casuser" quiet; 
load data=case.megacorp2020 casout="megacorp2020" outcaslib="casuser" promote; 
quit; 

proc casutil ; 
contents casdata="megacorp2020" incaslib="casuser"; 
quit; 

