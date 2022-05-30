************************************************************;
*    a) Submit the program and examine the results.        *;
*    b) Notice that the mpg_groups format is not applied.  *;
*    c) Edit the autoexec file as indicated in 		   *;
*	Activity: Editing the Autoexec File                *;
*    d) Submit the program and verify the format is applied*;
************************************************************;
proc freq data=sashelp.cars;/*1*/
	tables mpg_highway;/*2*/
	format mpg_highway mpg_groups.;/*3*/
	title "Fuel Efficiency by Groups";/*4*/
run;/*5*/

/*1. Invokes the FREQ procedure and identifies the input data.*/
/*2. Requests one-way to n-way frequency and crosstabulation tables and statistics for those tables.*/
/*3. Associates formats with variables.*/
/*4. Specifies title lines for SAS output.*/
/*5. Executes the previously entered SAS statements.*/