%let localProjectPath =
   %sysfunc(substr(%sysfunc(dequote(&_CLIENTPROJECTPATH)), 1,
   %sysfunc(findc(%sysfunc(dequote(&_CLIENTPROJECTPATH)), %str(/\), -255 ))));


*
* must create PDF output
* shows how to control border
*;
proc sort data=sashelp.class out=class;
  by sex;
run;

data _null_;
  set work.class end=done;
  by sex;
  if _n_ eq 1 then do;
    declare odsout nob();
    nob.table_start();
      nob.head_start();
        nob.row_start();
          nob.format_cell(text: "Gender");
          nob.format_cell(text: "Name");
          nob.format_cell(text: "Height");
          nob.format_cell(text: "Weight");
        nob.row_end();
      nob.head_end();
  end;
  if first.sex then do;
    nob.row_start();
      nob.format_cell(text: sex, inhibit: "B");
      nob.format_cell(text: name, inhibit: "BR");
      nob.format_cell(text: height, inhibit: "BR");
      nob.format_cell(text: weight, inhibit: "B");
    nob.row_end();
  end;
  /* enclosed the following table row in ELSE-DO-END Statements  */
  /* otherwise the first obs of each by group is displayed twice */
  else do;
    nob.row_start();
      nob.format_cell(text: "" , inhibit: "T" );
      nob.format_cell(text: name, inhibit: "TR");
      nob.format_cell(text: height, inhibit: "TR");
      nob.format_cell(text: weight, inhibit: "T" );
    nob.row_end();
  end;
  if done then do;
    nob.table_end();
  end;
run;