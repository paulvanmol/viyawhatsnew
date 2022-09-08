/* encoding should be wlatin1 */
libname _latin1 "&path/data/latin1" outencoding='wlatin1';
data _latin1.have (encoding=wlatin1);
  text = "Die süße Hündin läuft in die Höhle des Bären";
  lastname = "Müller";
  firstName = "René";
run;

proc contents data=_latin1.have;
run;

/* should fail */
data want1(encoding=utf8);
  set _latin1.have;
run;

/* should succeed, with variable length being increased */
%copy_to_new_encoding(_latin1.have,want2,utf8);


title "converted want2 data set";
proc contents data=want2;
run;
proc print data=want2;
run;
title;