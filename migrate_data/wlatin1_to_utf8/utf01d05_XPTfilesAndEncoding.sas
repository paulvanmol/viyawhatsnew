/*XPT FILES AND ENCODING*/
/*Suppose an XPT file with one or more datasets is created in wlatin1 environment, with encoding wlatin1.
What happens when you create SAS datasets from the wlatin1 XPT file in the UTF-8 environment?
UTF-8 SAS system will automatically create the SAS dataset into UTF-8, but will NOT convert the data automatically!
/*Run the following code in wlatin1 environment.*/
/*libname x 'D:\workshop\wlatin1_to_utf8\wlatin1';

data x.temp;
	length unit $10;
	*<-- this is important to have;
	unit='μmol/L';
run;

libname outdat xport 'D:\workshop\wlatin1_to_utf8\wlatin1\test.xpt';

proc copy in=x out=outdat memtype=data;
	select temp;
run;
*/
/*This creates a TEST.XPT file with one dataset temp.*/
/*Then run the code below in UTF-8 environment:*/
/*Notice that y.temp is created with the default encoding UTF-8, but that the print says (μ is missing)*/
/*To tell SAS that to convert or transcode the data, add and use the INENCODING at the libname.*/

libname xptfile xport "&path/wlatin1/test.xpt";
*libname y "&path/utf8" ;
libname y "&path/utf8" inencoding='wlatin1';

proc copy in=xptfile out=y memtype=data;
run;

proc contents data=y.temp;
run;

proc print data=y.temp;
run;

