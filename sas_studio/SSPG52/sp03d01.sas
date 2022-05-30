/****************************************************/
/*						    */
/*	EXPLORING THE FEATURES OF SAS STUDIO EDITOR */
/*						    */
/****************************************************/
data HP_Cars;/*1*/
	set sashelp.cars;/*2*/
	where Type="SUV";/*3*/
	length HP_Category $ 15.;/*4*/
	if Horsepower <240 then
		HP_Category="Small"; /*5*/
	if Horsepower <280 then
		HP_Category="Midsize";/*5*/
	if Horsepower <400 then
		HP_Category="Large";/*5*/
run;/*6*/

proc print data=HP_Car;/*7*/
run;/*6*/

/*1. Begins a DATA step and provides names and locations of output SAS data sets.*/
/*2. Reads a row from one or more SAS data sets.*/
/*3. Selects rows from SAS data sets that meet a particular condition.*/
/*4. Specifies the number of bytes for storing character and numeric variables.*/
/*5. Executes a statement for rows that meet specific conditions.*/
/*6. Executes the previously entered SAS statements.*/
/*7. Prints observations in a SAS table using some or all of the variables.*/