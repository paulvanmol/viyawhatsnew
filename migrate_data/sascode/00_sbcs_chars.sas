/* 
 * generate a list of all possible single byte characters
 * supported by the current encoding
 *
 * windows default WLATIN1 (WINDOWS-1252)
 */
data chars;
  encoding = getoption("encoding");
  do i = 0 to 255;
    hexValue = put(i, hex2.);
    charValue = byte(i);
    output;
  end;
run;