%let path=C:\workshop\UTF8Encoding\orion;
options dlcreatedir nofmterr; 
libname ordet "&path\latin1_ordetail"; 
libname orfmt "&path\latin1_orfmt"; 

/*Create a dataset from the formats catalog*/
proc format library=orfmt.formats cntlout=orfmt.formats;
run;

/*Write index and IC info to output dataset*/
libname _ctrl "&path\_ctrl"; 

proc contents noprint data=ordet.supplier
  out=_ctrl.contents_out 
  out2=_ctrl.contents_out2; 
  run;

  proc contents noprint data=ordet._all_
  out=_ctrl.contents_outall 
  out2=_ctrl.contents_outall2; 
  run;

