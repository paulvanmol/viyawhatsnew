%macro init_classpath_update;
	DATA _null_;
	    LENGTH  path_separator $ 2
	            orig_classpath $ 500;

	    DECLARE JavaObj f("java.io.File", "");
	    f.getStaticStringField("pathSeparator", path_separator);

	    orig_classpath = STRIP(SYSGET("CLASSPATH"));

	    IF _ERROR_ = 1 OR LENGTH(orig_classpath) = 0 THEN DO;
			PUT "NOTE: Ignore any messages from the next statement(s)";
	        orig_classpath = "";
		END;

	    CALL SYMPUTX('CP_orig_classpath', STRIP(orig_classpath), 'GLOBAL');
	    CALL SYMPUTX('CP_path_separator', COMPRESS(path_separator), 'GLOBAL');
	RUN;
%mend;

%macro add_to_classpath(cp_addition);
	DATA _null_;
	    LENGTH  current_classpath $ 500
	            new_classpath $ 500;

	    current_classpath = STRIP(SYSGET("CLASSPATH"));

	    IF _ERROR_ = 1 OR LENGTH(current_classpath) = 0 THEN DO;
			PUT "NOTE: Ignore any messages from the nearby statement(s)";
	        new_classpath = "&cp_addition";
		END;
	    ELSE DO;
        	new_classpath = COMPRESS(current_classpath) || "&CP_path_separator" || "&cp_addition";
		END;

	    CALL SYMPUTX('CP_new_classpath', STRIP(new_classpath), 'GLOBAL');
	RUN;

	%PUT NOTE: Setting Java classpath to &CP_new_classpath;
	OPTIONS SET=CLASSPATH "&CP_new_classpath";
%mend;

%macro reset_classpath;
	%PUT NOTE: Setting Java classpath back to its original state: &CP_orig_classpath;
	OPTIONS SET=CLASSPATH "&CP_orig_classpath";
%mend;
%init_classpath_update;
%let homedir=%sysget(HOME); 
%let path=&homedir;
%add_to_classpath(&path/viyawhatsnew/sdmx_query/SDMX.jar);

/*
%reset_classpath;
*/
