/*ds04d01b*/
proc ds2;

  data _null_;
    method init();
      dcl double a b c;
      a = 1234567891234567891234.56789;
      b = 9876543219876543219876.54321;
      c = a + b + .00001;
      put '***** DOUBLE TYPE *****';
      put ' 1234567891234567891234.56789 / ' a 32.5;
      put ' 9876543219876543219876.54321 / ' b 32.5;
      put '11111111111111111111111.11111 / ' c 32.5;
    end;

  enddata;
run;

quit;


proc ds2;

  data _null_;
    method init();
      dcl decimal(32,5) a b c;
      a = 1234567891234567891234.56789n;
      b = 9876543219876543219876.54321n;
      c = a + b + .00001n;
      put '***** DECIMAL TYPE *****';
      put ' 1234567891234567891234.56789 / ' a;
      put ' 9876543219876543219876.54321 / ' b;
      put '11111111111111111111111.11111 / ' c;
    end;

  enddata;
run;

quit;