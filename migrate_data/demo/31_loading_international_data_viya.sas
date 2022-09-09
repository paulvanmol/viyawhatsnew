libname how "&localProjectPath/data/latin1" outencoding=wlatin1; 
data how.customers (encoding=wlatin1); 
length customer_name $15;
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
proc contents data=how.customers; 
run; 
*options cashost="server.demo.sas.com" casport=5570; 
cas mysession; 
/*casdatalimit limits the client side upload to 100M*/
/*casncharmultiplier multiplies character lengths */
options casncharmultiplier=2 casdatalimit=100M; 

proc casutil ; 
droptable casdata="customers" incaslib="casuser" quiet; 
load data=how.customers casout="customers" outcaslib="casuser" promote; 
quit; 

proc casutil ; 
contents casdata="customers" incaslib="casuser"; 
quit;

