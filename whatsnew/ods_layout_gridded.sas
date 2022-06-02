ods pdf file="c:\temp\sample.pdf";

title "Two Colum Layout";
footnote justify=right link="http://www.sas.com" "Created by SAS&sysver";
ods layout gridded columns=2;
ods region;

  proc print data=sashelp.class;
  run;

ods region;

ods graphics / width=8cm height=6cm;
  proc sgplot data=sashelp.class;
    vbar age;
  run;
 proc sgplot data=sashelp.class;
    hbar age;
  run;

ods layout end;
title;

ods pdf startpage=now;
title "Three Rows Layout";
ods layout gridded rows=3 
  row_heights=(1in 2in 3in);

ods region;
proc print data=sashelp.class(obs=1);
run;

ods region;
proc means data=sashelp.class n mean;
run;

ods region;
proc print data=sashelp.class(obs=3);
run;

ods layout end;
ods pdf close;
title;
footnote;