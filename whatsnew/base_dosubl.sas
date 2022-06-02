*
* example suitable for SAS Enterprise Guide status update
* see also http://blogs.sas.com/content/sasdummy/2013/01/30/tracking-progress-with-dosubl/
*;
proc sort data=sashelp.cars out=sortedcars;
  by make;
run;

/* Tracking which "category" value is being processed */
data _null_;
  set sortedcars;
  by make;

  if first.make then do;
    rc = dosubl(catt('SYSECHO "OBS N=', _n_, ' MAKE=', make, '";'));
    rc = sleep(0.1, 1);
  end;
run;