data have;
  infile cards dlm="," dsd;
  input
    id : 8.
    tableName : $32.
  ;
  cards;
1,TableA
2,TableB
3,TableA
4,TableB
1,TableC
5,TableC
;

%macro createtables(name=);

  data &name;
    do id = 1 to 5;
      length someValue $ 32;
      someValue = catx("_", id, "&name");
      output;
    end;
  run;

%mend;

%createtables(name=tableA)
%createtables(name=tableB)
%createtables(name=tableC)

filename mycode temp;

data _null_;
  set have end=last;
  file myCode;
  length query $ 1024;
  query = catx(" ", 
    'select a.* from'
    , strip(tableName)
    , 'as a'
    , 'where a.id = '
    , id
    );

  if _n_ = 1 then do;
    put "proc sql;";
    put "create table wantDS as";
    put query;
  end;
  else do;
    put "outer union corresponding";
    put query;
  end;

  if last = 1 then do;
    put ";quit;";
  end;
run;

%include myCode / source2;
filename myCode clear;

proc ds2;

  data wantDS2(overwrite=yes);
    declare char(32) someValue;

    method run();
      declare int rc;
      declare package sqlstmt t_sql;
      declare varchar(1024) query;
      set {select id, tableName from have   };
      query = 
        'select a.* from ' !! strip(tableName) !! ' as a'
        !! ' where a.id = ' !! id
      ;
      put 'NOTE: ' query=;
      t_sql = _NEW_ SQLSTMT(query);
      rc = t_sql.bindresults(  [id someValue] );

      if ( rc ne 0 ) then do;
        put 'ERROR: BindResults error: ' rc;
      end;

      rc = t_sql.execute();

      if ( rc ne 0 ) then do;
        put 'ERROR: Execute error: ' rc;
      end;

      do while (t_sql.fetch() eq 0);
        output;
      end;
    end;

  enddata;
run;

quit;

proc print data=wantDS2;
run;