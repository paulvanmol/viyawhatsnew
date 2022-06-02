*
* create files in a ZIP file
*;

/*%let foozip = %sysfunc(pathname(work))/sample.zip;*/
%let foozip = c:\temp/sample.zip;

filename foo ZIP "&foozip" member="cars.csv";

proc export data=sashelp.cars dbms=csv outfile=foo;
run;

filename foo ZIP "&foozip" member="class.csv";

proc export data=sashelp.class dbms=csv outfile=foo;
run;

filename foo ZIP "&foozip" member="reports/report.pdf";
ods pdf file=foo;
title "Report as of %sysfunc( time(), time12.3)";
proc print data=sashelp.class;
run;

proc sgplot data=sashelp.cars;
  vbar type / response=invoice stat=mean;
run;
title;

ods pdf close;

*
* read the CSV from within the ZIP file
*;
filename foo ZIP "&foozip" member="class.csv";

data work.class;
  infile foo dlm="," dsd firstobs=2;
  input
    name : $8.
    sex : $1.
    age : 8.
    weight : 8.
    heigth : 8.
  ;
run;

filename foo clear;


*
* read the contents of a ZIP file
*;
filename foo ZIP "&foozip" ;

data contents(keep=memberName);
  length memberName $ 256;
  did = dopen("foo");

  if did = 0 then do;
    stop;
  end;
  memcount = dnum(did);

  do i=1 to memcount;
    memberName = dread(did, i);
    output;
  end;

  rc=dclose(did);
run;

proc print data=contents;
run;