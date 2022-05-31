/*
 * definition of macro that will convert
 * current SBCS data sets into UTF8 encoding
 * increasing the length of vars as necessary
 * it it data depedant
 */
options 
  mcompilenote=all
;

%macro copy_to_new_encoding(
      from_dsname
      , to_dsname
      , new_encoding
      );
  * Use a prefix to ensure unique variable names;
  %let prefix=goobly;

  * create a LENGTH statement file with just a blank line;
  filename lngtstmt temp;

  data _null_;
    file lngtstmt;
    put ' ';
  run;

  * create a temp2 that might be replaced before being deleted;
  data temp2;
    x=1;
  run;

  * Get the names, lengths, types, and positions of all variables;
  proc contents
    data=&from_dsname
    out=temp1(keep=name type length npos where=(type=2))
    noprint
  ;
  run;

  * macro variable nchars indicates the number of character variables found;
  %global nchars;

  data _null_;
    call symputx('nchars',nchars);
    stop;
    set temp1 nobs=nchars;
  run;

  * Revision is only possibly necessary if there are character variables;
  %if &nchars %then %do;

    * macro variable revise will be set to 1 if a revision is needed;
    %global revise;
    %let revise=0;

    data temp2(keep=&prefix._name &prefix._length
      rename=(&prefix._name=NAME &prefix._length=LENGTH));
      set &from_dsname end=&prefix._eof;
      retain &prefix._revise 0;
      array &prefix._charlens{&nchars} _temporary_;
      array &prefix._charvars _character_;

      * get the lengths of all the character variables, set as negative;
      if _n_=1 then do over &prefix._charvars;
        &prefix._charlens{_i_}= -vlength(&prefix._charvars);
      end;

      * transcode all values and see if the lengths increase;
      do over &prefix._charvars;
        &prefix._l = lengthc(
          kcvt(trim(&prefix._charvars),"&new_encoding.")
          );

        if &prefix._l > abs(&prefix._charlens{_i_}) then do;
          &prefix._charlens{_i_} = &prefix._l;
          &prefix._revise = 1;
        end;
      end;

      * output any varnames and revised lengths;
      if &prefix._eof and &prefix._revise;
      call symputx('revise',1);
      length &prefix._name $32 &prefix._length 8;

      do over &prefix._charvars;
        if &prefix._charlens{_i_} > 0 then do;
          &prefix._name = vname(&prefix._charvars);
          &prefix._length = &prefix._charlens{_i_};
          output temp2;
        end;
      end;
    run;

    * if any lengths revised we will create a LENGTH statement;
    %if &revise %then %do;

      * merge in the revised lengths;
      proc sort data=temp2;
        by name;
      run;

      data temp1;
        merge temp1 temp2;
        by name;
      run;

      * sort back to npos to maintain the original order;
      proc sort;
        by npos;
      run;

      * generate a LENGTH statement for all variables in order;
      data _null_;
        set temp1;
        file lngtstmt mod;
        len = cats(ifc(type=2,'$',' '),length);
        stmt = catx(' ','length',nliteral(name),len,';');
        put stmt;
      run;

    %end;
  %end;

  * create the new data set with the original or revised lengths;
  data &to_dsname(encoding=&new_encoding);
    %include lngtstmt/source2;
    set &from_dsname;
  run;

  * cleanup;
  filename lngtstmt clear;

  proc delete data=temp1 temp2;
  run;

%mend copy_to_new_encoding;


/* encoding should be latin1 */
libname ordet "&path\latin1_ordetail"; 
libname ordetu8 "&path\utf8_ordetail"; 

/* USING CEDA to transcode should fail */
data ordetu8.customer(encoding=utf8);
  set ordet.customer;
run;

/* should succeed, with variable length being increased */
%copy_to_new_encoding(ordet.customer,ordetu8.customer,utf8);

title "original customer data set";
proc contents data=ordet.customer;
run;
title "converted customer data set";
proc contents data=ordetu8.customer;
run;
proc print data=ordetu8.customer(obs=20);
run;
title;
