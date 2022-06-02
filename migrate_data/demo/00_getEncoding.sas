/*
 * macro shows an example on how to read out encoding
 * of a SAS data set
 */

%macro getEncoding(data=&syslast);
  %local rc dsid encoding;
  %let dsid = %sysfunc( open(&data) );
  %if &dsid = 0 %then %do;
    %put ERROR: &sysmacroname could not open &data;
    %put %sysfunc( sysmsg() );
    %return;
  %end;

  %let encoding = %sysfunc( attrc(&dsid, ENCODING) );
  %let dsid = %sysfunc( close(&dsid) );
  %put NOTE: &sysmacroname &=data &=encoding;
%mend;

data cars;
  set sashelp.cars;
run;

%getEncoding(data=cars)

