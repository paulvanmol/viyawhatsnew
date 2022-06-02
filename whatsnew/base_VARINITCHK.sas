 options varinitchk=ERROR;
data newClass;
  set sashelp.class;
  newAge = ag;
run;

