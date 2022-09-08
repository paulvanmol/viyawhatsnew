libname how "&localProjectPath/data"; 
data how.customers; 
infile cards dlm=',' ; 
input customer_name:$15. customer_country: $2.; 
cards; 
Jérémy Dupont, BE
Bruno Müller, DE
Oliver Fußling, DE
;
run; 
proc print data=how.customers; 
run; 
options cashost="server.demo.sas.com" casport=5570; 
cas mysession; 
options casncharmultiplier=2; 

proc casutil ; 
droptable casdata="customers" incaslib="casuser" quiet; 
load data=how.customers casout="customers" outcaslib="casuser" promote; 
quit; 

proc casutil ; 
contents casdata="customers" incaslib="casuser"; 
quit;
