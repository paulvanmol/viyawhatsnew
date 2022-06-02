
libname axls xlsx "c:\temp\xlsx_engine.xlsx";

data axls.cars;
  retain buyDate "&sysdate9"d;
  set sashelp.cars;
  buyDate + -1;
  format buydate date9.;
run;

libname axls clear;
