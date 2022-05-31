/*OPTION 1 USE THE OUTENCODING OPTION IN THE LIBNAME
For example:*/
libname y "&path/wlatin1" outencoding='wlatin1';

data y.temp_;
	x='μmol/L';
run;

proc contents;
run;
/*Note that the dataset y.temp_ is created with encoding wlatin1 and not UTF-8.
The variable length of unit is automatically set to 7.*/

proc print;
run;

/*OPTION 2 USE THE ENCODING OPTION WHEN YOU CREATE THE DATASET
For example:*/
libname y "&path/wlatin1";

data y.temp (encoding='wlatin1');
	x='μmol/L';
run;

proc contents;
run;

proc print;
run;

/*This creates the same output and log as first example.
Be careful with datasets and changing encoding: run the following program in SAS UTF-8 environment:*/
data hello;
	a=1;
run;

proc contents data=hello;
run;

data hello (encoding='wlatin1');
	b=1;
run;

proc contents data=hello;
run;

/*The listing shows us that the first dataset hello is in UTF-8 and the second dataset is in wlatin1, as expected.
But now run:*/
proc datasets;
	delete hello;
quit;

data hello (encoding='wlatin1');
	a=1;
run;

proc contents data=hello;
run;

data hello;
	b=1;
run;

proc contents data=hello;
run;
/*And see that the first dataset hello is in wlatin1, and the second is also in wlatin1. You need to explicitly say:
data hello (encoding='UTF-8'); for the second dataset, to become UTF-8.
But when the first dataset is created in wlatin1 environment, this is not needed. See example below.*/

/*Run the following code in wlatin1 environment.*/
libname x "&path/wlatin1";

/*data x.hello;
	a=1;
run;*/

proc contents data=x.hello;
run;

/*Then run the following code in UTF-8 environment.*/
libname x "&path/wlatin1";

proc contents data=x.hello;
run;

data x.hello;
	b=1;
run;

proc contents data=x.hello;
run;

/*And see that the first dataset hello is in wlatin1 and the second one is UTF-8 (created in UTF-8 system).*/