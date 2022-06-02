proc sort data=sashelp.class out=work.class_s;
  by sex;
run;

data dosubl_sample;
  set work.class_s;
  by sex;

  if first.sex = 1 then do;
    length t_sasstmt $ 1024;
    t_sasstmt = catx(" ",
      "proc sql noprint;"
      , "select avg(age) into :avgAge"
      , "from sashelp.class"
      , "where sex =", quote(sex), ";", '%put NOTE: &=avgAge;quit;'
    );
    t_rc = dosubl(t_sasstmt);
    retain avgAge;
    avgAge = input( symget("avgAge"), 12.);
  end;
  avgDiff = age - avgAge;
run;
