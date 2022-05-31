data test;
   input StudID $12. Age Fname $6. Mi :$2. Lname $7.;
   datalines;
120400310496 15 Oliver S. Füßling
;

proc print;
run;