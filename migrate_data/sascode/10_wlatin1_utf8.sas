/*
 * run code in a SBCS encoding
 * UNICODEC Function
 * Converts characters in the current SAS session encoding to Unicode characters. 
 *
 */
data _null_;
  length
    name $ 32
    name_u8 $ 32
  ;

  sessionEncoding = getoption("Encoding");

  putlog "NOTE: using " sessionEncoding=;

  putlog @1 "name" @10 "name_u8";
  do name = "MÜLLER", "1€2";
    name_u8 = unicodec(name,  "UTF8");
    putlog @1 name @10 name $hex32.;
    putlog @1 name_u8 @10 name_u8 $hex32.;
  end;
run;

