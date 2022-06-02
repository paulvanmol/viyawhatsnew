/*
 * UNICODEC Function
 * Converts characters in the current SAS session encoding to Unicode characters. 
 *
 * UNICODE Function
 * Converts Unicode characters to the current SAS session encoding. 
 */
data _null_;
  length in1 out1 $30;
  in1 = unicodec("1€23");
  out1=unicode(in1);
  put _all_;
run;