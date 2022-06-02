%let xlsDir = c:\temp;

proc export
  data=sashelp.cars
  file="&xlsDir/text.xlsx"
  dbms=xlsx
  replace
;
  sheet="Cars Information";
run;

proc export
  data=sashelp.class
  file="&xlsDir/text.xlsx"
  dbms=xlsx
  replace
;
  sheet="Class Attendees";
run;

proc import
  file="&xlsDir/text.xlsx"
  out=work.cars1
  dbms=xlsx
  replace
;
  sheet="Cars Information";
run;  

proc export
  data=sashelp.cars(where=(origin="Europe"))
  file="&xlsDir/text.xlsx"
  dbms=xlsx
  replace
;
  sheet="Cars Information";
run;


proc import
  file="&xlsDir/text.xlsx"
  out=work.cars2
  dbms=xlsx
  replace
;
  sheet="Cars Information";
run;  

proc import
  file="&xlsDir/text.xlsx"
  out=work.class1
  dbms=xlsx
  replace
;
  sheet="Class Attendees";
run;  


