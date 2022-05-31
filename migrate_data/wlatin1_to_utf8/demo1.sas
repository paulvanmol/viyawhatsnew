

data names; 
name="jérémie dupont"; 
len=length(name); 
klen=klength(name);
output; 
name="bruno Müller";
output; 
run; 

proc contents data=names; 
run; 

proc print data=names; 
run; 

data test ;
str= "€123" ;
s=substr(str,1,1) ;
sl=length(s);
l=length(str) ;
put str= $hex16. /s= sl= / s= $hex. /l=;
run ;