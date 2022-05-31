/*WORKING WITH SAS DATASETS WITH WLATLIN1 ENCODING*/
/*Create a dataset temp in wlatin1 sas session*/
/*libname x "&path/wlatin1" ;
data x.tempx (encoding=wlatin1);
length unit $7;
unit ='μmol/L';
unit=KCVT (unit,'UTF-8', 'wlatin1');
run;
proc print; run;
*/
libname x "&path/wlatin1" inencoding=wlatin1;

proc print data=x.temp;
run;

/*OPTION 1 USE DATA STEP*/
proc copy inlib=x outlib=work;
	select temp;
run;

proc contents data=work.temp;
run;

data y;
	set temp;
run;

proc contents data=y;
run;

/*Creates Y in UTF-8, while X is created in wlatin1.
SAS gives a message in the LOG that dataset x is in another encoding.
If will give an error when data cannot be migrated from wlatin1 to UTF-8. Never ignore these error messages.
Please note that the statements below will NOT change the encoding (if the same dataset name is used).
When X is in wlatin1, x stays in wlatin1.*/
data temp;
	set temp;
run;

proc contents data=temp;
run;

/*You can force the transcoding by specifying that it needs to become UTF-8, using the dataset option ENCODING=.*/
data temp(encoding='UTF-8');
	set temp;
run;

proc contents data=temp;
run;

/*OPTION 2 USE PROC DATASETS
The second approach is to use PROC DATASETS as below:*/
proc datasets lib=libname;
	modify x/correctencoding='UTF-8';
	run;

	/*However, this way is NOT recommended: it only changes the encoder indicator but not actually translate the data itself!*/
	/*OPTION 3 USE PROC MIGRATE
	When you would like to convert multiple SAS datasets from wlatin1 into UTF-8, you can use PROC MIGRATE.*/
proc delete data=work.temp;
run;

libname x "&path/wlatin1";

proc migrate in=x out=work;
run;

proc contents data=temp;
run;