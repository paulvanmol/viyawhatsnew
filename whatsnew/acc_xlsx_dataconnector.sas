/* Test PC files connectivity. */
%let home=%sysget(HOME); 
%let path=/workshop/wnvy;

options dlcreatedir; 
libname wnvy "&path"; 
/* Export from SAS to Excel file. */
proc export
  data=sashelp.prdsale
	  dbms=xlsx
	  outfile="&path/prdsale.xlsx"
	  replace;
run;

/* Read in Excel file. */
libname test xlsx "&path/prdsale.xlsx";

data prdsale;
  set test.prdsale;
run;


/*PC FILE Data Connector to access an XLSX file:*/



/* Create an XLSX file to load into CAS
   Replace path-to with the location where
   you want to save the XLSX file to. For example
   /tmp/user/joe.
*/
proc export
  data=sashelp.prdsale
      dbms=xlsx
      outfile="&path/prdsale.xlsx"
      replace;
run;

/* Using PC Files Data Connector to
   load and save an XLSX file
*/
CAS mysess;
* drop source caslib;
proc cas;
table.dropcaslib caslib="myxlsx" quiet=true;
quit;
caslib myxlsx 
       type=path
       path="&path"; /*Directory location*/
      
proc cas;
session mysess;
table.loadTable /
casLib="myxlsx",
path="prdsale.xlsx"
casout="pcxlsx"
importOptions={fileType="excel"};
run;

proc cas;
session mysess;
action fetch format="true" table={name="pcxlsx"}
maxRows=500;
run;

proc cas;
    session mysess;
    action columnInfo / table={caslib="myxlsx" name="pcxlsx"};
run;

proc cas;
session mysess;
action table.save /
caslib="myxlsx" name="pcxlsx_out" replace=true
           table={caslib="myxlsx" 
                  name="pcxlsx"
                  vars={"ACTUAL", "PRODUCT"}}
           exportOptions={fileType="excel"};
run;
quit;