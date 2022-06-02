/*
 * program uses the CVP (character variable padding) libname engine
 * to increase the length of char vars by a multiplier
 * the CVP engine is readonly
 */
options
  dlcreatedir
;

data have ;
  length lastname $7 firstname $5; 
  text = "Die süße Hündin läuft in die Höhle des Bären";
  lastname = "Müller";
  firstname = "René";

  format
    text $44.
    lastname $6.
  ;
run;

libname xutf8 "%sysfunc(pathname(work))/sas_utf8" outencoding=utf8 ;
libname xcvp  "%sysfunc(pathname(work))" cvpmultiplier=1.5 ;

data xutf8.want3;
  set xcvp.have;
run;

ods layout gridded columns=2;
ods region;
title "work.have";
ods select variables;
proc contents data=work.have;
run;
title;
ods region;
title "xutf8.want3";
ods select variables;
proc contents data=xutf8.want3;
run;
title;
ods layout end;