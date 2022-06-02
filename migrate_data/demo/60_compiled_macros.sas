/*Compiled macros have to be recompiled with the original source*/
libname mc1 "c:\workshop\lwmc1v2"; 
options mstored sasmstore=mc1; 
%macro printit(dsn=sashelp.class,obs=5)
		/store  ; 
proc print data=&dsn (obs=&obs); 
run; 
%mend; 
%printit(dsn=sashelp.class, obs=5)

/*Autocall Macros are recompiled*/
options mautosource 
sasautos=(sasautos "c:\workshop\lwmc1v2\autocall"); 
%printtable(dsn=sashelp.cars);
