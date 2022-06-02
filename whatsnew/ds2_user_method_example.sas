PROC DS2;
data c2f_conv(overwrite=yes);
  declare double degC degF;
  method c2f(double tC) returns double;
    declare double tempValue;
    /* Celsius to Farenheit */
    tempValue = ( ( tC * 9 ) / 5 ) + 32;
    return ( tempValue );
  end;
  method init();
    do degC = 0 to 30 by 2;
       degF = c2f(degC);
       output;
    end;
  end;
enddata;
run;
QUIT;

proc print data=c2f_conv;
run;

