options
  locale = de_CH 
  timezone = "CETS"
;

data timeZone;
  infile cards;
  input
    utcDT anydtdtm.
  ;
  localDT = TZONEU2S(utcDT);



  format
    utcDT e8601dz. localDT e8601lx.
  ;
cards;
31dec2013:23:15
01jan2014:14:00
;

proc print data=timeZone;
run;