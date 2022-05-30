/***********************************************************/
/*    a) Submit the program and view the generated output. */
/*       Notice all data cells have a yellow background.   */
/*    b) Use the CATALOG procedure to determine the name   */
/*       of the format that will apply custom colors to    */
/*       the values of the Inventory column.               */
/*    c) In the TABULATE step, replace LightYellow with    */
/*       the discovered format name.                       */
/***********************************************************/
libname mylib "/sasinside/home/student/SSPG";/*1*/
options fmtsearch=(mylib work);/*2*/

* Add a PROC CATALOG step to list the contents;
* of the MYLIB.FORMATS catalog                ;

proc catalog catalog=mylib.formats;/*A1*/
contents;/*A2*/
run;/*5.*/

proc sort data=sashelp.shoes out=work.shoeProducts;/*3*/
	by Region Product;/*4*/
run;/*5*/

* Replace LightYellow with the format name;
proc tabulate data=work.shoeproducts format=comma10.;/*6*/
	var Inventory;/*7*/
	class Region / order=formatted missing;/*8*/
	class Product / order=formatted missing;/*8*/
	table Region, Product*Inventory*sum={label=' '} 
			* {style={background=Inventory_range.}};/*9*/
	title1 'Product Inventory by Region';/*10*/
run;/*5*/

/*1. Associates a libref (a shortcut name) with a SAS library that is located on the server.*/
/*2. Specifies the order in which format catalogs are searched (mylib.formats, work.formats and library.formats).*/
/*3. Invokes the SORT procedure including input and output data.*/
/*4. Specifies the sorting variable.*/
/*5. Executes the previously entered SAS statements.*/
/*6. Invokes the TABULATE procedure including input data and a default format for each cell in the table.*/
/*7. Identifies numeric variables to use as analysis variables.*/
/*8. Identifies class variables for the table. Class variables determine the categories that PROC TABULATE uses to calculate statistics.*/
/*9. Describes a table to be printed.*/
/*10.Specifies title lines for SAS output.*/

/*A1. Invoked the CATALOG procedure, including the SAS catalog to process*/
/*A2. Lists the contents of a catalog in the procedure output */
