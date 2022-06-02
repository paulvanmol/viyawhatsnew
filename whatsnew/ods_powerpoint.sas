options
  center
;
ods escapechar= "^";
ods powerpoint file='c:\temp\sample.pptx' layout=titleslide nogtitle ;

proc odstext;
  p 'Whats new with SAS9.4 and ODS' / style=presentationtitle;
  p "Live Web Class^{newline}%sysfunc( today(), ddmmyyp10.) by &_clientUsername" / style=presentationtitle;
run;

ods powerpoint layout=_null_;

title "Class Overview";
proc sgplot data=sashelp.class;
  bubble x=Age y=Height size=Weight / group=Sex datalabel=name transparency=.3;
  yaxis grid;
run;

title "Female class attendees";
proc print data=sashelp.class noobs;
  where sex = "F";
run;

title "Male class attendees";
proc print data=sashelp.class noobs;
  where sex = "M";
run;
title;

ods powerpoint close;