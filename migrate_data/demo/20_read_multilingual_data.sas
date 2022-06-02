/*
 * different ways of reading the multilingual chars
 * in a SAS data set
 * data is already created
 */
libname utf8out "&localProjectPath/data";

/*
 * delete the different data sets created by the data steps below
 */
proc datasets lib=work nolist;
  delete countries_:;
run;

quit;

/* will fail in wlatin1 session */
data countries_1;
  set utf8out.countries;
run;

title "Problem reading all";

proc print data=countries_1;
run;

/* will run in wlatin1 session but produce unreadable text */
data countries_2;
  set utf8out.countries(encoding=asciiany);
run;

title "All data read but bad result";

proc print data=countries_2;
run;

/*
 * simple macro to convert from one encoding to another
 * by default chars not available in TO encoding are translated
 * to Unicode escaped string (for example, \u0000\u1234) 
 * one could also SUB='?' to translate into ?
 */
%macro sas_iconv_dataset(
      in=
      , out= 
      , from=UNDEFINED
      , to=UNDEFINED
      , sub='UESC'
      );

  data &out;
    set &in(encoding=asciiany);
    array cc (*) _character_;

    do _N_=1 to dim(cc);
      cc(_N_)=kpropdata(cc(_N_),&sub,"&from","&to");
    end;
  run;

  %let lib=%scan(&out,1,%str(.));
  %let mem=%scan(&out,2,%str(.));

  %if %length(&mem) = 0 %then %do;
    %let mem=&lib;
    %let lib=work;
  %end;

  proc datasets lib=&lib nolist;
    modify &mem / correctencoding=&to;
  run;

  quit;

%mend;

%sas_iconv_dataset(
  in=utf8out.countries
  , out=WORK.countries_lt1
  , from=utf-8
  , to=wlatin1
  )

  title "all data read and keep data not compatible as Unicode escaped string";

proc print data=countries_lt1;
run;

title;