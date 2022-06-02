/*
 * NOTE: code must be run in UTF-8 SAS session
 *
 * for the DATA Step with need to use the K... functions
 * in DS2 or Proc FEDSQL this is handled correctly
 */

data have;
  length 
    specialChar $ 32
  ;
  specialChar = "1€234";
run;

proc contents data=have;
run;

/*
 * SUBSTR will fail since it is byte based
 * KSUBSTR will work since it is character based
 */
data ds_have;
  set have;
  substr_pos2 = substr(specialChar, 2, 1);

  ksubstr_pos2 = ksubstr(specialChar, 2, 1);

  putlog _all_;
run;

title "Result in DATA Step";
proc print data=ds_have;
run;
title;

title "result from Proc DS2";
proc ds2;
  data;
    dcl varchar(10) pos2;
    method run();
      set have;
      
      pos2 = substr(specialChar, 2, 1);
      put specialchar= pos2=;
    end;

  enddata;
run;
quit;
title;

title "result from proc FEDSQL";
proc fedsql;
  select
    *
    , substr(specialChar, 2, 1) as pos2
  from
    have
  ;
quit;
title;