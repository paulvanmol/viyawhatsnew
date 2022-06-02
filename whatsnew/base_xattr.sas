data work.sales;
  purchase = "car"; 
  age = 10;
  income = 200000;
  kids = 3;
  cars = 4;
run;

proc datasets lib=work nolist;
  modify sales;
  xattr add ds
    role="train" attrib="table"
  ;
  xattr add var
    purchase ( role="target" level="nominal" targetValue=1 )
    age ( role="reject" )
    income ( role="input" level="interval" )
  ;
run;
  title  'The Contents of the Sales Data Set That Contains Extended Attributes';
  contents data=sales;
run;
quit;

title "Contents of DICTIONARY.XATTRS";
proc sql;
/*  create table my_xattrs as*/
  select
    *
  from
    dictionary.xattrs
  where
    libname = 'WORK'
  ;
quit;
title;