ODS noproctitle;/*1*/
title "Fish Count by Species";/*2*/
proc freq data=sashelp.fish order=freq;/*3*/
	tables species / plots=(freqplot);/*4*/
run;/*5*/

/*1. Suppresses the writing of the title of the procedure that produces the results.*/
/*2. Specifies title lines for SAS output.*/
/*3. Invokes the FREQ procedure and identifies the input data.*/
/*4. Requests one-way to n-way frequency and crosstabulation tables and statistics for those tables.*/
/*5. Executes the previously entered SAS statements.*/