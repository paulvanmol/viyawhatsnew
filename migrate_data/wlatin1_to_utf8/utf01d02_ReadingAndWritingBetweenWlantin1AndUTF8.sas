/*Reading wlatin1 ANSI text file in UTF-8 sas session: Invalid characters in proc print*/
data temp;
	length subject $ 4 visit $ 10 com $ 100;
	infile "&path/wlatin1/TT_ANSI.txt" dlm=";" 
		missover lrecl=200;
	input subject $ visit $ com $;
run;

proc print;
run;

/*Reading wlatin1 ANSI text file in UTF-8 sas session: use encoding option on infile*/
data temp;
	length subject $ 4 visit $ 10 com $ 100;
	infile "&path/wlatin1/TT_ANSI.txt" dlm=";" 
		missover lrecl=200 encoding='wlatin1';
	input subject $ visit $ com $;
run;

proc print;
run;

/*Reading UTF-8 text file in UTF-8 sas session: all OK*/
data temp;
	length subject $ 4 visit $ 10 com $ 100;
	infile "&path/utf8/TT_UTF8.txt" dlm=";" missover 
		lrecl=200;
	input subject $ visit $ com $;
run;

proc print;
run;

/*Another solution is to use the KCVT function after you did the import in SAS without the ENCODING= option.
The KVCT function is of the form:
outstring = KVCT (instring, enc_in, enc_out);
Where,
instring - Input character string
enc_in - Encoding of instring
enc_out – Encoding of out string
outstring – Results of transcoding instring from enc_in to enc_out.
This function translates a variable from one encoding into another:
*/
data temp;
	length subject $ 4 visit $ 10 com $ 100;
	infile "&path/wlatin1/TT_ANSI.txt" dlm=";" 
		missover lrecl=200;
	input subject $ visit $ com $;
run;

proc print;
run;

data temp;
	set temp;
	com=KCVT (com, 'wlatin1', 'UTF-8');
run;

proc print;
run;

/*Importing excel sheets usually do not have this issue.
This because the encoding value is saved in the excel sheet itself,
so SAS can automatically convert this to its session encoding.*/
/*For example, the following code will import tt.xls:*/
/*proc import replace
datafile="&path/wlatin1/tt.xls" dbms=excel
out=temp;
run;*/
/*The following code will import tt.xlsx:*/
/*proc import replace datafile='/folders/myfolders/wlatin1_to_utf8/wlatin1/tt.xlsx' dbms=excel out=temp; run; */
/*proc import replace datafile='/folders/myfolders/wlatin1_to_utf8/wlatin1/tt.xlsx' dbms=excelcs out=temp; run; */
proc import replace 
		datafile="&path/wlatin1/tt.xlsx" dbms=xlsx 
		out=temp;
run;

/*CREATE EXTERNAL FILES
Creating a .TXT or an Excel file (using PROC EXPORT and DBMS=XLSX) from a UTF-8 encoded dataset is no problem.
Creating TEXT File
See the following example programs.*/
data temp;
	length unit $ 20;
	unit='μmol/L';
	output;
	unit='mmol/L';
	output;
	unit='会意字';
	output;
run;

** This creates a correct text file outp1.TXT (with encoding is UTF-8);

data _null_;
	set temp;
	file "&path/outp1.txt";
	put @1 unit $;
run;

/*Creating Excel File
One can use the following code to create a XLSX file.
 ** This creates a correct xlsx file outp1.XLSX;*/
proc export data=temp dbms=xlsx 
		outfile="&path/outp1.xlsx" replace;
run;

/*To create a correct XLS file, you can create a XLSX first.
Then open in Excel 2010 and save as type ‘Excel 97-2003 Workbook’. The code below will not be able to create a correct XLS file.
 ** This creates an incorrect xls file outp1.XLS;*/
proc export data=temp dbms=xls 
		outfile="&path/outp1.xls" replace;
run;

/*Or, one can use the KCVT function to create single-byte characters like we have in wlatin1
(as long as all characters can be converted to single byte in wlatin1):*/
data temp;
	set temp;
	unit=KCVT (unit, 'UTF-8', 'wlatin1');
run;

** This creates a correct text xls file outp2.XLS (for the μ sign);

proc export data=temp dbms=xls 
		outfile="&path/outp2.xls" replace;
run;