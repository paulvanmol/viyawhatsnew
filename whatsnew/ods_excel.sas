*
* more Info here
* https://support.sas.com/resources/papers/proceedings16/SAS5642-2016.pdf
* 
*;

%let ods_excel = c:\temp\ods_dest.xlsx;
ods excel file="&ods_excel"
  options(
    embedded_titles = "yes"
    sheet_name = "sugus"
    sheet_interval = "none"
    tab_color = "blue"
  )
  gtitle
;
title "Proc TABULATE";

proc tabulate data=sashelp.cars format=commax14.;
  class origin type;
  var invoice;

  table
    type all
    , (origin all) * invoice * {style = {tagattr="Format:#,##0" }}
  ;
run;

title "Proc SGPLOT";
proc sgplot data=sashelp.cars;
  vbar type / group=Origin response=Invoice;
run;

title;

/*
 * start a new sheet with next proc 
 * and set some options
 */
ods excel options(
  SHEET_INTERVAL='proc'
  sheet_name = "Some Cars"
  AUTOFILTER="yes"
  tab_color = "none"
);
title;
footnote;
proc print data=sashelp.cars noobs n;
  where invoice <= 20000;
run;

ods excel close;