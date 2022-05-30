proc freq data=sashelp.shoes;/*1*/
	tables product /nocum;/*2*/
run;/*3*/

/*1. Begins a PROC step and provides the name and locations of the input SAS data sets.*/
/*2. Statement requests one-way to n-way frequency and crosstabulation tables and statistics for those tables.*/
/*3. Executes the previously entered SAS statements.*/
