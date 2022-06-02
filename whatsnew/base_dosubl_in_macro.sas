/* 
 * example of DOSUBL in a macro to run some SAS code 
 * without interfering with the input stack
 * taken from
 * https://support.sas.com/resources/papers/proceedings13/032-2013.pdf
 */
%macro expandVarlist(
  data=_LAST_
  , var=_ALL_
);
  %if %upcase(%superq(data)) = _LAST_ %then %do;
    %let data = &SYSLAST;
  %end;
  %let rc = %sysfunc(dosubl(%str(
    proc transpose data=&DATA(obs=0) out=ExpandVarList_temp;
    var &VAR;
    run;
    proc sql noprint;
    select
    _name_ into :temp_varnames separated by ' '
    from ExpandVarList_temp
    ;
    drop table ExpandVarList_temp;
    quit 
    )));
  &temp_varnames
%mend expandVarlist;

%put NOTE: *%expandVarList(data=sashelp.cars, var=mpg:)*;