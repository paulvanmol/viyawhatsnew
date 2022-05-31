/* encoding should be wlatin1 */
data have;
  text = "Die süße Hündin läuft in die Höhle des Bären";
  lastname = "Müller";
  firstName = "René";
run;

proc contents data=have;
run;

/* should fail */
data want1(encoding=utf8);
  set have;
run;

/* should succeed, with variable length being increased */
%copy_to_new_encoding(have,want2,utf8);


title "converted want2 data set";
proc contents data=want2;
run;
proc print data=want2;
run;
title;