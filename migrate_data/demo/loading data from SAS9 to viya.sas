
proc options option=encoding; 
run; 

options cashost="server.demo.sas.com" casport=5570; 
cas mysession; 

proc casutil ; 
droptable casdata="insighttoy_how" incaslib="casuser" quiet; 
load data=how.insighttoy_how casout="insighttoy_how" outcaslib="casuser" promote; 
quit; 

proc casutil ; 
contents casdata="insighttoy_how" incaslib="casuser"; 
quit; 

