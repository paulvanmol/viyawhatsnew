/*
 * DATA Steps read .sas files that are stored using different encodings
 *
 */
data code1;
  infile "&localProjectPath/demo/example_ansi.sas" truncover 
	/*encoding=wlatin1 */ 
;
  input @1 codeLine $1024.;
run;

title "example_ansi.sas %sysfunc(getoption(encoding))";
proc print data=code1;
run;

/*
 * run in wlatin1 encoding
 * text does not make sense
 * enabling the encoding= option will be able to read chars that are compatible
 * to the current encoding
 */
data code2;
  infile "&localProjectPath/demo/example_utf8.sas"
    truncover
/*    encoding='utf-8'*/
  ;
  input @1 codeLine $1024.;
run;

title "example_utf8.sas %sysfunc(getoption(encoding))";
proc print data=code2;
run;


/*
 * file has a byte order mark, therefor SAS nows how to read the data
 * no encoding= option necessary, as long as chars fit into current encdoging
 */
data code3;
  infile "&localProjectPath/demo/example_utf8_bom.sas" truncover;
  input @1 codeLine $1024.;
run;

title "example_utf8_bom.sas %sysfunc(getoption(encoding))";
proc print data=code3;
run;

