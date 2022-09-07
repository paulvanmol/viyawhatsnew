*libname axls EXCEL "/home/student/xlsx_engine.xlsx";
libname axls xlsx "/home/student/xlsx_engine.xlsx";

data axls.cars;
  retain buyDate "&sysdate9"d;
  set sashelp.cars;
  buyDate + -1;
  format buydate date9.;
run;

libname axls clear;
/*
libname axls pcfiles path="d:\workshop\pcfilesengine.xlsx" 
server="sasbap.demo.sas.com" port=19621;

data axls.cars;
  retain buyDate "&sysdate9"d;
  set sashelp.cars;
  buyDate + -1;
  format buydate date9.;
run;

libname axls clear;
*/