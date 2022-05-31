/*EXAMPLE 1 NOT USE LENGTH STATEMENT*/
data temp;
	unit='mmol/L';
	output;
	unit='μmol/L';
	output;
run;

proc print;
run;

/*The unit μmol/L is not correct. However, the length of unit seems to be 6 for both mmol/L and μmol/L.*/
/*EXAMPLE 2 USE LENGTH STATEMENT*/
data temp;
	length unit $ 7;
	unit='mmol/L';
	output;
	unit='μmol/L';
	output;
run;

proc print;
run;

/*EXAMPLE 3 LENGTH FUNCTION VS. KLENGTH FUNCTION
Let us look at another example:*/
data temp;
	length unit $ 7;
	unit='mmol/L';
	output;
	unit='μmol/L';
	output;
run;

data temp;
	set temp;
	len=length(unit);
	klen=klength(unit);
run;

proc print;
run;

/*EXAMPLE 4 TRANSLATE FUNCTION VS. KTRANSLATE FUNCTION
One last example to demonstrate the difference between function TRANSLATE and KTRANSLATE:*/
data temp;
	unit='μmol/L';
	unit_translate=translate (unit, 'u', 'μ');
	** repl. μ with u-> unexpected outcome;
	unit_ktranslate=ktranslate(unit, 'u', 'μ');
	** repl. μ with u-> expected outcome;
run;

proc print;
run;