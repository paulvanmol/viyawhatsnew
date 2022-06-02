title "Using the SEGLABEL option";
footnote;
proc sgplot data=sashelp.cars ;
  vbar type / 
    group=origin
    response=invoice 
    stat=mean 
    datalabel
    seglabel 
  ;
run;
title;
footnote;