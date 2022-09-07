proc options option=encoding; 
run; 
%let path=/home/student/viyawhatsnew/migrate_data/orion;
libname ordetl1 cvp "&path/latin1_ordetail"  CVPFORMATWIDTH=YES; 
libname _ctrl cvp "&path/_ctrl"; 

/*Read formats from a SAS dataset */
libname orfmtl1 cvp "&path/latin1_orfmt" ; 
libname orfmtu8 "&path/utf8_orfmt"; 
options fmtsearch=(orfmtu8);

proc format library=orfmtu8.formats cntlin=orfmtl1.formats;
run;

options dlcreatedir nofmterr; 
libname ordetail "&path/utf8_ordetail"; 

proc copy inlib=ordetl1 outlib=ordetail noclone index=no constraint=no; 
run; 

proc contents data=ordetl1.customer; 
proc contents data=ordetail.customer; 
run; 
proc contents data=ordetl1.supplier; 
run; 

/*
proc contents noprint data=ordetl1.supplier 
  out=contents_out 
  out2=contents_out2; 
  run;*/
/*copy supplier dataset to new encoding*/
proc datasets nolist;
  copy in=ordetl1 out=ordetail override=(encoding=session outrep=session);
  select supplier;
run;
/*Recreate the indexes and integrity contraints*/
proc sql noprint;
  select recreate into :recreatem  
  separated by " " from _ctrl.contents_out2;
  quit;

/*Run PROC DATASETS on the new data set with the MODIFY option and the %recreatem macro to re-create the indexes or the integrity constraints or both*/
  proc datasets lib=ordetail nolist;
  modify supplier;
  &recreatem;
  quit;
