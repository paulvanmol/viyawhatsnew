/*
 * use dictionary.options table to list all the relevant
 * SAS system options related to language and encoding
 *
 * it will show how the options were set
 */ 
options nolabel;
proc sql;
  select
    optname
    , opttype
    , setting
    , optdesc
    , level
    , optstart
/*    , group */
    , getoption(optname, "HOWSET") as opt_howset
  from  
    dictionary.options
  where
    group = "LANGUAGECONTROL"
  order by
    optname
  ;
quit;
options label;

